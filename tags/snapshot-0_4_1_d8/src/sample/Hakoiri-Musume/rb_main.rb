#!/usr/bin/ruby
#
# $Id$
#

require 'hako'
require 'cocoa_hako'

lang = 
  if /ja/ =~ ENV['LANG'] then 'ja' else nil end

Hako::Game.new(CocoaHako.alloc.init(nil, 64), lang)
OSX.NSApp.run
