#
#  rb_main.rb
#  HybridLangApp
#
#  Created by FUJIMOTO Hisakuni on Tue Dec 17 2002.
#  Copyright (c) 2002 __MyCompanyName__. All rights reserved.
#

require 'osx/cocoa'

def rb_main_init
  path = OSX::NSBundle.mainBundle.resourcePath.to_s
  rbfiles = Dir.glob(File.join(path, '*.rb')) - [ __FILE__ ]
  rbfiles.each {|path| require(path) }
end

if $0 == __FILE__ then
  rb_main_init
  OSX.NSApplicationMain(0, nil)
end
