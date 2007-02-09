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

  def self.load(path)
    return self.alloc.initWithPath(path)
  end

  attr_reader :selector

  %w( menuTitle superMenuTitle shortcutKey ).each do |key|
    define_method(key) { @spec[key.to_sym] }
  end

  def shortcutMask
    warn "FIXME - shortcutMask"
    return 0 # if @spec[:shortcutMask].nil?
  end

  def initWithPath(path)
    @selector = 'execute:'
    @path = path
    parse!
    return self
  end

  def execute(windowController)
    parse!
    @procedure.call(windowController)
  rescue Exception => err
    logerror(err)
  end
  objc_method :execute, [:void, :id]

  private

  def parse!
    prog = File.read(@path)
    instance_eval(prog, @path, 1) # => invoke v_pscript
  end

  def vp_script(spec, &blk)
    @spec = spec
    @procedure = blk
  end
end
