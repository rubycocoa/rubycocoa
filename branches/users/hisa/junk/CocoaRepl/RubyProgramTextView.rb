# -*- mode:ruby; indent-tabs-mode:nil; coding:utf-8 -*-
#
#  RubyProgramTextView.rb
#  CocoaRepl
#
#  Created by Fujimoto Hisa on 07/03/01.
#  Copyright (c) 2007 FUJIMOTO Hisa, FOBJ SYSTEMS. All rights reserved.
#
require 'osx/cocoa'
require 'ri_contents'
require 'decorator'

class OSX::NSString
  def rubyString
    self.to_s.gsub(/\r/, "\n")
  end
end

class OSX::NSTextStorage
  include OSX

  def rubySubString(range)
    string.substringWithRange(range).rubyString
  end

  def rubyString
    string.rubyString
  end

  def isEmptyLineForRange(range)
    range &&= string.lineRangeForRange(range)
    if range.nil? or /^\s*$/ =~ string.substringWithRange(range).to_s 
    then  true
    else  false  end
  end

  def lineRangeForRange(range)
    string.lineRangeForRange(range)
  end

  def blockRangeForRange(range)
    from_range = prevEmptyLineRangeForRange(range)
    to_range   = nextEmptyLineRangeForRange(range)
    from = if from_range
           then  from_range.location
           else  0  end
    to   = if to_range
           then  to_range.location + to_range.length
           else  string.length  end
    OSX::NSRange.new(from, to - from)
  end

  def prevEmptyLineRangeForRange(range)
    while not isEmptyLineForRange(range) do
      range = prevLineRangeForRange(range)
    end
    range
  end

  def nextEmptyLineRangeForRange(range)
    while not isEmptyLineForRange(range) do
      range = nextLineRangeForRange(range)
    end
    range
  end

  def prevLineRangeForRange(range)
    range = string.lineRangeForRange(range)
    if range.location > 0 then
      range = NSRange.new(range.location - 1, 1)
      string.lineRangeForRange(range)
    else
      nil
    end
  end

  def nextLineRangeForRange(range)
    range = string.lineRangeForRange(range)
    if range.location + range.length < length then
      range = NSRange.new(range.location + range.length, 1)
      string.lineRangeForRange(range)
    else
      nil
    end
  end
end

class RubyProgramTextStorageDelegate < OSX::NSObject
  include OSX

  def init
    @ri = RiContents.instance
    @decorator = Decorator.default
    return self
  end

  def textStorageDidProcessEditing(ntf)
    if @decorator then
      storage = ntf.object
      range = storage.blockRangeForRange(storage.editedRange)
      @decorator.decorate(storage, range)
    end
  end
end


class RubyProgramTextView < OSX::NSTextView
  include OSX

  def awakeFromNib
    textStorage.setDelegate(RubyProgramTextStorageDelegate.alloc.init)
  end

  def rangeForCurrentBlock
    textStorage.blockRangeForRange(selectedRange)
  end

  def rangeForCurrentLine
    textStorage.lineRangeForRange(selectedRange)
  end

  def selectCurrentBlock
    setSelectedRange(rangeForCurrentBlock)
  end

  def selectCurrentLine
    setSelectedRange(rangeForCurrentLine)
  end

end


class RubyProgramTextViewDelegate < OSX::NSObject
  include OSX

  def init
    @controller = nil
    @ri = RiContents.instance
    @words = @key = nil
    return self
  end

  def setController(controller)
    @controller = controller
  end

  def textDidChange(ntf)
    view = ntf.object
    range = view.rangeForUserCompletion
    if range.length > 0 then
      @key = view.textStorage.string.substringWithRange(range).to_s
      @words = @ri.lookup_name(@key)
      @controller.textDidChange if @controller
    end
  end

  def textView_completions_forPartialWordRange_indexOfSelectedItem(view, words, range, index)
    @words
  end

  def numberOfRowsInTableView(view)
    num = @words ? @words.size : 0
    showDescription(@words[0]) if num == 1
    num
  end

  def tableView_objectValueForTableColumn_row(view, col, row)
    key = @words ? @words[row] : nil
    showDescription(key) if key == @key
    key
  end

  def tableViewSelectionDidChange(ntf)
    tbl = ntf.object
    row = tbl.selectedRow
    showDescription(@words[row])
  end

  private

  def showDescription(key)
    if @controller then
      ary = @ri.lookup(key, :entire)
      desc = ary.map{|i|i.text}.join("\n\n")
      @controller.showDescription(desc)
    end
  end

  def extract_key(storage, range)
    storage.string.substringWithRange(range).to_s
  end
end
