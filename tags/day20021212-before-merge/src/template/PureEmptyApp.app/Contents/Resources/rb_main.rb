#
# $Id$
#

require 'osx/cocoa'

app = OSX::NSApplication.sharedApplication
app.setMainMenu (OSX::NSMenu.alloc.init)
OSX.NSApp.run
