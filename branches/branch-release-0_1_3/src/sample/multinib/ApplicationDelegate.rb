require 'osx/cocoa'
require 'WindowAController'
require 'WindowBController'

class ApplicationDelegate < OSX::OCObject

  ib_loadable :NSObject

  def createWindowA (sender)
    controller = WindowAController.createInstance
    controller.showWindow (self)
  end

  def createWindowB (sender)
    controller = WindowBController.new
    controller.showWindow
  end

end
