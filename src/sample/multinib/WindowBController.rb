require 'osx/cocoa'

class WindowBController < OSX::OCObject

  ib_outlets :window

  def initialize
    OSX::NSBundle.loadNibNamed ("WindowB", :owner, self)
  end

  def showWindow
    @window.makeKeyAndOrderFront (self)
  end

end
