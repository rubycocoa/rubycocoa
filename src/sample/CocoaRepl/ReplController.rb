# -*- mode:ruby; indent-tabs-mode:nil; coding:utf-8 -*-
#
#  ReplController.rb
#  CocoaRepl
#
#  Created by Fujimoto Hisa on 07/03/01.
#  Copyright (c) 2007 Fujimoto Hisa. All rights reserved.
#
$KCODE = 'utf-8'
require 'osx/cocoa'
require 'stringio'

class ReplController < OSX::NSObject
  include OSX

  FONTSIZE = 18
  ERR_COLOR = NSColor.redColor
  OK_COLOR  = NSColor.blueColor
  SCRATCH_PATH = File.join(ENV['HOME'], ".cocoarepl_scratch.rb")

  ib_outlets :scratchText, :resultText, :outText, :tabView, :statusView
  ib_outlets :window
  ib_outlets :wordsTable, :descriptionText

  def awakeFromNib
    DecoratorStyle.font_size = FONTSIZE
    font = NSFont.userFixedPitchFontOfSize(FONTSIZE)
    @scratchText.setFont(font)
    @resultText.setFont(font)
    @outText.setFont(font)
    @descriptionText.setFont(NSFont.userFixedPitchFontOfSize(14))

    #<OSX::NSRect:0x6647d0 x=4 y=12 width=900 height=762>
    # p "AAAAA", @window.frame, "BBBBB"
    # default [4, 12], [900, 762]
    @window.setFrameOrigin([4,12])
    @window.setContentSize([800,680])

    initial_msg = "Ruby #{RUBY_VERSION}"
    initial_msg << ", RubyCocoa #{RUBYCOCOA_VERSION}"
    initial_msg << " (r#{RUBYCOCOA_SVN_REVISION})"
    @statusView.setStringValue(initial_msg)
    # @window.setTitle("Read-Eval-Print Loop for #{initial_msg}")
    @window.setTitle("RubyCocoa REPL : #{initial_msg}")
    @window.setAlphaValue(0.9)

    tvdel = RubyProgramTextViewDelegate.alloc.init
    tvdel.setController(self)
    @scratchText.setDelegate(tvdel)
    @wordsTable.setDelegate(@scratchText.delegate)
    @wordsTable.setDataSource(@scratchText.delegate)
    load_scratch
  end

  ib_action :selectScratchView do
    @window.makeFirstResponder(@scratchText)
  end

  ib_action :alphaChanged do |sender|
    @window.setAlphaValue(sender.floatValue)
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

  def reloadWordsTable
    @wordsTable.reloadData
    @tabView.selectTabViewItemWithIdentifier('reference')
  end

  def showDescription(str)
    @descriptionText.setString(str)
    @tabView.selectTabViewItemWithIdentifier('reference')
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

  def store_scratch
    str = @scratchText.textStorage.rubyString
    str.strip!
    File.open(SCRATCH_PATH,"w") { |io| io.write(str) ; io.puts } unless str.empty?
  end

  def load_scratch
    if File.exist? SCRATCH_PATH then
      @scratchText.setString(File.read(SCRATCH_PATH))
      @scratchText.didChangeText
    end
  end

  def show_result(ret, err, output)
    store_scratch
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
