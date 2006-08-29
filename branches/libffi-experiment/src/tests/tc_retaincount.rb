require 'test/unit'
require 'osx/cocoa'

system 'make' || raise(RuntimeError, "'make' failed")
require 'objc_test.bundle'

OSX.ns_import :RetainCount

class RBSubclass < OSX::NSObject
end

class TC_RetainCount < Test::Unit::TestCase

  # retained by Ruby
  def test_rb_rbclass
    assert_equal(1, RBSubclass.alloc.retainCount, 'alloc')
    assert_equal(1, RBSubclass.allocWithZone(nil).retainCount, 'allocWithZone:')
    assert_equal(1, RBSubclass.alloc.init.retainCount, 'alloc.init')
  end

  # retained by Ruby
  def test_rb_occlass
    assert_equal(1, OSX::NSObject.alloc.retainCount, 'alloc')
    assert_equal(1, OSX::NSObject.alloc.init.retainCount, 'alloc.init')
    assert_equal(1, OSX::NSString.stringWithString('foo').retainCount, 'factory')
  end

  # retained by Objective-C
  def test_objc_rbclass
    assert_equal(1, OSX::RetainCount.rbAllocCount, 'alloc')
    assert_equal(1, OSX::RetainCount.rbInitCount, 'alloc.init') 
  end

  # retained by Ruby and Objective-C
  def test_obj_from_objc
    assert_equal(2, OSX::RetainCount.ocObject.retainCount, 'ObjC object')
    assert_equal(2, OSX::RetainCount.rbObject.retainCount, 'Ruby object')
  end

end

