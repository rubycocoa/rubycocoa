require 'osx/cocoa'
require 'test/unit'

class TC_ObjCID < Test::Unit::TestCase

  def test_objcid_eql
    # NSNumber represented like immediate value for small integer
    num1 = OSX::NSNumber.numberWithInt(1)
    num2 = OSX::NSNumber.numberWithInt(1)
    assert_true(num1 == num2, 'num1 == num2')
    assert_true(num1.eql?(num2), 'num1.eql? num2')
    assert_false(num1.equal?(num2), 'num1.equal? num2')
    #
    url1 = OSX::NSURL.URLWithString('http://www.apple.com/')
    url2 = OSX::NSURL.URLWithString('http://www.apple.com/')
    assert_false(url1 == url2, 'url1 == url2')
    assert_false(url1.eql?(url2), 'url1.eql? url2')
    assert_false(url1.equal?(url2), 'url1.equal? url2')
  end

  def test_objcid_hash
    # NSNumber represented like immediate value for small integer
    num1 = OSX::NSNumber.numberWithInt(1)
    num2 = OSX::NSNumber.numberWithInt(1)
    assert_equal(num1.hash, num2.hash)
    assert_equal(num1.__ocid__, num2.__ocid__)
    #
    url1 = OSX::NSURL.URLWithString('http://www.apple.com/')
    url2 = OSX::NSURL.URLWithString('http://www.apple.com/')
    assert_not_equal(url1.hash, url2.hash)
    assert_not_equal(url1.__ocid__, url2.__ocid__)
  end

  def test_objcid_clone
    url = OSX::NSURL.URLWithString('http://www.apple.com/')
    assert_raise OSX::OCMessageSendException do
      url.clone
    end
  end

end
