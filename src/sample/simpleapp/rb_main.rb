#
#  rb_main.rb
#  SimpleApp
#
#  Created by FUJIMOTO Hisakuni on Sat Sep 07 2002.
#  Copyright (c) 2002 __MyCompanyName__. All rights reserved.
#

require 'osx/cocoa'

######################
#### BEGIN CONFIG ####
######################
BUNDLE_NAME = :MainMenu

RUBY_SOURCES = [
  :AppController,
  :MyView,
]

######################
##### END CONFIG #####
######################

def rb_main_init
  RUBY_SOURCES.each {|src| require src.to_s }
end

def ns_app_main
  OSX.ruby_thread_switcher_start (0.05, 0.05)
  app = OSX::NSApplication.sharedApplication
  OSX::NSBundle.loadNibNamed_owner (BUNDLE_NAME.to_s, app)
  OSX.NSApp.run
end

if $0 == __FILE__ then
  rb_main_init
  ns_app_main
end
