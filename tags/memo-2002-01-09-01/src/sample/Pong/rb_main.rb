#
# $Id$
#

require 'osx/cocoa'

######################
#### BEGIN CONFIG ####
######################
BUNDLE_NAME = :MainMenu

RUBY_SOURCES = [
  :PlayingView,
  :AppCtrl,
  :Model
]

SWITCH_INTERVAL = 0.005
######################
##### END CONFIG #####
######################

def rb_main_init
  RUBY_SOURCES.each {|src| require src.to_s }
end

def ns_app_main
  OSX.ruby_thread_switcher_start (SWITCH_INTERVAL)
  app = OSX::NSApplication.sharedApplication
  OSX::NSBundle.loadNibNamed_owner (BUNDLE_NAME.to_s, app)
  OSX.NSApp.run
end

if $0 == __FILE__ then
  rb_main_init
  ns_app_main
end
