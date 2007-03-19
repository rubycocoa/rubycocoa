#
#  AppController.rb
#  rWiiRemote
#
#  Created by Fujimoto Hisa on 06/12/29.
#  Copyright (c) 2006 Fujimoto Hisa. All rights reserved.
#

require 'osx/cocoa'

class AppController < OSX::NSObject
  ib_outlet :rubyVersion, :rubyCocoaVersion

  def applicationDidFinishLaunching(aNotification)
    @rubyVersion.setStringValue(RUBY_VERSION)
    @rubyCocoaVersion.setStringValue(OSX::RUBYCOCOA_VERSION)
  end

end
