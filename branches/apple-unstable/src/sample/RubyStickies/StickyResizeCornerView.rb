#
#  StickyResizeCornerView.rb
#  Stickies
#
#  Created by Laurent Sansonetti on 1/4/07.
#  Copyright (c) 2007 Apple Computer. All rights reserved.
#

class StickyResizeCornerView <  NSView
  
  def drawRect(rect)
    r = bounds
    NSColor.brownColor.set
    NSBezierPath.strokeLineFromPoint_toPoint(
        NSZeroPoint, NSPoint.new(r.origin.x + r.size.width, r.origin.y + r.size.height))
  end

  def acceptsFirstMouse(theEvent); true; end

=begin
  # FIXME this doesn't work!
  def mouseDragged(theEvent)
    f = frame
    w, h = f.size.width, f.size.height
    newWidth = w + theEvent.deltaX
    newHeight = h + theEvent.deltaY
    minSize = window.minSize
    if newHeight >= minSize.height
      f.size.height = newHeight
      f.origin.y -= theEvent.deltaY    
    end
    if newWidth >= minSize.width
      f.size.width = newWidth
    end
    window.setFrame_display(f, true)
  end
=end

end
