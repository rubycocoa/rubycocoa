# -*- mode:ruby; indent-tabs-mode:nil; coding:utf-8 -*-
#
#  ruby_anywhere.rb
#  RubyAnywhere
#
#  Created by Fujimoto Hisa on 07/02/01.
#  Copyright (c) 2007 FOBJ SYSTEMS. All rights reserved.
#
require 'osx/cocoa'

module RubyAnywhere

  @@host_app = nil

  def nslog(fmt, *args)
    OSX.NSLog("RubyAnywhere: %@", (fmt % args))
  end
  module_function :nslog

  def logerr(err)
    nslog("failed - %s", err)
    err.backtrace.each { |s| nslog("  %s", s) }
  end
  module_function :logerr

  def host_app
    @@host_app ||= OSX::NSApplication.sharedApplication
  end
  module_function :host_app

end

RubyAW = RubyAnywhere unless defined? RubyAW
