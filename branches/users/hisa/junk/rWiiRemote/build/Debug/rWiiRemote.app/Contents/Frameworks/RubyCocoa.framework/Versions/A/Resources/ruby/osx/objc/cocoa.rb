#
#  $Id: cocoa.rb 1407 2007-01-10 18:16:01Z lrz $
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni
#

require 'osx/objc/foundation'

OSX.require_framework('CoreGraphics')
OSX.require_framework('AppKit')

require 'osx/objc/oc_types_appkit'
require 'osx/objc/oc_attachments_appkit'
