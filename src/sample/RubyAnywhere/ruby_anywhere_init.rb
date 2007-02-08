# -*- mode:ruby; indent-tabs-mode:nil; coding:utf-8 -*-
#
#  ruby_anywhere_init.rb
#  RubyAnywhere
#
#  Created by Fujimoto Hisa on 07/02/01.
#  Copyright (c) 2007 FOBJ SYSTEMS. All rights reserved.
#

require 'osx/cocoa'

def hoge
  raise "hoge"
end

OSX.init_bundle_for_class(OSX::RubyAnywhereLoader) do
  require 'ruby_anywhere'
  require 'RcodeController'
  rcode = RcodeController.instance
  OSX::NSBundle.loadNibNamed_owner("Rcode.nib", rcode)
end
