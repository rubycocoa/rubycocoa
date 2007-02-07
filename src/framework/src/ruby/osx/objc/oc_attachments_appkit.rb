#
#  $Id: oc_attachments.rb 1332 2007-01-04 03:15:32Z hisa $
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni
#

module OSX

  # attachment module for NSImage group
  module RCImageAttachment
    def focus
      lockFocus
      begin
        yield
      ensure
        unlockFocus
      end
    end
  end
  OSX::NSImage.class_eval 'include RCImageAttachment'

end
