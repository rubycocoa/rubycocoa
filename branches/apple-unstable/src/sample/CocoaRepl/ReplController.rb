#
#  WorksheetController.rb
#  CocoaRepl
#
#  Created by Fujimoto Hisa on 06/10/17.
#  Copyright (c) 2006 FUJIMOTO Hisa FOBJ SYSTEMS. All rights reserved.
#

require 'osx/cocoa'
require 'stringio'

class WorksheetController < OSX::NSObject
  include OSX

  FONTSIZE = 16
  STD_COLOR = NSColor.blackColor
  ERR_COLOR = NSColor.redColor
  OUT_COLOR = NSColor.blueColor
  
  ib_outlets :scratchText, :resultText, :outText

  def awakeFromNib
    font = NSFont.userFixedPitchFontOfSize(FONTSIZE)
    @scratchText.setFont(font)
    @resultText.setFont(font)
    @outText.setFont(font)
  end

  def evaluate(sender)
    src = @scratchText.string.to_s.gsub(/\r/, "\n")
    result = with_io_redirect { eval(src, TOPLEVEL_BINDING) }
    @resultText.setString(result.inspect)
    @resultText.setTextColor(STD_COLOR)
  end

  private
  def with_io_redirect
    saved_out = $stdout
    saved_err = $stderr
    out_io = StringIO.new
    $stdout = $stderr = out_io
    ret = yield
    @outText.setString(out_io.string)
    @outText.setTextColor(OUT_COLOR)
    ret
  rescue Exception => err
    str = err.message << "\n" << err.backtrace.join("\n")
    @outText.setString(str)
    @outText.setTextColor(ERR_COLOR)
    err
  ensure
    $stdout = saved_out
    $stderr = saved_err
  end

end
