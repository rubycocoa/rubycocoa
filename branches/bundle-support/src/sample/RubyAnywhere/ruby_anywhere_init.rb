# -*- mode:ruby; indent-tabs-mode:nil; coding:utf-8 -*-
#
#  ruby_anywhere_init.rb
#  RubyAnywhere
#
#  Created by Fujimoto Hisa on 07/02/01.
#  Copyright (c) 2007 FOBJ SYSTEMS. All rights reserved.
#

require 'osx/cocoa'

OSX::BundleSupport.do_for_class(OSX::RubyAnywhereLoader) do
  begin
    require 'ruby_anywhere'
    require 'RcodeController'
    rcode = RcodeController.instance
    OSX::NSBundle.loadNibNamed_owner("Rcode.nib", rcode)
    RubyAW.nslog("ruby_anywhere_init.rb (%s) loaded.", 
                 OSX::NSProcessInfo.processInfo.processName)
  rescue Exception => err
    RubyAW.logerr(err)
  end
end
