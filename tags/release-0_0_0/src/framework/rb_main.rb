#
# $Id$
#
#   Copyright (c) 2001 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
#

require 'osx/cocoa'
require 'rb_controller'

#### BEGIN CONFIG ####
BUNDLE_NAME = :MainMenu

RUBY_CLASSES = [
  'HogeController'
]
#### END CONFIG ####

def rb_main_init
  RUBY_CLASSES.each {|name| require name }
end

def ns_app_main
  app = OSX::NSApplication.sharedApplication
  OSX::NSBundle.loadNibNamed_owner (BUNDLE_NAME.to_s, app)
  OSX.NSApp.run
end

if $0 == __FILE__ then
  rb_main_init
  ns_app_main
end
