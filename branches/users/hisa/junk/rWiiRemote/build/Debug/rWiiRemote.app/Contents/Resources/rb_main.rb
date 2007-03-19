#
#  rb_main.rb
#  rWiiRemote
#
#  Created by Fujimoto Hisa on 06/12/13.
#  Copyright (c) 2006 Fujimoto Hisa. All rights reserved.
#

require 'osx/cocoa'

OSX.init_for_bundle do |bdl,prm,log|
  require 'WiiRemocon'
  require 'GraphView'
  require 'AppController'
end
