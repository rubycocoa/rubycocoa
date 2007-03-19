#
#  $Id: ruby_addition.rb 1404 2007-01-10 17:12:17Z lrz $
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni
#

class String

  def nsencoding
    OSX::NSString.guess_nsencoding(self)
  end

  def to_nsstring
    OSX::NSString.stringWithRubyString(self)
  end

  def to_nsmutablestring
    OSX::NSMutableString.stringWithRubyString(self)
  end

end
