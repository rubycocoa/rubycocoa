#
# $Id: TMAppDelegate.rb,v 1.1 2005/11/23 15:02:17 kimuraw Exp $
#

require 'osx/cocoa'
require 'TMDefaultsController'

class TMAppDelegate < OSX::NSObject

  def awakeFromNib
    nil
  end

  def changeFont(sender)
    font = sender.selectedFont
    return unless font

    defaults['textFontName'] = font.fontName
  end
  
  # action
  def showFontPanel(sender)
    font = OSX::NSFont.fontWithName(defaults['textFontName'], :size, 36.0)
    manager = OSX::NSFontManager.sharedFontManager
    manager.setSelectedFont(font, :isMultiple, false)
    manager.orderFrontFontPanel(self)
  end

  def defaults
    TMDefaultsController.sharedUserDefaultsController
  end

end
