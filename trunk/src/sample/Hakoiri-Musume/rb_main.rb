#!/usr/bin/env ruby
#
# $Id$
#

$KCODE = 'e'
require 'hako'
require 'cocoa_hako'

lang = 
  if /ja/ =~ ENV['LANG'] then 'ja' else nil end

Hako::Game.new(CocoaHako.alloc.initWithParent_unitSize(nil, 64), lang)
OSX::NSApp.run
