# -*- mode:ruby; indent-tabs-mode:nil; coding:utf-8 -*-
#
#  ri_contents.rb
#  CocoaRepl
#
#  Created by Fujimoto Hisa on 07/03/01.
#  Copyright (c) 2007 FUJIMOTO Hisa, FOBJ SYSTEMS. All rights reserved.
#
require 'rdoc/ri/ri_paths'
require 'rdoc/ri/ri_cache'
require 'ri_entry'

class RiContents
  
  def self.instance
    if defined? @@instance
    then @@instance
    else @@instance = new end
  end

  def initialize
    paths = RI::Paths::PATH
    @cache = RI::RiCache.new(paths)
    @classes = @methods = nil
    @class_methods = @instance_methods = nil
    @class_names = @method_names = nil
    @class_method_names = @instance_method_names = nil
  end

  def lookup_name(key, *options)
    key = _pattern_for(key, *options)
    result = []
    result.concat( lookup_class_name(key,  *options) )
    result.concat( lookup_method_name(key, *options) )
    result
  end

  def lookup_class_name(key, *options)
    key = _pattern_for(key, *options)
    lookup_name_for(class_names, key) 
  end

  def lookup_method_name(key, *options)
    key = _pattern_for(key, *options)
    lookup_name_for(method_names, key)
  end

  def lookup(key, *options)
    key = _pattern_for(key, *options)
    result = []
    result.concat( lookup_class(key,  *options) )
    result.concat( lookup_method(key, *options) )
    result
  end

  def lookup_class(key, *options)
    key = _pattern_for(key, *options)
    lookup_for(classes, key) 
  end

  def lookup_method(key, *options)
    key = _pattern_for(key, *options)
    lookup_for(methods, key)
  end

  def classes
    @classes || @classes = _make_classes 
  end

  def methods
    @methods || @methods = class_methods + instance_methods
  end

  def class_methods
    @class_methods || @class_methods = _make_class_methods
  end

  def instance_methods
    @instance_methods || @instance_methods = _make_instance_methods
  end

  def class_names
    @class_names || @class_names = classes.map{ |i| i.name }.uniq
  end

  def method_names
    @method_names || 
      @method_names = class_method_names + instance_method_names
  end

  def class_method_names
    @class_method_names ||
      @class_method_names = class_methods.map{ |i| i.name }.uniq
  end

  def instance_method_names
    @instance_method_names ||
      @instance_method_names = instance_methods.map{ |i| i.name }.uniq
  end

  private

  def _pattern_for(key, *options)
    case key
    when String then
      keys = []
      keys << key[0].chr unless /^(\*|ns|osx)/i =~ key
      key = Regexp.escape(key.to_s)
      key.gsub!(/\\\*/,'.*')
      if options.include?(:entire) then
        keys << /^#{key}$/i 
      else
        keys << /^#{key}/i
      end
      keys
    when Regexp then  [ key ]
    when Array  then  key
    else
      raise TypeError, "require String or Regexp for key=#{key.inspect}"
    end
  end

  def lookup_for(ary, patterns)
    ary.select { |c|
      name = c.name
      not_matched = patterns.find { |ptn|
        case ptn
        when String then ptn != name[0, ptn.length]
        when Regexp then ! ptn.match(name)
        end
      }
      ! not_matched
    }
  end

  def lookup_name_for(ary, patterns)
    ary.select { |name|
      not_matched = patterns.find { |ptn|
        case ptn
        when String then ptn != name[0, ptn.length]
        when Regexp then ! ptn.match(name)
        end
      }
      ! not_matched
    }
  end

  def _make_classes
    ary = []
    _each_class { |c| ary << c }
    ary
  end

  def _make_class_methods
    classes.inject([]) { |ary,c| ary.concat(c.class_methods) }
  end

  def _make_instance_methods
    classes.inject([]) { |ary,c| ary.concat(c.instance_methods) }
  end

  def _each_class(klass = nil, &blk)
    if klass.nil? then
      klass = @cache.toplevel
    else
      blk.call(klass)
    end
    klass.classes_and_modules.each { |c| _each_class(c, &blk) }
  end
end
