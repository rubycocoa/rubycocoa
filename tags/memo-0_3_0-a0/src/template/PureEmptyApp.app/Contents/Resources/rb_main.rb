#
# $Id$
#

require 'osx/cocoa'

OSX.ruby_thread_switcher_start (0.05)

app = OSX::NSApplication.sharedApplication
app.setMainMenu (OSX::NSMenu.alloc.init)
OSX.NSApp.run
