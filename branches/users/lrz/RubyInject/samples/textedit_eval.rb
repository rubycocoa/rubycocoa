require 'osx/cocoa'
include OSX

b = NSButton.alloc.init
b.title = "Evaluate!"
b.bezelStyle = NSRoundedBezelStyle
b.sizeToFit

w = NSApp.windows[0]
w.contentView.addSubview(b)

$tv = w.contentView.subviews[0].subviews[0].subviews[0]

class ButtonController < NSObject
  def buttonClicked(sender)
    NSLog('buttonClicked!')
    ($tv.string += ' # %s' % eval($tv.string) rescue nil)
  end
end

b.target = ButtonController.alloc.init
b.action = 'buttonClicked:'

NSRunLoop.currentRunLoop.run
