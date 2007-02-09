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

  def self.load(enabler)
    @@instance ||= self.new(enabler) 
  end

  def self.instance; @@instance end
  def self.manager;  instance.manager end

  def initialize(enabler)
    @enabler
  end

  def manager
    @enabler.pluginManager
  end
end
