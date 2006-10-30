#
#  Copyright (c) 2006 Laurent Sansonetti, Apple Computer Inc.
#

require 'test/unit'
require 'osx/cocoa'

class TC_Types < Test::Unit::TestCase

    def test_auto_boolean_conversion
        s1 = OSX::NSString.alloc.initWithString("foo")
        s2 = s1.copy
        s3 = OSX::NSString.alloc.initWithString("bar")
        assert_equal(true, s1.isEqualToString(s2))
        assert_equal(true, s1.isEqualToString?(s2))
        assert_equal(false, s1.isEqualToString(s3))
        assert_equal(false, s1.isEqualToString?(s3))
    end

    def test_char_conversion
        v = OSX::NSNumber.numberWithChar(?v)
        assert_equal(?v, v.charValue)
    end

    def test_uchar_conversion
        v = OSX::NSNumber.numberWithUnsignedChar(?v)
        assert_equal(?v, v.unsignedCharValue)
    end

    def test_short_conversion
        v = OSX::NSNumber.numberWithShort(42)
        assert_equal(42, v.shortValue)
    end

    def test_ushort_conversion
        v = OSX::NSNumber.numberWithUnsignedShort(42)
        assert_equal(42, v.unsignedShortValue)
    end

    def test_int_conversion
        v = OSX::NSNumber.numberWithInt(42)
        assert_equal(42, v.intValue)
    end

    def test_float_conversion
        v = OSX::NSNumber.numberWithFloat(42.42)
        assert((42.42 - v.floatValue).abs < 0.01)
    end
end
