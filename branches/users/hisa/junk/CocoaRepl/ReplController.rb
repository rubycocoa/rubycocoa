# -*- mode:ruby; indent-tabs-mode:nil; coding:utf-8 -*-
#
#  ReplController.rb
#  CocoaRepl
#
#  Created by Fujimoto Hisa on 07/03/01.
#  Copyright (c) 2007 FUJIMOTO Hisa, FOBJ SYSTEMS. All rights reserved.
#
$KCODE = 'utf-8'
require 'osx/cocoa'
require 'stringio'

class ReplController < OSX::NSObject
  include OSX

  FONTSIZE = 16
  ERR_COLOR = NSColor.redColor
  OK_COLOR  = NSColor.blueColor
  
  ib_outlets :scratchText, :resultText, :outText, :tabView, :statusView
  ib_outlets :wordsTable, :descriptionText

  def awakeFromNib
    font = NSFont.userFixedPitchFontOfSize(FONTSIZE)
    @scratchText.setFont(font)
    @resultText.setFont(font)
    @outText.setFont(font)
    @descriptionText.setFont(NSFont.userFixedPitchFontOfSize(14))

    initial_msg = "Ruby #{RUBY_VERSION}"
    initial_msg << ", RubyCocoa #{RUBYCOCOA_VERSION}"
    initial_msg << " (#{RUBYCOCOA_SVN_REVISION})"
    @statusView.setStringValue(initial_msg)

    tvdel = RubyProgramTextViewDelegate.alloc.init
    tvdel.setController(self)
    @scratchText.setDelegate(tvdel)
    @wordsTable.setDelegate(@scratchText.delegate)
    @wordsTable.setDataSource(@scratchText.delegate)
  end

  ib_action :tabChanged do |sender|
    case sender.tag.to_i
    when 1 then @tabView.selectTabViewItemWithIdentifier('result')
    when 2 then @tabView.selectTabViewItemWithIdentifier('output')
    when 3 then @tabView.selectTabViewItemWithIdentifier('reference')
    end
  end

  ib_action :evaluate do |sender|
    src = string_for_eval(sender.tag)
    ret, err, output = with_io_redirect { 
      eval(src, TOPLEVEL_BINDING, "(program)", 1) 
    }
    show_result(ret, err, output)
    nil
  end

  ib_action :selectBlock do
    @scratchText.selectCurrentBlock
  end

  def textDidChange
    @wordsTable.reloadData
    @tabView.selectTabViewItemWithIdentifier('reference')
  end

  def showDescription(str)
    @descriptionText.setString(str)
  end

  private

  def string_for_eval(tag)
    storage = @scratchText.textStorage
    case tag
    when 0 then storage.rubyString
    when 1 then storage.rubySubString(@scratchText.selectedRange)
    when 2 then storage.rubySubString(@scratchText.rangeForCurrentLine)
    when 3 then storage.rubySubString(@scratchText.rangeForCurrentBlock)
    end
  end

  def show_result(ret, err, output)
    if err then
      @statusView.setStringValue(err.message[0,100])
      info = err.message << "\n"
      err.backtrace.each { |i| info << "  #{i}\n" }
      @resultText.setString(info)
      @resultText.setTextColor(ERR_COLOR)
    else
      @statusView.setStringValue(ret.inspect[0,100])
      @resultText.setString(ret.inspect)
      @resultText.setTextColor(OK_COLOR)
    end
    if output.empty? then
      @tabView.selectTabViewItemWithIdentifier('result')
    else
      @outText.setString(output)
      @tabView.selectTabViewItemWithIdentifier('output')
    end
  end

  def with_io_redirect
    saved_out = $stdout
    saved_err = $stderr
    out_io = StringIO.new
    $stdout = $stderr = out_io
    ret = yield
    [ ret, nil, out_io.string ]
  rescue Exception => err
    [ nil, err, out_io.string ]
  ensure
    $stdout = saved_out
    $stderr = saved_err
  end
end
