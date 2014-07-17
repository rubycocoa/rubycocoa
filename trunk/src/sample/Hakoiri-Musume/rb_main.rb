#!/usr/bin/env ruby
#
# $Id$
#

if RUBY_VERSION < '1.9'
  $KCODE = 'e'
end
require 'hako'
require 'cocoa_hako'

lang = 
  if /ja/ =~ ENV['LANG'] then 'ja' else nil end

Hako::Game.new(CocoaHako.alloc.initWithParent_unitSize(nil, 64), lang)
OSX::NSApp.run
