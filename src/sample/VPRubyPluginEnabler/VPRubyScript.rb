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

  # FIXME - cant access constants from RBBundleInit of RubyCocoa
  SHORTCUT_MASKS = {
    :alpha_shift => 65536,      # OSX::NSAlphaShiftKeyMask
    :alternate   => 524288,     # OSX::NSAlternateKeyMask
    :command     => 1048576,    # OSX::NSCommandKeyMask
    :control     => 262144,     # OSX::NSControlKeyMask
    :function    => 8388608,    # OSX::NSFunctionKeyMask
    :help        => 4194304,    # OSX::NSHelpKeyMask
    :numeric_pad => 2097152,    # OSX::NSNumericPadKeyMask
    :shift       => 131072,     # OSX::NSShiftKeyMask
  }

  def shortcutMask
    mask = @spec[:shortcutMask]
    if mask.is_a? Array then
      mask = mask.inject(0) { |product, key|
        val = if key.is_a?(Integer) 
              then key
              else SHORTCUT_MASKS[key.to_sym] || 0 end
        product + val             # => next product
      }
    end
    return mask.to_i
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

  def vp_spec(spec)
    @spec = spec
  end

  def vp_action(&blk)
    @procedure = blk
  end

  def vp_script(spec, &blk)
    @spec = spec
    @procedure = blk
  end
end
