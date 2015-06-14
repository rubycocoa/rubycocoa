require 'osx/cocoa'
require 'test/unit'

class TC_ObjCID < Test::Unit::TestCase

  def test_objcid_eql
    # NSNumber represented like immediate value for small integer
    num1 = OSX::NSNumber.numberWithInt(1)
    num2 = OSX::NSNumber.numberWithInt(1)
    assert_equal(true, num1 == num2, 'num1 == num2')
    assert_equal(true, num1.eql?(num2), 'num1.eql? num2')
    assert_equal(false, num1.equal?(num2), 'num1.equal? num2')
    #
    url1 = OSX::NSURL.URLWithString('http://www.apple.com/')
    url2 = OSX::NSURL.URLWithString('http://www.apple.com/')
    assert_equal(false, url1 == url2, 'url1 == url2')
    assert_equal(false, url1.eql?(url2), 'url1.eql? url2')
    assert_equal(false, url1.equal?(url2), 'url1.equal? url2')
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
    assert_raise NoMethodError do
      url.clone
    end
  end

  def test_objcid_dup
    url1 = OSX::NSURL.URLWithString('http://www.apple.com/')
    url2 = url1.dup
    assert_equal(url1.hash, url2.hash)
    assert_equal(url1.__ocid__, url2.__ocid__)
    assert_not_equal(url1.__id__, url2.__id__)
  end

  def test_osx_objc_classnames
    names = OSX.objc_classnames
    assert_kind_of(Array, names)
    assert_include(names, 'NSObject')   # root class
    assert_include(names, 'NSProxy')    # root class
    assert_include(names, 'NSURL')      # subclass
    assert_not_include(names, 'Object') # not NS-class
    assert_include(names, 'RBObject')   # declared in RubyCocoa.framework

    assert_nothing_raised do
      OSX.objc_classnames {|klassname| break}
    end
  end
end
