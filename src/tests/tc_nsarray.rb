require 'test/unit'
require 'osx/cocoa'

class TC_NSArray < Test::Unit::TestCase
  include OSX
  
  def alloc_nsarray(*args)
    ary = NSMutableArray.alloc.init
    args.each {|i| ary.push(i) }
    ary
  end
  
  def to_nsarray(ary)
    NSMutableArray.arrayWithArray(ary)
  end
  
  def map_to_nsnumber(ary)
    ary.map {|i| NSNumber.numberWithInt(i) }
  end
  
  def map_to_int(ary)
    ary.map {|i| i.to_i }
  end
  
  def test_equal
    a = alloc_nsarray(1,2,3)
    b = map_to_nsnumber([1,2,3])
    assert(a == b)
  end

  def test_ref
    a = alloc_nsarray(1,2,3,4,5)
    b = map_to_nsnumber([1,2,3,4,5])
    [-10, -5, -3, 0, 3, 5, 10].each do |i|
      assert_equal(b[i], a[i])
    end
  end

  def test_ref_range
    a = alloc_nsarray(1,2,3,4,5)
    b = map_to_nsnumber([1,2,3,4,5])
    [(0..3), (0...3), (0..5), (0...5), (2..20), (1..-1), (1..-10),
     (-3...-1), (-3..4), (-10...3), (-20...-10), (10..3), (10..20)].each do |i|
      assert_equal(b[i], a[i])
    end
  end

  def test_ref_start_and_length
    a = alloc_nsarray(1,2,3,4,5)
    b = map_to_nsnumber([1,2,3,4,5])
    [[0,3], [0,10], [0,-3], [-3,2], [-3,10],
     [-3,-3], [-10,2], [3,0], [10,0]].each do |i|
      assert_equal(b[*i], a[*i])
    end
  end

  def test_assign
    val = 33
    [-5, -3, 0, 3, 5].each do |d|
      a = alloc_nsarray(1,2,3,4,5)
      b = [1,2,3,4,5]
      a[d] = val
      b[d] = val
      b = map_to_nsnumber(b)
      assert_equal(to_nsarray(b), a)
    end
  end
  
  def test_assign_error
    a = alloc_nsarray(1,2,3,4,5)
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
        a = alloc_nsarray(1,2,3,4,5)
        b = [1,2,3,4,5]
        a[d] = val
        b[d] = val
        b = map_to_nsnumber(b)
        assert_equal(to_nsarray(b), a)
      end
    end
  end
  
  def test_assign_range_error
    a = alloc_nsarray(1,2,3,4,5)
    assert_raise(IndexError) { a[-10..5] = nil }
    assert_raise(IndexError) { a[10..5] = nil }
    assert_nothing_raised { a[5..5] = nil }
    assert_nothing_raised { a[5..-10] = nil }
    assert_nothing_raised { a[5..5] = nil }
  end

  def test_assign_start_and_length
    [33, nil, [], [11,22,33]].each do |val|
      [[1,3], [1,10], [-3,2], [-3,10]].each do |d|
        a = alloc_nsarray(1,2,3,4,5)
        b = [1,2,3,4,5]
        a[*d] = val
        b[*d] = val
        b = map_to_nsnumber(b)
        assert_equal(to_nsarray(b), a)
      end
    end
  end

  def test_assign_start_and_length_error
    a = alloc_nsarray(1,2,3,4,5)
    assert_raise(IndexError) { a[-10,2] = nil }
    assert_raise(IndexError) { a[10,2] = nil }
    assert_raise(IndexError) { a[3,-2] = nil }
    assert_nothing_raised { a[3,0] = nil }
  end

  def test_plus
    a = alloc_nsarray(1,2,3)
    a = a + [4,5,6] + a
    a = map_to_int(a)
    e = [1,2,3]
    e = e + [4,5,6] + e
    assert_equal(e, a)
  end

  def test_plus_error
    a = alloc_nsarray(1,2,3)
    assert_raise(TypeError) { a + 0 }
    assert_nothing_raised { a + alloc_nsarray(1,2) }
  end

  def test_plus_equal
    a = alloc_nsarray(1,2,3)
    a += [4, 5, 6]
    a += [7, 8, 9]
    b = [1, 2, 3]
    b += [4, 5, 6]
    b += [7, 8, 9]
    a = map_to_int(a)
    assert_equal(b, a)
  end

  def test_multiply
    a = alloc_nsarray(1,2,3)
    a *= 3
    a = map_to_int(a)
    b = [1,2,3]
    b *= 3
    assert_equal(b, a)

    a = alloc_nsarray(1,2,3)
    s = a * ','
    assert_equal([1,2,3]*',', s)
  end

  def test_multiply_error
    a = alloc_nsarray(1,2,3)
    assert_nothing_raised { a * 1.5 }
    assert_raise(TypeError) { a * [] }
  end

  def test_minus
    a = alloc_nsarray(1,2,3)
    b = alloc_nsarray(1,4)
    a = a - b
    a = map_to_int(a)
    c = [1,2,3]
    c = c - [1,4]
    assert_equal(c, a)
  end

  def test_minus_error
    a = alloc_nsarray(1,2,3)
    assert_nothing_raised { a * 1.5 }
    assert_raise(TypeError) { a * [] }
  end

  def test_and
    a = alloc_nsarray(1,2,3,4)
    b = alloc_nsarray(1,4,5)
    a = a & b
    a = map_to_int(a)
    c = [1,2,3,4]
    c = c & [1,4,5]
    assert_equal(c, a)
    
    a = alloc_nsarray(1,2,3,4)
    b = alloc_nsarray(6,7)
    a = a & b
    a = map_to_int(a)
    c = [1,2,3,4]
    c = c & [6,7]
    assert_equal(c, a)
  end
  
  def test_and_error
    a = alloc_nsarray(1,2,3)
    assert_nothing_raised { a & [] }
    assert_raise(TypeError) { a & 5.5 }
  end

  def test_or
    a = alloc_nsarray(1,2,3,4)
    b = alloc_nsarray(1,4,5)
    a = a | b
    a = map_to_int(a)
    c = [1,2,3,4]
    c = c | [1,4,5]
    assert_equal(c, a)
    
    a = alloc_nsarray(1,2,3,4)
    b = alloc_nsarray(6,7)
    a = a | b
    a = map_to_int(a)
    c = [1,2,3,4]
    c = c | [6,7]
    assert_equal(c, a)
    
    a = alloc_nsarray(1,2,3,4)
    a = a | []
    a = map_to_int(a)
    assert_equal([1,2,3,4]|[], a)
  end
  
  def test_or_error
    a = alloc_nsarray(1,2,3)
    assert_nothing_raised { a | [] }
    assert_raise(TypeError) { a | 5.5 }
  end
  
  def test_push_op
    a = alloc_nsarray(1,2,3)
    b = alloc_nsarray
    b << 1 << 2 << 3
    assert_equal(a, b)
  end
  
  def test_assoc
    a = alloc_nsarray([], 1, [4,5], [8,5])
    r = a.assoc(4)
    r = map_to_int(r)
    assert_equal([4,5], r)
  end
  
  def test_at
    [-2, 2, 3].each do |i|
      a = alloc_nsarray(1,2,3)
      a = a.at(i)
      a = a.to_i if NSNumber === a
      b = [1,2,3]
      b = b.at(i)
      assert_equal(b, a)
    end
  end
  
  def test_at_error
    a = alloc_nsarray(1,2,3)
    assert_nothing_raised { a.at(-1) }
    assert_nothing_raised { a.at(30) }
    assert_raise(TypeError) { a.at(nil) }
    assert_raise(TypeError) { a.at([]) }
  end

  def test_clear
    a = alloc_nsarray(1,2,3)
    a.clear
    assert_equal(0, a.size)
  end

  def test_collect!
    a = alloc_nsarray(1,2,3,4,5)
    a.collect! {|i| i.to_i * 2 }
    e = [1,2,3,4,5].map {|i| i*2 }
    e = map_to_nsnumber(e)
    assert_equal(e, a)
  end
  
  def test_concat
    a = alloc_nsarray(1,2)
    b = [3,4]
    b = map_to_nsnumber(b)
    a.concat(b)
    e = alloc_nsarray(1,2,3,4)
    assert_equal(e, a)
  end
  
  def test_delete
    a = alloc_nsarray(1,2,1,4,5)
    r = a.delete(1)
    assert_equal(r, 1)
    a = map_to_int(a)
    e = [1,2,1,4,5]
    r = e.delete(1)
    assert_equal(r, 1)
    assert_equal(e, a)
    
    a = alloc_nsarray(5)
    r = a.delete(1)
    assert_equal(r, nil)
    a = map_to_int(a)
    e = [5]
    r = e.delete(1)
    assert_equal(r, nil)
    assert_equal(e, a)
  end
  
  def test_delete_at
    [-2, 2, 8].each do |d|
      a = alloc_nsarray(1,2,1,4,5)
      x = a.delete_at(d)
      x = x.to_i if x
      a = map_to_int(a)
      e = [1,2,1,4,5]
      y = e.delete_at(d)
      assert_equal(x, y)
      assert_equal(e, a)
    end
  end
  
  def test_delete_if
    a = alloc_nsarray(1,2,1,4,5)
    a.delete_if {|i| i.to_i < 3 }
    a = map_to_int(a)
    e = [1,2,1,4,5]
    e.delete_if {|i| i < 3 }
    assert_equal(e, a)
  end
  
  def test_each_index
    a = alloc_nsarray(1,2,1,4,5)
    n = 0
    a.each_index {|i| n += 1 }
    assert_equal(a.size, n)
  end
  
  def test_empty?
    a = alloc_nsarray
    assert_equal(true, a.empty?)
    a.push(1)
    assert_equal(false, a.empty?)
  end
  
  def test_fetch
    a = alloc_nsarray(1,2,1,4,5)
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
  
  def test_fill
    a = alloc_nsarray(1,2,3,4,5)
    a.fill {|i| i*2 }
    a = map_to_int(a)
    b = [1,2,3,4,5].fill {|i| i*2 }
    assert_equal(b, a)
    
    a = alloc_nsarray(1,2,3,4,5)
    a.fill(99)
    a = map_to_int(a)
    b = [1,2,3,4,5].fill(99)
    assert_equal(b, a)
    
    [-20, -3, 3, 20].each do |d|
      a = alloc_nsarray(1,2,3,4,5)
      a.fill(d) {|i| i*2 }
      a = map_to_int(a)
      b = [1,2,3,4,5].fill(d) {|i| i*2 }
      assert_equal(b, a)
      
      a = alloc_nsarray(1,2,3,4,5)
      a.fill(99, d)
      a = map_to_int(a)
      b = [1,2,3,4,5].fill(99, d)
      assert_equal(b, a)
    end
    
    [(-3...5), (-4..-1), (0..8), (5..6)].each do |d|
      a = alloc_nsarray(1,2,3,4,5)
      a.fill(d) {|i| i+100 }
      a = map_to_int(a)
      b = [1,2,3,4,5].fill(d) {|i| i+100 }
      assert_equal(b, a)
      
      a = alloc_nsarray(1,2,3,4,5)
      a.fill(99, d)
      a = map_to_int(a)
      b = [1,2,3,4,5].fill(99, d)
      assert_equal(b, a)
    end
    
    [[-3,2], [-4,8], [-5,30], [5,10]].each do |d|
      a = alloc_nsarray(1,2,3,4,5)
      a.fill(*d) {|i| i+100 }
      a = map_to_int(a)
      b = [1,2,3,4,5].fill(*d) {|i| i+100 }
      assert_equal(b, a)
      
      a = alloc_nsarray(1,2,3,4,5)
      a.fill(99, *d)
      a = map_to_int(a)
      b = [1,2,3,4,5].fill(99, *d)
      assert_equal(b, a)
    end
  end
  
  def test_fill_error
    a = alloc_nsarray(1,2,3,4,5)
    assert_raise(RangeError) { a.fill(8..12) {|i| i } }
    assert_raise(RangeError) { a.fill(99, 8..12) }
    assert_raise(RangeError) { a.fill(99, -10..4) }
    assert_raise(RangeError) { a.fill(99, 10..15) }
    assert_raise(IndexError) { a.fill(99, -10,4) }
    assert_raise(IndexError) { a.fill(99, 10,4) }
    assert_nothing_raised { a.fill(5..12) {|i| i} }
    assert_nothing_raised { a.fill(99, 5..12) }
    assert_nothing_raised { a.fill(99, 6, 8) }
  end

  def test_first
    a = alloc_nsarray(1,2,3,4,5)
    r = a.first.to_i
    assert_equal(1, r)
    a = alloc_nsarray
    r = a.first
    assert_equal(nil, r)

    0.upto(6) do |d|
      a = alloc_nsarray(1,2,3,4,5)
      a = a.first(d)
      a = map_to_int(a)
      b = [1,2,3,4,5].first(d)
      assert_equal(b, a)
    end
  end

  def test_first_error
    a = alloc_nsarray
    assert_raise(ArgumentError) { a.first(-1) }
  end

  def test_flatten
    a = alloc_nsarray(1, [2,3,[4,5]], 6)
    a = a.flatten
    a = map_to_int(a)
    assert_equal([1,2,3,4,5,6], a)
    
    a = alloc_nsarray(1, [2,3,[4,5]], 6)
    a.flatten!
    a = map_to_int(a)
    assert_equal([1,2,3,4,5,6], a)
    
    a = alloc_nsarray
    a = a.flatten
    assert_equal([], a)
  end
  
  def test_index
    a = alloc_nsarray(1,2,3,4,5)
    r = a.index(4)
    assert_equal(3, r)
    r = a.index {|i| i.to_i % 2 == 0 }
    assert_equal(1, r)
    r = a.index {|i| i.to_i > 12 }
    assert_equal(nil, r)
  end

  def test_index_error
    a = alloc_nsarray
    assert_raise(ArgumentError) { a.index(-1, 3) }
  end
  
  def test_join
    a = alloc_nsarray(1, [2,3,[4,5]], 6)
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
    a = alloc_nsarray(1, [2,3,[4,5]], 6)
    assert_raise(TypeError) { a.join([]) }
    assert_raise(ArgumentError) { a.join(1,2) }
  end

  def test_size
    a = alloc_nsarray(1,2)
    assert_equal(2, a.size)
    assert_equal(2, a.length)
  end

  def test_push
    a = alloc_nsarray
    a.push(1,2,3,4,5)
    assert_equal(5, a.size)
  end
end
