# -*- mode:ruby; indent-tabs-mode:nil; coding:utf-8 -*-
#
#  VPRubyPlugin.rb
#  RubyPluginEnabler
#
#  Created by Fujimoto Hisa on 07/02/02.
#  Copyright (c) 2007 FOBJ SYSTEMS. All rights reserved.
#
require 'osx/cocoa'

class VPRubyPlugin
  @@instance = nil

  def self.instance; @@instance ||= self.new end
  def self.load;     self.instance end
  def self.manager;  self.instance.manager end

  def manager
    OSX::VPRubyPluginEnabler.realInstance.pluginManager
  end
end
