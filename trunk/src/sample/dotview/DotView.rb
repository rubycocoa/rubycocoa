require 'osx/ocobject'

class DotView < OSX::OCObject

  ib_loadable :NSView
  ib_outlets :colorWell, :sizeSlider
  derived_methods 'drawRect:', 'isOpaque', 'mouseUp:'

  def initialize(frame)
    @center = OSX::NSPoint.new (frame.size.width / 2,
				frame.size.height / 2)
    @color = OSX::NSColor.redColor
    @radius = 10.0
  end

  def awakeFromNib
    @colorWell.setColor (@color)
    @sizeSlider.setFloatValue (@radius)
  end

  def drawRect (rect)
    OSX::NSColor.whiteColor.set
    OSX::NSRectFill (bounds)
    dot_rect = OSX::NSRect.new (@center.x - @radius, @center.y - @radius,
			       2 * @radius, 2 * @radius)
    @color.set
    OSX::NSBezierPath.bezierPathWithOvalInRect(dot_rect).fill
  end

  def isOpaque
    true
  end

  def mouseUp (event)
    @center = convertPoint (event.locationInWindow, :fromView, nil)
    setNeedsDisplay true
  end

  def setColor (sender)
    @color = sender.color
    setNeedsDisplay true
  end

  def setRadius (sender)
    @radius = sender.floatValue
    setNeedsDisplay true
  end

end
