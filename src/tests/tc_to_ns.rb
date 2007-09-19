#
#  Copyright (c) 2007 Laurent Sansonetti, Apple Computer Inc.
#

require 'test/unit'
require 'osx/cocoa'

class Time
  def ==(o)
    o.is_a?(Time) ? self.to_i == o.to_i : false
  end
end

class TC_to_ns < Test::Unit::TestCase

  def test_array
    obj = ['ichi', 2, 3, 'quatre', 5]
    verify(obj, OSX::NSArray)
  end

  def test_dict
    obj = {'un' => 1, 'deux' => 'ni', 'trois' => 3}
    verify(obj, OSX::NSDictionary)
  end

  def test_fixnum
    verify(42, OSX::NSNumber)
  end

  def test_bignum
    verify(100_000_000_000, OSX::NSNumber)
  end

  def test_float
    verify(42.5, OSX::NSNumber)
  end

  def test_boolean
    verify(true, OSX::NSNumber)
    verify(false, OSX::NSNumber)
  end

  def test_time
    verify(Time.now, OSX::NSDate)
  end

  def verify(obj, klass)
    nsobj = obj.to_ns
    assert_kind_of(klass, nsobj)
    assert_equal(nsobj.to_ruby, obj)
  end

  def test_invalid_object
    assert(!/123/.respond_to?(:to_ns))
  end

end
