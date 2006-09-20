#
#  Copyright (c) 2006 Laurent Sansonetti, Apple Computer Inc.
#

require 'test/unit'
require 'osx/cocoa'

system 'make' || raise(RuntimeError, "'make' failed")
require 'objc_test.bundle'

class TC_PassByRef < Test::Unit::TestCase

    def test_passbyref_methods
        bridged = OSX::PassByRef.alloc.init
        
        # Object.
        assert_equal(false, bridged.passByRefObject(nil))
        assert_equal([true, bridged], bridged.passByRefObject_)
    
        # Integer.
        assert_equal(false, bridged.passByRefInteger(nil))
        assert_equal([true, 666], bridged.passByRefInteger_)
        
        # Float.
        assert_equal(false, bridged.passByRefFloat(nil))
        assert_equal([true, 666.0], bridged.passByRefFloat_)

        # Various.
        assert_nil(bridged.passByRefVarious_integer_floating(nil, nil, nil))
        assert_equal([bridged, 666, 666.0], bridged.passByRefVarious_integer_floating_)
        assert_equal([666, 666.0], bridged.passByRefVarious_integer_floating_(nil))
        assert_equal(666.0, bridged.passByRefVarious_integer_floating_(nil, nil))
    end

    def test_passbyref_foundation
        invalid_path = '/does/not/exist'

        # Passing nil for error should not return it. 
        val = OSX::NSString.stringWithContentsOfFile_encoding_error(invalid_path, OSX::NSASCIIStringEncoding, nil)
        assert_nil(val)

        # Not specifying error should return it.    
        val = OSX::NSString.stringWithContentsOfFile_encoding_error(invalid_path, OSX::NSASCIIStringEncoding)
        assert_kind_of(Array, val)
        assert_equal(2, val.size)
        assert_nil(val.first)
        assert_kind_of(OSX::NSError, val.last)

        o = OSX::NSString.alloc.initWithString('foobar')
        val = o.writeToFile_atomically_encoding_error(invalid_path, false, OSX::NSASCIIStringEncoding, nil)
        assert_equal(false, val)

        val = o.writeToFile_atomically_encoding_error(invalid_path, false, OSX::NSASCIIStringEncoding)
        assert_kind_of(Array, val)
        assert_equal(2, val.size)
        assert_equal(false, val.first)
        assert_kind_of(OSX::NSError, val.last)
    end
end
