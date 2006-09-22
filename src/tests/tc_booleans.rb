#
#  Copyright (c) 2006 Laurent Sansonetti, Apple Computer Inc.
#

require 'test/unit'
require 'osx/cocoa'

class TC_Booleans < Test::Unit::TestCase

    def test_auto_boolean_conversion
        s1 = OSX::NSString.alloc.initWithString("foo")
        s2 = s1.copy
        s3 = OSX::NSString.alloc.initWithString("bar")
        assert_equal(true, s1.isEqualToString(s2))
        assert_equal(true, s1.isEqualToString?(s2))
        assert_equal(false, s1.isEqualToString(s3))
        assert_equal(false, s1.isEqualToString?(s3))
        v = OSX::NSNumber.numberWithChar(?v)
        assert_equal(?v, v.charValue)
    end
end
