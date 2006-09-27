#
#  Copyright (c) 2006 Laurent Sansonetti, Apple Computer Inc.
#  This test is based on a bug report reproducer, written by Tim Burks.
#

require 'test/unit'
require 'osx/cocoa'

system 'make' || raise(RuntimeError, "'make' failed")
require 'objc_test.bundle'

class RigHelper < OSX::NSObject
  def name
    "helper"
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
end

class TC_PassByRef < Test::Unit::TestCase
    def test_rig
        testrig = OSX::TestRig.alloc.init
        testrig.run    
    end
end
