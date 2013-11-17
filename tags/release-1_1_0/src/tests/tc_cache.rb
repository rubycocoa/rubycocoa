require 'osx/cocoa'
require 'test/unit'

system 'make -s' || raise(RuntimeError, "'make' failed")
require './objc_test.bundle'

class ObjcToRubyCacheCallbackTarget < OSX::NSObject
  def callback(obj)
  end
end

class TCObjcToRubyCache < Test::Unit::TestCase
  def test_nsstring
    do_test_cache(OSX::NSString)
  end
  
  def test_nsdata
    do_test_cache(OSX::NSData)
  end
  
  def test_nsarray
    do_test_cache(OSX::NSArray)
  end
  
  def test_nsdictionary
    do_test_cache(OSX::NSDictionary)
  end
  
  def test_nsindexset
    do_test_cache(OSX::NSIndexSet)
  end

  def test_disable_cache
    obj0 = OSX::NSObject.alloc.init
    begin
      $RUBYCOCOA_USE_OC2RBCACHE = false
      obj1, obj2 = OSX::ObjcToRubyCacheTest.testObjcToRubyCacheWith(obj0)
      assert_equal(obj0.__ocid__, obj1.__ocid__)
      assert_not_equal(obj0.__id__, obj1.__id__)
      assert_equal(obj1.__ocid__, obj2.__ocid__)
      assert_not_equal(obj1.__id__, obj2.__id__)
    ensure
      $RUBYCOCOA_USE_OC2RBCACHE = true
    end
    obj1, obj2 = OSX::ObjcToRubyCacheTest.testObjcToRubyCacheWith(OSX::NSObject.alloc.init)
    assert_equal(obj1.__ocid__, obj2.__ocid__)
    assert_equal(obj1.__id__, obj2.__id__)
  end
  
  private
  
  def do_test_cache(klass)
    t = ObjcToRubyCacheCallbackTarget.alloc.init
    res = OSX::ObjcToRubyCacheTest.testObjcToRubyCacheFor_with(klass, t)
    assert_equal(0, res)
  end

end
