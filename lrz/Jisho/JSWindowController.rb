#
#  JSWindowController.rb
#  Jisho
#
#  Created by Laurent Sansonetti on 11/24/06.
#  Copyright (c) 2006 Apple Computer. All rights reserved.
#

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
  
  FONT_SIZE_STEP = 2
  def updateFontSize(sender)
    tag = sender.is_a?(NSSegmentedControl) ? sender.cell.tagForSegment(sender.selectedSegment) : sender.tag
    vals = case tag
    when 40
      @fontSizeDelta -= FONT_SIZE_STEP
      [@fontSizeDelta > -4, true]
    when 41
      @fontSizeDelta = 0
      [true, true]
    when 42
      @fontSizeDelta += FONT_SIZE_STEP
      [true, @fontSizeDelta < 10]
    end
    vals.each_with_index { |x, i| @fontSizeSegmentedControl.cell.setEnabled_forSegment(x, i) }
    refreshView
  end
  
  def goHistory(sender)
    tag = sender.is_a?(NSSegmentedControl) ? sender.cell.tagForSegment(sender.selectedSegment) : sender.tag
    vals = case tag
    when 50
      @historyPos -= 1
      [@historyPos > 0, true]
    when 51
      @historyPos += 1
      [true, @historyPos < @history.size]
    end
    vals.each_with_index { |x, i| @historySegmentedControl.cell.setEnabled_forSegment(x, i) }
    refreshView
  end
  
  def validateMenuItem(sender)
    if sender.action == 'updateFontSize:'
      case sender.tag
      when 40
        @fontSizeDelta > -4
      when 41
        @fontSizeDelta != 0
      when 42
        @fontSizeDelta < 10
      end
    elsif sender.action == 'goHistory:'
      case sender.tag
      when 50
        (!@history.empty? and @historyPos > 0) 
      when 51
        (!@history.empty? and @historyPos < @history.size)
      end
    else
      true
    end
  end
  
  private
  
  def searchText(term, recordHistory=true)
    @results = term == '' ? nil : @database.search(term)
    @history << @results if recordHistory
    refreshView
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
