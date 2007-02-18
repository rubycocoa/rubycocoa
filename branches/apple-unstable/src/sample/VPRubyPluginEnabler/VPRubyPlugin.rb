# -*- mode:ruby; indent-tabs-mode:nil; coding:utf-8 -*-
#
#  VPRubyPlugin.rb
#  RubyPluginEnabler
#
#  Created by Fujimoto Hisa on 07/02/02.
#  Copyright (c) 2007 FOBJ SYSTEMS. All rights reserved.

require 'osx/cocoa'
require 'VPRubyScript'

class VPRubyPlugin < OSX::NSObject
  include OSX

  def self.logger=(log) @@logger = log end
  def self.loginfo(fmt, *args) @@logger.info(fmt, *args) end
  def self.logerror(err)       @@logger.error(err)       end

  def self.install(enabler)
    if not defined? @@instance then
      @@instance = self.alloc.initWithEnabler(enabler)
    end
  end

  def initWithEnabler(enabler)
    @scripts = []
    @enabler = enabler
    load_scripts
    install_menu
    return self
  end

  def manager; @enabler.pluginManager end

  private

  def loginfo(fmt, *args) VPRubyPlugin.loginfo(fmt, *args) end
  def logerror(err)       VPRubyPlugin.logerror(err)       end

  def load_scripts
    bundle = OSX::NSBundle.bundleForClass(self.class)
    path = "#{bundle.resourcePath.to_s}/Script PlugIns/*.rb"
    Dir[path].each do |path|
      begin
        @scripts << VPRubyScript.load(path)
      rescue Exception => err
        logerror(err)
      end
    end
  end

  def install_menu
    @scripts.each do |i|
      manager.objc_send( :addPluginsMenuTitle, i.menuTitle,
                          :withSuperMenuTitle, i.superMenuTitle,
                                      :target, i,
                                      :action, i.selector,
                               :keyEquivalent, i.shortcutKey,
                   :keyEquivalentModifierMask, i.shortcutMask )
    end
  end
end
