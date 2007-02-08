# -*- mode:ruby; indent-tabs-mode:nil; coding:utf-8 -*-
#
#  vpr_init.rb
#  RubyPluginEnabler
#
#  Created by Fujimoto Hisa on 07/02/02.
#  Copyright (c) 2007 FOBJ SYSTEMS. All rights reserved.
#

require 'osx/cocoa'

OSX.init_bundle_for_class(OSX::VPRubyPluginEnabler) do
  require 'VPRubyPlugin'
  VPRubyPlugin.load
end
