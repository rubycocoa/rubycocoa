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

# Add more tests that requires the exceptions files. Disable the tests on non-Leopard machines in the meantime the format is being worked on.
if `sw_vers -productVersion`.strip.to_f >= 10.5
  class TC_PassByRef < Test::Unit::TestCase
    def test_in_c_array_id_foundation
        o1, o2 = OSX::NSObject.alloc.init, OSX::NSObject.alloc.init
        ary = OSX::NSArray.arrayWithObjects_count([o1, o2])
        assert_equal(o1, ary.objectAtIndex(0))
        assert_equal(o2, ary.objectAtIndex(1))
    end

    def test_multiple_in_c_array_it_foundation
        o1, o2 = OSX::NSObject.alloc.init, OSX::NSObject.alloc.init
        o1, o2 = OSX::NSString.alloc.initWithString('o1'), OSX::NSString.alloc.initWithString('o2')
        k1, k2 = OSX::NSString.alloc.initWithString('k1'), OSX::NSString.alloc.initWithString('k2')
        dict = OSX::NSDictionary.dictionaryWithObjects_forKeys_count([o1, o2], [k1, k2])
        assert_equal(o1, dict.objectForKey(k1))
        assert_equal(o2, dict.objectForKey(k2))
        # Both 'array' arguments must have the same length.
        assert_raises(OSX::OCDataConvException) { OSX::NSDictionary.dictionaryWithObjects_forKeys_count([o1, o2], [k1]) }
    end

    def test_in_c_array_byte_foundation
        s = OSX::NSString.alloc.initWithBytes_length_encoding('foobar', OSX::NSASCIIStringEncoding)
        assert_equal(s.to_s, 'foobar')
    end

    def test_out_c_array_byte_foundation
        d = OSX::NSData.alloc.initWithBytes_length('foobar')
        data = '      ' 
        d.getBytes_length(data)
        assert_equal(data, 'foobar')
    end

    def test_ignored_foundation
        d = OSX::NSData.alloc.initWithBytes_length('foobar')
        assert_raises(RuntimeError) { d.getBytes(nil) }
        assert_raises(RuntimeError) { d.getBytes_range(nil, OSX::NSRange.new(0, 1)) }
    end
    # TODO: test NSCoder encode/decode methods
  end
end
