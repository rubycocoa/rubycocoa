#
#  Copyright (c) 2006 Laurent Sansonetti, Apple Computer Inc.
#

require 'test/unit'
require 'osx/cocoa'

system 'make' || raise(RuntimeError, "'make' failed")
require 'objc_test.bundle'

class TC_PassByRef < Test::Unit::TestCase

    def test_passbyref_methods
        klass = OSX::PassByRef

        [['passByRefObject:', 0],
         ['passByRefInteger:', 0],
         ['passByRefFloat:', 0],
         ['passByRefVarious:integer:floating:', 0, 1, 2]].each do |ary|

            klass.register_objc_passbyref_instance_method(*ary)
        end
        
        bridged = klass.alloc.init
        
        # Object.
        assert_equal(0, bridged.passByRefObject(nil))
        assert_equal([1, bridged], bridged.passByRefObject_)
    
        # Integer.
        assert_equal(0, bridged.passByRefInteger(nil))
        assert_equal([1, 666], bridged.passByRefInteger_)
        
        # Float.
        assert_equal(0, bridged.passByRefFloat(nil))
        assert_equal([1, 666.0], bridged.passByRefFloat_)

        # Various.
        assert_nil(bridged.passByRefVarious_integer_floating(nil, nil, nil))
        assert_equal([bridged, 666, 666.0], bridged.passByRefVarious_integer_floating_)
        #assert_equal([666, 666.0], bridged.passByRefVarious_integer_floating_(nil))
        #assert_equal([666.0], bridged.passByRefVarious_integer_floating_(nil, nil))
    end

    def test_passbyref_foundation
        invalid_path = '/does/not/exist'

        # XXX
        # Temove me once we get the bridge metadata file. 
        #OSX::NSString.register_objc_passbyref_class_method('stringWithContentsOfFile:encoding:error:', 2)
        #OSX::NSString.register_objc_passbyref_instance_method('writeToFile:atomically:encoding:error:', 3)
        # XXX

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
        assert_equal(0, val)

        val = o.writeToFile_atomically_encoding_error(invalid_path, false, OSX::NSASCIIStringEncoding)
        assert_kind_of(Array, val)
        assert_equal(2, val.size)
        assert_equal(0, val.first)
        assert_kind_of(OSX::NSError, val.last)
    end
end
