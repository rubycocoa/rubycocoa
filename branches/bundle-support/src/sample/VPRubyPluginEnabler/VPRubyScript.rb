# -*- mode:ruby; indent-tabs-mode:nil; coding:utf-8 -*-
#
#  VPRubyScript.rb
#  VPRubyPluginEnabler
#
#  Created by Fujimoto Hisa on 07/02/09.
#  Copyright (c) 2007 FOBJ SYSTEMS. All rights reserved.

require 'osx/cocoa'

class VPRubyScript < OSX::NSObject

  def loginfo(fmt, *args) VPRubyPlugin.loginfo(fmt, *args) end
  def logerror(err)       VPRubyPlugin.logerror(err)       end

  def self.load(path) parse(File.read(path), path) end
  def self.parse(str, fname, lineno = 1)
    obj = self.alloc.init
    obj.parse(str, fname, lineno = 1)
    return obj
  end

  def parse(str, fname = nil, lineno = 1)
    instance_eval(str, fname, lineno)
  end

  def selector; 'execute:' end

  def execute(windowController)
    @procedure.call(windowController)
  rescue Exception => err
    logerror(err)
  end
  objc_method :execute, [:void, :id]

  def shortcutMask
    warn "FIXME - shortcutMask"
    return 0 # if @spec[:shortcutMask].nil?
  end

  private

  def vp_script(spec, &blk)
    @spec = spec
    @procedure = blk
  end
  
  class << self
    def spec_reader(*keys)
      keys.each { |key| define_method(key) { @spec[key] } }
    end
  end

  spec_reader :menuTitle, :superMenuTitle, :shortcutKey
end
