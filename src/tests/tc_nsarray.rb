require 'test/unit'
require 'osx/cocoa'

class TC_NSArray < Test::Unit::TestCase
  include OSX
  
  def test_equal
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3)
    ary = []
    ary << NSNumber.numberWithInt(1)
    ary << NSNumber.numberWithInt(2)
    ary << NSNumber.numberWithInt(3)
    assert(a == ary)
  end
  
  def test_concat
    a = NSMutableArray.alloc.init
    a.push(1, 2)
    ary = []
    ary << NSNumber.numberWithInt(3)
    ary << NSNumber.numberWithInt(4)
    a.concat(ary)
    e = NSMutableArray.alloc.init
    e.push(1, 2, 3, 4)
    assert(a == e)
  end

  def test_size
    a = NSMutableArray.alloc.init
    a.push(1, 2)
    assert_equal(2, a.size)
    assert_equal(2, a.length)
  end

  def test_push
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3, 4, 5)
    assert_equal(5, a.size)
  end

  def test_assign
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3, 4, 5)
    a[1] = 33
    assert_equal(5, a.size)
    assert_equal(33, a[1].to_i)
    a[1..2] = nil
    assert_equal(3, a.size)
  end

  def test_ref
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3, 4, 5)
    e = NSMutableArray.alloc.init
    e.push(2, 3, 4)
    assert_equal(e, a[1..3])
    e = NSMutableArray.alloc.init
    e.push(3, 4, 5)
    assert_equal(e, a[2..-1])
    e = NSMutableArray.alloc.init
    e.push(3, 4)
    assert_equal(e, a[-3..-2])
  end

  def test_clear
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3, 4, 5)
    a.clear
    assert_equal(0, a.size)
  end

  def test_plus
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3)
    a = a + a
    assert_equal(6, a.size)
    a = a.map {|i| i.to_ruby }
    assert_equal([1,2,3,1,2,3], a)
  end

  def test_plus_equal
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3)
    b = NSMutableArray.alloc.init
    b.push(4, 5)
    a += b
    a += [6, 7]
    assert_equal(7, a.size)
  end
end
