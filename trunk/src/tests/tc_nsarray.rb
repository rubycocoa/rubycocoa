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

  def test_ref
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3, 4, 5)
    b = [1, 2, 3, 4, 5]
    b = b.map {|i| NSNumber.numberWithInt(i) }
    [-10, -5, -3, 0, 3, 5, 10].each do |i|
      assert_equal(b[i], a[i])
    end
  end

  def test_ref_range
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3, 4, 5)
    b = [1, 2, 3, 4, 5]
    b = b.map {|i| NSNumber.numberWithInt(i) }
    [(0..3), (0...3), (0..5), (0...5), (2..20), (1..-1), (1..-10),
     (-3...-1), (-3..4), (-10...3), (-20...-10), (10..3), (10..20)].each do |i|
      assert_equal(b[i], a[i])
    end
  end

  def test_ref_start_and_length
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3, 4, 5)
    b = [1, 2, 3, 4, 5]
    b = b.map {|i| NSNumber.numberWithInt(i) }
    [[0,3], [0,10], [0,-3], [-3,2], [-3,10],
     [-3,-3], [-10,2], [3,0], [10,0]].each do |i|
      assert_equal(b[i[0],i[1]], a[i[0],i[1]])
    end
  end

  def test_assign
    val = 33
    [-5, -3, 0, 3, 5].each do |d|
      a = NSMutableArray.alloc.init
      a.push(1, 2, 3, 4, 5)
      b = [1, 2, 3, 4, 5]
      a[d] = val
      b[d] = val
      b = b.map {|i| NSNumber.numberWithInt(i) }
      assert_equal(NSMutableArray.alloc.initWithArray(b), a)
    end
  end
  
  def test_assign_error
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3, 4, 5)
    assert_raise(IndexError) { a[-10] = 33 }
    assert_raise(IndexError) { a[10] = 33 }
    assert_raise(ArgumentError) { a[3] = nil }
    assert_nothing_raised { a[3] = [] }
  end

  def test_assign_range
    [33, nil, [], [11,22,33]].each do |val|
      [(0..4), (0...4), (0..5), (0...5), (1..15),
       (0...-1), (5..3), (3..10), (1..0), (1..-10),
       (-5...3), (-3..-2)].each do |d|
        a = NSMutableArray.alloc.init
        a.push(1, 2, 3, 4, 5)
        b = [1, 2, 3, 4, 5]
        a[d] = val
        b[d] = val
        b = b.map {|i| NSNumber.numberWithInt(i) }
        assert_equal(NSMutableArray.alloc.initWithArray(b), a)
      end
    end
  end
  
  def test_assign_range_error
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3, 4, 5)
    assert_raise(IndexError) { a[-10..5] = nil }
    assert_raise(IndexError) { a[10..5] = nil }
    assert_nothing_raised { a[5..5] = nil }
    assert_nothing_raised { a[5..-10] = nil }
    assert_nothing_raised { a[5..5] = nil }
  end

  def test_assign_start_and_length
    [33, nil, [], [11,22,33]].each do |val|
      [[1,3], [1,10], [-3,2], [-3,10]].each do |d|
        a = NSMutableArray.alloc.init
        a.push(1, 2, 3, 4, 5)
        b = [1, 2, 3, 4, 5]
        a[d[0],d[1]] = val
        b[d[0],d[1]] = val
        b = b.map {|i| NSNumber.numberWithInt(i) }
        assert_equal(NSMutableArray.alloc.initWithArray(b), a)
      end
    end
  end

  def test_assign_start_and_length_error
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3, 4, 5)
    assert_raise(IndexError) { a[-10,2] = nil }
    assert_raise(IndexError) { a[10,2] = nil }
    assert_raise(IndexError) { a[3,-2] = nil }
    assert_nothing_raised { a[3,0] = nil }
  end

  def test_plus
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3)
    a = a + [4,5,6] + a
    a = a.map {|i| i.to_i }
    e = [1,2,3]
    e = e + [4,5,6] + e
    assert_equal(e, a)
  end

  def test_plus_error
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3)
    assert_raise(TypeError) { a + 0 }
    assert_nothing_raised { a + NSArray.arrayWithArray([1,2]) }
  end

  def test_plus_equal
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3)
    a += [4, 5, 6]
    a += [7, 8, 9]
    b = [1, 2, 3]
    b += [4, 5, 6]
    b += [7, 8, 9]
    a = a.map {|i| i.to_i }
    assert_equal(b, a)
  end

  def test_multiply
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3)
    a *= 3
    a = a.map {|i| i.respond_to?(:to_ruby) ? i.to_ruby : i }
    b = [1,2,3]
    b *= 3
    assert_equal(b, a)

    a = NSMutableArray.alloc.init
    a.push(1, 2, 3)
    s = a * ','
    assert_equal([1,2,3]*',', s)
  end

  def test_multiply_error
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3)
    assert_nothing_raised { a * 1.5 }
    assert_raise(TypeError) { a * [] }
  end

  def test_minus
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3)
    b = NSMutableArray.alloc.init
    b.push(1, 4)
    a = a - b
    a = a.map {|i| i.to_i }
    c = [1,2,3]
    c = c - [1,4]
    assert_equal(c, a)
  end

  def test_minus_error
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3)
    assert_nothing_raised { a * 1.5 }
    assert_raise(TypeError) { a * [] }
  end

  def test_and
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3, 4)
    b = NSMutableArray.alloc.init
    b.push(1, 4, 5)
    a = a & b
    a = a.map {|i| i.to_i }
    c = [1,2,3,4]
    c = c & [1,4,5]
    assert_equal(c, a)
    
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3, 4)
    b = NSMutableArray.alloc.init
    b.push(6, 7)
    a = a & b
    a = a.map {|i| i.to_i }
    c = [1,2,3,4]
    c = c & [6,7]
    assert_equal(c, a)
  end
  
  def test_and_error
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3)
    assert_nothing_raised { a & [] }
    assert_raise(TypeError) { a & 5.5 }
  end

  def test_or
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3, 4)
    b = NSMutableArray.alloc.init
    b.push(1, 4, 5)
    a = a | b
    a = a.map {|i| i.to_i }
    c = [1,2,3,4]
    c = c | [1,4,5]
    assert_equal(c, a)
    
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3, 4)
    b = NSMutableArray.alloc.init
    b.push(6, 7)
    a = a | b
    a = a.map {|i| i.to_i }
    c = [1,2,3,4]
    c = c | [6,7]
    assert_equal(c, a)
    
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3, 4)
    a = a | []
    a = a.map {|i| i.to_i }
    assert_equal([1,2,3,4]|[], a)
  end
  
  def test_or_error
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3)
    assert_nothing_raised { a | [] }
    assert_raise(TypeError) { a | 5.5 }
  end
  
  def test_push_op
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3)
    b = NSMutableArray.alloc.init
    b << 1 << 2 << 3
    assert_equal(a, b)
  end
  
  def test_assoc
    a = NSMutableArray.alloc.init
    a.push([1,2])
    a.push(1)
    a.push([4,5])
    a.push([8,5])
    r = a.assoc(4)
    r = r.map {|i| i.to_i }
    assert_equal([4,5], r)
  end
  
  def test_at
    [-2, 2, 3].each do |i|
      a = NSMutableArray.alloc.init
      a.push(1, 2, 3)
      a = a.at(i)
      a = a.to_i if NSNumber === a
      b = [1,2,3]
      b = b.at(i)
      assert_equal(b, a)
    end
  end
  
  def test_at_error
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3)
    assert_nothing_raised { a.at(-1) }
    assert_nothing_raised { a.at(30) }
    assert_raise(TypeError) { a.at(nil) }
    assert_raise(TypeError) { a.at([]) }
  end

  def test_clear
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3, 4, 5)
    a.clear
    assert_equal(0, a.size)
  end

  def test_collect!
    a = NSMutableArray.alloc.init
    a.push(1, 2, 3, 4, 5)
    a.collect! {|i| i.to_i * 2 }
    e = NSMutableArray.alloc.init
    e.push(2, 4, 6, 8, 10)
    assert_equal(e, a)
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
    assert_equal(e, a)
  end
  
  def test_delete
    a = NSMutableArray.alloc.init
    a.push(1, 2, 1, 4, 5)
    r = a.delete(1)
    assert_equal(r, 1)
    a = a.map {|i| i.to_i }
    e = [1,2,1,4,5]
    r = e.delete(1)
    assert_equal(r, 1)
    assert_equal(e, a)
    
    a = NSMutableArray.alloc.init
    a.push(5)
    r = a.delete(1)
    assert_equal(r, nil)
    a = a.map {|i| i.to_i }
    e = [5]
    r = e.delete(1)
    assert_equal(r, nil)
    assert_equal(e, a)
  end
  
  def test_delete_at
    [-2, 2, 8].each do |d|
      a = NSMutableArray.alloc.init
      a.push(1, 2, 1, 4, 5)
      x = a.delete_at(d)
      x = x.to_i if x
      a = a.map {|i| i.to_i }
      e = [1,2,1,4,5]
      y = e.delete_at(d)
      assert_equal(x, y)
      assert_equal(e, a)
    end
  end
  
  def test_delete_if
    a = NSMutableArray.alloc.init
    a.push(1, 2, 1, 4, 5)
    a.delete_if {|i| i.to_i < 3 }
    a = a.map {|i| i.to_i }
    e = [1,2,1,4,5]
    e.delete_if {|i| i < 3 }
    assert_equal(e, a)
  end
  
  def test_each_index
    a = NSMutableArray.alloc.init
    a.push(1, 2, 1, 4, 5)
    n = 0
    a.each_index {|i| n += 1 }
    assert_equal(a.size, n)
  end
  
  def test_empty?
    a = NSMutableArray.alloc.init
    assert_equal(true, a.empty?)
    a.push(1)
    assert_equal(false, a.empty?)
  end
  
  def test_fetch
    a = NSMutableArray.alloc.init
    a.push(1, 2, 1, 4, 5)
    r = a.fetch(2)
    assert_equal(a[2], r)
    r = a.fetch(-1)
    assert_equal(a[-1], r)
    assert_raise(IndexError) { a.fetch(10) }
    assert_raise(IndexError) { a.fetch(-10) }
    r = a.fetch(7, 99)
    assert_equal(99, r)
    r = a.fetch(7) { 45 }
    assert_equal(45, r)
  end

  def test_join
    a = NSMutableArray.alloc.init
    a.push(1, [2,3,[4,5]], 6)
    s = a.join(',')
    assert_equal([1,[2,3,[4,5]],6].join(','), s)

    s = a.join
    assert_equal([1,[2,3,[4,5]],6].join, s)

    $, = '::'
    s = a.join
    assert_equal([1,[2,3,[4,5]],6].join, s)
    $, = nil
  end
  
  def test_join_error
    a = NSMutableArray.alloc.init
    a.push(1, [2,3,[4,5]], 6)
    assert_raise(TypeError) { a.join([]) }
    assert_raise(ArgumentError) { a.join(1,2) }
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
end
