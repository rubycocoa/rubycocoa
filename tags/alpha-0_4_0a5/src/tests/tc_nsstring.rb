#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
#
#  This program is free software.
#  You can distribute/modify this program under the terms of
#  the GNU Lesser General Public License version 2.
#

require 'test/unit'
require 'osx/cocoa'

class TC_NSString < Test::Unit::TestCase

  TESTSTR = "Hello World".freeze

  def test_s_alloc
    obj = OSX::NSString.alloc.init
    assert_equal( true, obj.isKindOfClass?(OSX::NSString) )
  end

  def test_s_stringWithString
    obj = OSX::NSString.stringWithString(TESTSTR)
    assert_equal(TESTSTR, obj.to_s)
  end

  def test_initWithString
    obj = OSX::NSString.alloc.initWithString(TESTSTR)
    assert_equal(TESTSTR, obj.to_s)
  end

end
