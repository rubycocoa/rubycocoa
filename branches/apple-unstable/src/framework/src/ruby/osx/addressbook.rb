#  Copyright (c) 2006 Laurent Sansonetti

require 'osx/cocoa'

STDERR.puts "The osx/addressbook script has been deprecated, and its use is now discouraged. Please do `OSX.require_framework \"AddressBook\"` instead."
OSX.require_framework 'AddressBook'
