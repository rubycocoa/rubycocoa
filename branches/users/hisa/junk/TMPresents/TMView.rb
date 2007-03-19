#
# $Id: TMView.rb,v 1.12 2005/11/29 15:24:54 kimuraw Exp $
#
require 'osx/cocoa'
require 'TMDefaultsController'

module OSX

  class NSSize
    def *(ratio)
      return OSX::NSSize.new(self.width * ratio, self.height * ratio)
    end
  end

end

class TMView < OSX::NSView
  
  BASE_FONTSIZE = 36.0
  
  def initialize
    @text = nil
    @align = :center
    @outcolor = nil #
  end

  def initWithFrame(frame)
    super_initWithFrame(frame)
    center = OSX::NSNotificationCenter.defaultCenter
    center.objc_send( :addObserver, self,
                      :selector, 'defaultsChanged:',
                      :name, OSX::NSUserDefaultsDidChangeNotification,
                      :object, nil)
    return self
  end
  
  # "str" must be NSString
  def text=(str)
    @text = str
    setNeedsDisplay(true)
  end

  def draw_back(rect)
    super_drawRect(rect)
    if color_wiped?
      wipe(@outcolor)
      return false
    end
    return false unless @text
    wipe(defaults['backgroundColor'])
    true
  end

  def draw_fore(rect)
    base_size = unit_size(@text)
    ratio = resize_ratio(base_size, draw_size)
    text_rect = text_rect(base_size * ratio, draw_size)
    @text.drawInRect_withAttributes(text_rect, text_attrs(ratio))
  end

  def drawRect(rect)
    draw_back(rect) && draw_fore(rect)
  end

  def defaultsChanged(notification)
    setNeedsDisplay(true)
  end

  private

  def defaults
    TMDefaultsController.sharedUserDefaultsController
  end

  def resize_ratio(base_size, view_size)
    ratio_w = view_size.width / base_size.width
    ratio_h = view_size.height / base_size.height
    return [ratio_w, ratio_h].min
  end

  def text_rect(text_size, view_size) 
    return [0, (view_size.height - text_size.height) / 2 + save_height,
      view_size.width, text_size.height]
  end

  def draw_size
    OSX::NSSize.new(bounds.size.width, bounds.size.height - save_height)
  end

  def save_height
    if defaults['keepBottomSpace'].to_i == 1
      return bounds.size.height * 0.2
    else
      return 0.0
    end
  end

  def unit_size(text)
    return text.sizeWithAttributes(text_attrs)
  end

  def wipe(color)
    color.set
    OSX.NSRectFill(bounds)
  end

  def text_attrs(ratio = 1.0)
    font = OSX::NSFont.fontWithName_size(defaults['textFontName'],
                                         BASE_FONTSIZE * ratio)
    style = paragragh_style
    return {OSX::NSFontAttributeName => font,
      OSX::NSForegroundColorAttributeName => defaults['textColor'],
      OSX::NSParagraphStyleAttributeName => style}
  end

  def paragragh_style
    style = OSX::NSParagraphStyle.defaultParagraphStyle.mutableCopy
    case @align
    when :left
      align = OSX::NSLeftTextAlignment
    else
      align = OSX::NSCenterTextAlignment
    end
    style.setAlignment(align)
    style.setLineBreakMode(OSX::NSLineBreakByClipping)
    return style
  end

  def color_wiped?
    @outcolor ? true : false
  end
  
end

# user oparations
class TMView

  ColorOutMap = {'b' => 'black', 'w' => 'white'}

  def mouseUp(event)
    return if color_wiped?
    window.windowController.goToNext(self)
  end

  def keyUp(event)
    if /^e/i =~ event.charactersIgnoringModifiers.to_s then
      window.windowController.evalPage(self)
      ResultView.instance.show
    end
  end

  def keyDown(event)
    if /^e/i =~ event.charactersIgnoringModifiers.to_s then
      return
    end
    if color_wiped?
      colorout(nil)
      return
    end

    if color = wipe_color(event)
      colorout(color)
    elsif event.charactersIgnoringModifiers.characterAtIndex(0) != 27 # escape
      window.windowController.goToNext(self)
    else
      window.windowController.stopFullScreen(self)
    end
  end

  def acceptsFirstResponder
    return true
  end

  # cancelOperation is declared in NSResponder.h, but not implemented
  def cancelOperation(sender)
    window.windowController.stopFullScreen(sender)
  end
  
  private

  def wipe_color(event)
    keys = event.characters.to_s
    return false unless keys and keys.size > 0 

    return ColorOutMap[keys[0, 1]]
  end

  def colorout(colorname)
    if colorname
      color = OSX::NSColor.send("#{colorname}Color")
      color = OSX::NSColor.blackColor unless color # bad color name
      @outcolor = color
    else
      @outcolor = nil
    end
    setNeedsDisplay(true)
  end
  private :colorout

end

# support left align
class TMView

  # "str" must be ruby String
  # set left alignment when str is indented
  def unformat_text=(str)
    src, indented = parse_indent(str)
    @align = indented ? :left : :center
    self.text = src.to_nsstr
  end
  
  private 

  def parse_indent(str)
    str.split(/(?:\r|\r\n|\n)/).each do |line|
      if (/\A\S/ =~ line)
        return str, false
      end
    end
    return str, true
  end

end
