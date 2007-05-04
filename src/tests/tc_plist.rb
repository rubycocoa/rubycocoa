#
#  Copyright (c) 2007 Laurent Sansonetti, Apple Computer Inc.
#

require 'test/unit'
require 'osx/cocoa'

class TC_Plist < Test::Unit::TestCase

  def test_array
    obj = ['ichi', 2, 3, 'quatre', 5]
    verify(obj, OSX::NSArray)
  end

  def test_dict
    obj = {'un' => 1, 'deux' => 'ni', 'trois' => 3}
    verify(obj, OSX::NSDictionary)
  end

  def test_fixnum
    obj = 42
    verify(obj, OSX::NSNumber)
  end

  def test_bignum
    obj = 100_000_000_000
    verify(obj, OSX::NSNumber)
  end

  def test_float
    obj = 42.5
    verify(obj, OSX::NSNumber)
  end

  def test_boolean
    verify(true, OSX::NSCFBoolean)
    verify(false, OSX::NSCFBoolean)
  end

  def test_time
    verify(Time.now, OSX::NSDate)
  end

  def test_complex
    hash = {
      'foo' => [ 1, 2, 3 ],
      'bar' => [ 4, 5, 6 ],
      'edited' => true,
      'last_modification' => Time.now 
    }
    verify(hash, OSX::NSDictionary)
  end

  def verify(rbobj, nsklass)
    [ nil, 
      OSX::NSPropertyListXMLFormat_v1_0, 
      OSX::NSPropertyListBinaryFormat_v1_0 ].each do |format|
   
      data = rbobj.to_plist(format)
      assert_kind_of(String, data)
      obj = OSX.load_plist(data)
      assert_kind_of(nsklass, obj)
      assert(obj.isEqual(rbobj))
    end
  end

  def test_invalid_object
    assert_raise(RuntimeError) do
      obj = { 1 => 1 }
      obj.to_plist
    end
  end

  def test_invalid_plist_data
    assert_raise(RuntimeError) do
      OSX.load_plist(nil)
    end
    assert_raise(RuntimeError) do
      OSX.load_plist('some invalid data')
    end
  end

end
