#
#  $Id$
#
#  Copyright (c) 2006 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
#
#  This program is free software.
#  You can distribute/modify this program under the terms of
#  the GNU Lesser General Public License version 2.
#

require 'test/unit'
require 'osx/cocoa'

class TC_OCObjWrapper < Test::Unit::TestCase
  include OSX

  def setup
    @obj = NSObject.alloc.init
    @data = NSData.alloc.init
  end

  def teardown
  end

  def test_instance_methods
    assert_equal_array(@obj.objc_methods, NSObject.objc_instance_methods)
    assert_equal_array(@obj.objc_methods, @obj.objc_instance_methods)
  end

  def test_instance_methods_nonrecursive
    assert_equal_array(NSObject.objc_instance_methods | NSData.objc_instance_methods(false), NSData.objc_instance_methods(true))
  end

  def test_class_methods
    assert_equal_array(NSObject.objc_methods, NSObject.objc_class_methods)
    assert_equal_array(NSObject.objc_methods, @obj.objc_class_methods)
  end

  def test_class_methods_nonrecursive
    assert_equal_array(NSObject.objc_class_methods | NSData.objc_class_methods(false), NSData.objc_class_methods(true))
  end

  def assert_equal_array(ary1, ary2)
    assert_equal((ary1 | ary2).size, ary1.size)
  end

  def test_method_type
    sel = 'getBytes:'
    assert_equal(NSData.objc_instance_method_type(sel),
		 @data.objc_method_type(sel))
    assert_equal(NSData.objc_instance_method_type(sel),
		 @data.objc_instance_method_type(sel))

    sel = 'dataWithBytes:length:'
    assert_equal(NSData.objc_class_method_type(sel),
		 NSData.objc_method_type(sel))
    assert_equal(NSData.objc_class_method_type(sel),
		 @data.objc_class_method_type(sel))
  end

end
