#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
#
#  This program is free software.
#  You can distribute/modify this program under the terms of
#  the GNU Lesser General Public License version 2.
#
require 'osx/cocoa'
require 'nkf'

class String

  def to_nsstring
    data = OSX::NSData.dataWithBytes_length( self, self.size )
    enc = nsencoding
    OSX::NSString.alloc.initWithData_encoding( data, enc )
  end

  def to_nsmutablestring
    data = OSX::NSData.dataWithBytes_length( self, self.size )
    enc = nsencoding
    OSX::NSMutableString.alloc.initWithData_encoding( data, enc )
  end

  def nsencoding
    case NKF.guess(self)
    when NKF::JIS then OSX::NSISO2022JPStringEncoding
    when NKF::EUC then OSX::NSJapaneseEUCStringEncoding
    when NKF::SJIS then OSX::NSShiftJISStringEncoding
    else OSX::NSProprietaryStringEncoding
    end
  end

end
