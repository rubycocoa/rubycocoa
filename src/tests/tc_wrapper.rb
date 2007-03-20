#
#  $Id$
#
#  Copyright (c) 2006 FUJIMOTO Hisakuni
#  Copyright (c) 2006 kimura wataru
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
  end

  def test_instance_methods_nonrecursive
    assert_equal_array(NSObject.objc_instance_methods | NSData.objc_instance_methods(false), NSData.objc_instance_methods(true))
  end

  def test_class_methods
    assert_equal_array(NSObject.objc_methods, NSObject.objc_class_methods)
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

    sel = 'dataWithBytes:length:'
    assert_equal(NSData.objc_class_method_type(sel),
		 NSData.objc_method_type(sel))
  end

  def test_message_syntaxes
    old_relaxed_syntax = OSX.relaxed_syntax
    OSX.relaxed_syntax = true
    url1 = NSURL.alloc.initWithScheme_host_path_('http', 'localhost', '/foo') 
    url2 = NSURL.alloc.initWithScheme_host_path('http', 'localhost', '/foo') 
    url3 = NSURL.alloc.initWithScheme('http', :host, 'localhost', :path, '/foo') 
    url4 = NSURL.alloc.initWithScheme('http', :host => 'localhost', :path => '/foo')
    assert_equal(1, url1.isEqual(url2)) 
    assert_equal(1, url2.isEqual(url3)) 
    assert_equal(1, url3.isEqual(url4))
    OSX.relaxed_syntax = false 
    url5 = NSURL.alloc.initWithScheme_host_path_('http', 'localhost', '/foo') 
    assert_equal(1, url1.isEqual_(url5))
    assert_raises OSX::OCMessageSendException do
      NSURL.alloc.initWithScheme_host_path('http', 'localhost', '/foo')
    end 
    assert_raises OSX::OCMessageSendException do 
      NSURL.alloc.initWithScheme('http', :host, 'localhost', :path, '/foo')
    end
    assert_raises OSX::OCMessageSendException do
      NSURL.alloc.initWithScheme('http', :host => 'localhost', :path => '/foo')
    end
    OSX.relaxed_syntax = old_relaxed_syntax
  end

  def test_missing_args
    assert_raises ArgumentError do
      NSURL.URLWithString_
    end
    assert_raises ArgumentError do
      NSURL.URLWithString_relativeToURL_('http://localhost')
    end
  end

end
