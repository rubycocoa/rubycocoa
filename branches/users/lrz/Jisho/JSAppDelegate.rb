#
#  JSAppDelegate.rb
#  Jisho
#
#  Created by Laurent Sansonetti on 11/27/06.
#  Copyright (c) 2001 Apple Computer. All rights reserved.
#

class JSAppDelegate < NSObject
  ib_outlet :windowController

  def applicationDidFinishLaunching(notification)
    service = JSService.alloc.initWithWindowController(@windowController)
    notification.object.setServicesProvider(service)
  end
end
