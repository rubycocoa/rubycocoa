#
# $Id$
#

require 'osx/cocoa'

######################
#### BEGIN CONFIG ####
######################
BUNDLE_NAME = :MainMenu

RUBY_SOURCES = [
  :AppController
]

SWITCH_INTERVAL = 0.1
######################
##### END CONFIG #####
######################

def rb_main_init
  RUBY_SOURCES.each {|src| require src.to_s }
end

def ns_app_main
  if SWITCH_INTERVAL && SWITCH_INTERVAL > 0.0 then
    OSX.ruby_thread_switcher_start (SWITCH_INTERVAL)
  end
  app = OSX::NSApplication.sharedApplication
  OSX::NSBundle.loadNibNamed_owner (BUNDLE_NAME.to_s, app)
  OSX.NSApp.run
end

if $0 == __FILE__ then
  rb_main_init
  ns_app_main
end
