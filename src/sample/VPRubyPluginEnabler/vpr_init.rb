# -*- mode:ruby; indent-tabs-mode:nil; coding:utf-8 -*-
#
#  vpr_init.rb
#  RubyPluginEnabler
#
#  Created by Fujimoto Hisa on 07/02/02.
#  Copyright (c) 2007 FOBJ SYSTEMS. All rights reserved.
#

require 'osx/cocoa'

def nslog(fmt, *args)
  OSX.NSLog("vpr_init.rb: %@", (fmt % args))
end
    
def logerr(err)
  nslog("failed - %s", err)
  err.backtrace.each { |s| nslog("  %s", s) }
end
    
OSX::BundleSupport.do_for_class(OSX::VPRubyPluginEnabler) do
  begin
    require 'VPRubyPlugin'
    VPRubyPlugin.load
    nslog("vpr_init.rb done.")
  rescue Exception => err
    logerr(err)
  end
end
