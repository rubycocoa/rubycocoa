require 'osx/cocoa'

class WindowAController < OSX::OCObject

  ib_loadable :NSWindowController

  def WindowAController.createInstance
    OSX::WindowAController.alloc.initWithWindowNibName "WindowA"
  end

end
