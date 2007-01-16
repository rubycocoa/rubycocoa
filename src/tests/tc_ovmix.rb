#
#  Copyright (c) 2006 Laurent Sansonetti, Apple Computer Inc.
#  This test is based on a bug report reproducer, written by Tim Burks.
#

require 'test/unit'
require 'osx/cocoa'
require 'rbconfig'

system 'make -s' || raise(RuntimeError, "'make' failed")
require 'objc_test.bundle'

class RigHelper < OSX::NSObject
  def name
    "helper"
  end

  addRubyMethod_withType("testChar:", "c@:c")
  def testChar(c)
    c
  end

  addRubyMethod_withType("testInt:", "i@:i")
  def testInt(i)
    i
  end

  addRubyMethod_withType("testShort:", "s@:s")
  def testShort(s)
    s
  end

  addRubyMethod_withType("testLong:", "l@:l")
  def testLong(l)
    l
  end

  addRubyMethod_withType("testFloat:", "f@:f")
  def testFloat(f)
    f
  end

  addRubyMethod_withType("testDouble:", "d@:d")
  def testDouble(d)
    d
  end

  addRubyMethod_withType("testLongLong:", "q@:q")
  def testLongLong(ll)
    ll
  end
end

class ObjcExportHelper < OSX::NSObject
  def foo1
    's'
  end
  objc_export :foo1, %w{id}

  def foo2(integer)
    integer + 2
  end
  objc_export :foo2, %w{int int}

  def foo3_obj(ary, obj)
    ary.addObject(obj)
  end
  objc_export :foo3, %w{void id id}

  def foo4_size(point, size)
    OSX::NSRect.new(point, size)
  end
  objc_export :foo4_size, [OSX::NSRect, OSX::NSPoint, OSX::NSSize]
end

class OSX::DirectOverride
  def self.overrideMe
    'bar'
  end
  def overrideMe
    'foo'
  end
end

class OSX::NSObject
  def mySuperMethod
    'foo'
  end
  objc_export :mySuperMethod, ['id']
end

class TC_OVMIX < Test::Unit::TestCase
  def test_rig
    testrig = OSX::TestRig.alloc.init
    testrig.run    
  end

  def test_objc_export
    testoe = OSX::TestObjcExport.alloc.init
    testoe.run
  end

  def test_direct_override
    assert(OSX::DirectOverride.ancestors.include?(OSX::NSObject))
    o = OSX::DirectOverride.alloc.init
    assert_kind_of(OSX::NSString, o.performSelector('overrideMe'))
    assert_kind_of(OSX::NSString, OSX::DirectOverride.performSelector('overrideMe'))
  end

  def test_super_method
    o = OSX::NSString.stringWithCString('blah')
    assert_equal('foo', o.mySuperMethod.to_s)
    assert_equal('foo', o.performSelector('mySuperMethod').to_s)
  end
end
