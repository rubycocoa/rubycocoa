require 'rubyunit'
require 'osx/cocoa'

class TestNSString < RUNIT::TestCase

  TESTSTR = "Hello World".freeze

  def test_s_alloc
    obj = OSX::NSString.alloc.init
    assert_equal (true, obj.isKindOfClass? (OSX::NSString))
  end

  def test_s_stringWithString
    obj = OSX::NSString.stringWithString (TESTSTR)
    assert_equal(TESTSTR, obj.to_s)
  end

  def test_initWithString
    obj = OSX::NSString.alloc.initWithString (TESTSTR)
    assert_equal(TESTSTR, obj.to_s)
  end

end
