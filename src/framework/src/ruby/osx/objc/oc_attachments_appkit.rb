#
#  $Id: oc_attachments.rb 1332 2007-01-04 03:15:32Z hisa $
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni
#

module OSX

  # NSImage additions
  class NSImage
    def focus
      lockFocus
      begin
        yield
      ensure
        unlockFocus
      end
    end
  end
end
