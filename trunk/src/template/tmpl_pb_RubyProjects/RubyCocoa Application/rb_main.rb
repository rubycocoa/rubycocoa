#
#  rb_main.rb
#  ÇPROJECTNAMEÈ
#
#  Created by ÇFULLUSERNAMEÈ on ÇDATEÈ.
#  Copyright (c) ÇYEARÈ ÇORGANIZATIONNAMEÈ. All rights reserved.
#

require 'osx/cocoa'

def rb_main_init
  path = OSX::NSBundle.mainBundle.resourcePath.to_s
  rbfiles = Dir.glob(File.join(path, '*.rb')) - [ __FILE__ ]
  rbfiles.each {|path| require (path) }
end

if $0 == __FILE__ then
  rb_main_init
  OSX.NSApplicationMain (0, nil)
end
