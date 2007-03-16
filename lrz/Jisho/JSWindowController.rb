# Copyright (c) 2006-2007 Laurent Sansonetti <lrz@chopine.be>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

class JSWindowController < NSWindowController
  ib_outlets :textView, :searchField, :fontSizeSegmentedControl, :historySegmentedControl
  attr_reader :searchField
  
  def awakeFromNib
    dict_path = NSBundle.mainBundle.pathForResource_ofType('JMdict', 'tgz')
    app_path = File.join(NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, true)[0].to_s, 'Jisho')
    @database = JSDatabase.new(dict_path, app_path)
    
    @textView.setTextContainerInset(NSSize.new(10, 10))
    @textView.textContainer.setLineFragmentPadding(0)
    
    @results = nil
    @fontSizeDelta = 0
    @history = []
    @historyPos = 0
  end

  def search(sender)
    searchText(sender.stringValue.to_s.strip)
  end
  
  TAG_FONT_SMALLER, TAG_FONT_NORMAL, TAG_FONT_BIGGER = 40, 41, 42
  TAG_HISTORY_BACK, TAG_HISTORY_FORWARD = 50, 51
  FONT_SIZE_STEP = 2

  def updateFontSize(sender)
    tag = sender.is_a?(NSSegmentedControl) ? sender.cell.tagForSegment(sender.selectedSegment) : sender.tag
    vals = case tag
    when TAG_FONT_SMALLER
      @fontSizeDelta -= FONT_SIZE_STEP
      [@fontSizeDelta > -4, true]
    when TAG_FONT_NORMAL
      @fontSizeDelta = 0
      [true, true]
    when TAG_FONT_BIGGER
      @fontSizeDelta += FONT_SIZE_STEP
      [true, @fontSizeDelta < 10]
    end
    vals.each_with_index { |x, i| @fontSizeSegmentedControl.cell.setEnabled_forSegment(x, i) }
    refreshView
  end
  
  def goHistory(sender)
    tag = sender.is_a?(NSSegmentedControl) ? sender.cell.tagForSegment(sender.selectedSegment) : sender.tag
    vals = case tag
    when TAG_HISTORY_BACK
      @historyPos -= 1
      [@historyPos > 0, true]
    when TAG_HISTORY_FORWARD
      @historyPos += 1
      [true, @historyPos < @history.size]
    end
    vals.each_with_index { |x, i| @historySegmentedControl.cell.setEnabled_forSegment(x, i) }
    term = @history[@historyPos]
    @searchField.setStringValue(term)
    searchText(term, false)
  end
  
  def validateMenuItem(sender)
    if sender.action == 'updateFontSize:'
      case sender.tag
      when TAG_FONT_SMALLER: @fontSizeDelta > -4
      when TAG_FONT_NORMAL: @fontSizeDelta != 0
      when TAG_FONT_BIGGER: @fontSizeDelta < 10
      end
    elsif sender.action == 'goHistory:'
      case sender.tag
      when TAG_HISTORY_BACK: canGoBack?
      when TAG_HISTORY_FORWARD: canGoForward?
      end
    else
      true
    end
  end
  
  private
  
  def canGoBack?
    @history.size > 1 and @historyPos > 0
  end
  
  def canGoForward?
    !@history.empty? and @historyPos < @history.size - 1
  end
  
  def searchText(term, recordHistory=true)
    @results = term == '' ? nil : @database.search(term)
    if recordHistory and !(@results.nil? or @results.empty?)
      @history << term
      @historyPos = @history.length - 1
    end
    refreshView
    cell = @historySegmentedControl.cell
    cell.setEnabled_forSegment(canGoBack?, 0)
    cell.setEnabled_forSegment(canGoForward?, 1)
  end
  
  def refreshView
    if @results.nil?
      @textView.setString('')
    else
      attr = {}
      str = if @results.empty?
        attr[NSFontAttributeName] = NSFont.fontWithName_size('Baskerville', 24 + @fontSizeDelta)
        attr[NSForegroundColorAttributeName] = NSColor.grayColor
        'No entries found'
      else
        attr[NSFontAttributeName] = NSFont.fontWithName_size('Baskerville', 18 + @fontSizeDelta)
        @results.map do |entry|
          s = ''
          s << entry.kanji + ' ' unless entry.kanji.empty?
          entry.kana.each do |kana|
            s << "\343\200\214" << kana << "\343\200\215"
          end
          s << "\n" << entry.senses_by_lang('en').map { |g| g.text }.join("\n") << "\n"
        end.join("\n").strip
      end
      @textView.textStorage.setAttributedString(NSAttributedString.alloc.initWithString_attributes(str, attr))
    end  
  end
end
