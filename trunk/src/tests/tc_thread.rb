#
#  Copyright (c) 2007 Laurent Sansonetti, Apple Inc.
#

require 'test/unit'
require 'osx/cocoa'

system 'make -s' || raise(RuntimeError, "'make' failed")
require 'objc_test.bundle'

class TestThreadNativeMethod < OSX::NSObject
  def initWithTC(tc)
    init
    @tc = tc
    return self
  end

  def threaded
    @tc.assert_equal(@tc.mainThread, OSX::NSThread.currentThread)
    if defined? OSX::CFRunLoopGetMain then
      @tc.assert_equal(OSX::CFRunLoopGetCurrent(), OSX::CFRunLoopGetMain())
    end
    42
  end
  objc_method :threaded, ['id']
end

class TC_Thread < Test::Unit::TestCase
  attr_reader :mainThread

  def setup
    @mainThread = OSX::NSThread.currentThread
  end

  def threaded
    assert_equal(@mainThread, OSX::NSThread.currentThread)
    if defined? OSX::CFRunLoopGetMain then
      assert_equal(OSX::CFRunLoopGetCurrent(), OSX::CFRunLoopGetMain())
    end
    42
  end

  def test_threaded_callback
    OSX::TestThreadedCallback.callbackOnThreadRubyObject(self)
  end

  def test_threaded_closure
    o = TestThreadNativeMethod.alloc.initWithTC(self)
    OSX::TestThreadedCallback.callbackOnThreadRubyObject(o)
  end
end
