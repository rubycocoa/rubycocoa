# -*- mode:ruby; indent-tabs-mode:nil; coding:utf-8 -*-
require 'test/unit'
require 'osx/cocoa'

def with_kcode(k)
  cur = $KCODE
  $KCODE = k
  yield
ensure
  $KCODE = cur
end

class TC_ObjcString < Test::Unit::TestCase

  def setup
    @nsstr = OSX::NSString.stringWithString('NSString')
  end

  # to_str convenience

  def test_autoconv
    path = OSX::NSString.stringWithString(__FILE__)
    assert_nothing_raised('NSString treat as RubyString with "to_str"') {
      open(path) {"no operation"}
    }
  end

  # comparison between Ruby String and Cocoa String

  def test_comparison
    # receiver: OSX::NSString
    assert_equal(0, @nsstr <=> 'NSString', '1-1.NSStr <=> Str -> true')
    assert_not_equal(0, @nsstr <=> 'RBString', '1-2.NSStr <=> Str -> false')
    assert(@nsstr == 'NSString', '1-3.NSStr == Str -> true')
    assert(!(@nsstr == 'RBString'), '1-4.NSStr == Str -> false')
    # receiver: String
    assert_equal(0, 'NSString' <=> @nsstr, '2-1.Str <=> NSStr -> true')
    assert_not_equal(0, 'nsstring' <=> @nsstr, '2-2.Str <=> NSStr -> false')
    assert('NSString' == @nsstr, '2-3.Str == NSStr -> true')
    assert(!('RBString' == @nsstr), '2-4.Str == NSStr -> false')
  end

  def test_length
    with_kcode('utf-8') do
      assert_equal  7,  OSX::NSString.stringWithString('日本語の文字列').length
      assert_equal 11, OSX::NSString.stringWithString('English+日本語').length # Japanese
      assert_equal 15, OSX::NSString.stringWithString('English+العربية').length # Arabic
      assert_equal 11, OSX::NSString.stringWithString('English+한국어').length # Hungle
      assert_equal 18, OSX::NSString.stringWithString('English+Российская').length # Russian
    end
  end

  # forwarding to Ruby String

  def test_respond_to
    assert_respond_to(@nsstr, :ocm_send, 'should respond to "OSX::ObjcID#ocm_send"')
    assert_respond_to(@nsstr, :gsub, 'should respond to "String#gsub"')
    assert_respond_to(@nsstr, :+, 'should respond to "String#+"')
    assert(!@nsstr.respond_to?(:_xxx_not_defined_method_xxx_), 
      'should not respond to undefined method in String')
  end

  def test_call_string_method
    str = ""
    assert_nothing_raised() {str = @nsstr + 'Appended'}
    assert_equal('NSStringAppended', str) 
  end

  def test_immutable
    assert_raise(OSX::OCException, 'cannot modify immutable string') {
      @nsstr.gsub!(/S/, 'X')
    }
    assert_equal('NSString', @nsstr.to_s, 'value not changed on error(gsub!)')
    assert_raise(OSX::OCException, 'cannot modify immutable string') {
      @nsstr << 'Append'
    }
    assert_equal('NSString', @nsstr.to_s, 'value not changed on error(<<!)')
  end

  def test_mutable
    str = OSX::NSMutableString.stringWithString('NSMutableString')
    assert_nothing_raised('can modify mutable string') {
      str.gsub!(/S/, 'X')}
    assert_equal('NXMutableXtring', str.to_s)
  end
  
  # NSString duck typing
  
  def alloc_nsstring(s)
    OSX::NSMutableString.stringWithString(s)
  end

  def test_times
    s = 'foo'
    n = alloc_nsstring(s)
    s = s * 5
    n = n * 5
    assert_equal(s, n)

    s = 'foo'
    n = alloc_nsstring(s)
    s = s * 0
    n = n * 0
    assert_equal(s, n)
  end
  
  def test_times_error
    s = 'foo'
    n = alloc_nsstring(s)
    assert_raise(TypeError) { s * '' }
    assert_raise(TypeError) { n * '' }
  end
  
  def test_plus
    s = 'foo'
    n = alloc_nsstring(s)
    s = s + 'bar'
    n = n + 'bar'
    assert_equal(s, n)
  end
  
  def test_plus_error
    s = 'foo'
    n = alloc_nsstring(s)
    assert_raise(TypeError) { s + 42 }
    assert_raise(TypeError) { n + 42 }
    assert_raise(TypeError) { s + nil }
    assert_raise(TypeError) { n + nil }
  end
  
  def test_concat
    with_kcode('utf-8') do
      s = alloc_nsstring('foo')
      s << 'abc'
      assert_equal('fooabc', s)
      s << 123
      assert_equal('fooabc{', s)
      s.concat 0x3053
      assert_equal('fooabc{こ', s)
    end
  end
  
  def test_concat_error
    s = 'foo'
    n = alloc_nsstring(s)
    assert_raise(TypeError) { s << [] }
    assert_raise(TypeError) { n << [] }
    assert_raise(TypeError) { s << nil }
    assert_raise(TypeError) { n << nil }
  end
  
  def test_ref_nth
    s = 'abc'
    n = alloc_nsstring(s)
    [0, -1, -3, -4, -10, 2, 3, 10].each do |i|
      assert_equal(s[i], n[i])
    end
    
    with_kcode('utf-8') do
      s = alloc_nsstring('foo かきくけこ')
      assert_equal(0x3051, s[-2])
      assert_equal(0x3053, s[8])
      assert_equal(nil, s[10])
      assert_equal(nil, s[-10])
    end
  end
  
  def test_ref_substr
    with_kcode('utf-8') do
      s = alloc_nsstring('foo かきくけこ')
      assert_equal('きくけ', s['きくけ'])
      assert_equal('', s[''])
      assert_equal(nil, s['abc'])
    end
  end
  
  def test_ref_range
    s = 'abc'
    n = alloc_nsstring(s)
    [0..0, 0..2, 0..10, 2..10, -1..0, -2..2, -3..2, -4..2].each do |i|
      assert_equal(s[i], n[i])
    end
    
    with_kcode('utf-8') do
      s = alloc_nsstring('foo かきくけこ')
      assert_equal('foo', s[0..2])
      assert_equal('oo', s[1...3])
      assert_equal('くけこ', s[-3..8])
      assert_equal('けこ', s[7..10])
      assert_equal(nil, s[-10..-9])
      assert_equal('', s[5..4])
      assert_equal(nil, s[10..10])
      assert_equal(nil, s[10..-2])
    end
  end
  
  def test_ref_nth_len
    s = 'abc'
    n = alloc_nsstring(s)
    [[0,0], [0,2], [0,10], [2,10], [3,3], [-1,0], [-2,2], [-3,2], [-4,2]].each do |i|
      assert_equal(s[*i], n[*i])
    end
  end
  
  def test_ref_error
    n = alloc_nsstring('foo')
    assert_raise(TypeError) { n[[]] }
    assert_raise(TypeError) { n[{}] }
    assert_raise(TypeError) { n[nil] }
    assert_raise(TypeError) { n[3,nil] }
  end
  
=begin
  def test_ref_regexp
    with_kcode('utf-8') do
      s = OSX::NSMutableString.stringWithString('foo かきくけこ')
      assert_equal('きくけ', s[/きくけ/])
      assert_equal('foo', s[/^foo/])
      assert_equal(nil, s[/ABC/])
    end
  end
  
  def test_ref_regexp_n
    with_kcode('utf-8') do
      s = OSX::NSMutableString.stringWithString('foo bar buz')
      assert_equal('foo bar', s[/([a-z]+) ([a-z]+)/,0])
      assert_equal('bar', s[/([a-z]+) ([a-z]+)/,2])
    end
  end
=end
  
  def test_capitalize
    ['foO bar buz', ''].each do |s|
      n = alloc_nsstring(s)
      assert_equal(s.capitalize, n.capitalize)
      assert_equal(s.capitalize!, n.capitalize!)
    end
  end
  
  def test_chop
    ['abc', "abc\n", "abc\r\n", "abc\r", ''].each do |s|
      n = alloc_nsstring(s)
      assert_equal(s.chop, n.chop)
      assert_equal(s.chop!, n.chop!)
    end
  end
  
  def test_clear
    s = alloc_nsstring('Foobar')
    assert_equal(s, s.clear)
    assert_equal('', s)
    assert_equal(0, s.length)
  end
  
  def test_downcase
    ['foO bar buz', ''].each do |s|
      n = alloc_nsstring(s)
      assert_equal(s.downcase, n.downcase)
      assert_equal(s.downcase!, n.downcase!)
    end
  end
  
  def test_each_line
    ["abc\ndef\r\nghi\njkl\n", "\n\n\nabc", "", "a\nb", "abc\rdef",
     "\nabc\n\ndef\nghi\njkl\n\nmnopq\n\n"].each do |s|
      n = alloc_nsstring(s)
      a = []
      b = []
      n.each {|i| a << i.to_ruby }
      s.each {|i| b << i }
      assert_equal(b, a)
      a = []
      b = []
      n.each(nil) {|i| a << i.to_ruby }
      s.each(nil) {|i| b << i }
      assert_equal(b, a)
      a = []
      b = []
      n.each("\r\n") {|i| a << i.to_ruby }
      s.each("\r\n") {|i| b << i }
      assert_equal(b, a)
      a = []
      b = []
      n.each('') {|i| a << i.to_ruby }
      s.each('') {|i| b << i }
      assert_equal(b, a)
    end
  end
  
  def test_empty
    s = alloc_nsstring('Foobar')
    assert_equal(false, s.empty?)
    assert_equal(true, s.clear.empty?)
  end
  
  def test_end_with
    s = alloc_nsstring('abc def')
    assert_equal(false, s.end_with?('abc'))
    assert_equal(true, s.end_with?('def'))
  end
  
  def test_include
    with_kcode('utf-8') do
      s = alloc_nsstring('abc def')
      assert_equal(true, s.include?('c d'))
      assert_equal(true, s.include?(0x62))
      assert_equal(false, s.include?('C D'))
      assert_equal(false, s.include?(0x41))
      s = alloc_nsstring('abc かきくけこ')
      assert_equal(true, s.include?('かき'))
      assert_equal(true, s.include?(0x3053))
      assert_equal(false, s.include?('は'))
      assert_equal(false, s.include?(0x3060))
    end
  end
  
  def test_intern
    ['foo', 'abc_def', 'A_b_C'].each do |s|
      n = alloc_nsstring(s)
      assert_equal(s.intern, n.intern)
      assert_equal(s.to_sym, n.to_sym)
    end
  end
  
  def test_lines
    ["abc\ndef\r\nghi\njkl\n", "\n\n\nabc", "", "a\nb", "abc\rdef",
     "\nabc\n\ndef\nghi\njkl\n\nmnopq\n\n"].each do |s|
      n = alloc_nsstring(s)
      a = []
      s.each {|i| a << i }
      assert_equal(n.lines, a)
    end
  end
  
  def test_size
    assert_equal(6, 'Foobar'.to_ns.size)
  end
  
  def test_start_with
    s = alloc_nsstring('abc def')
    assert_equal(true, s.start_with?('abc'))
    assert_equal(false, s.start_with?('def'))
  end
  
  def test_upcase
    ['foO bar buz', ''].each do |s|
      n = alloc_nsstring(s)
      assert_equal(s.upcase, n.upcase)
      assert_equal(s.upcase!, n.upcase!)
    end
  end
  
  def test_to_f
    ['3358.123', ''].each do |s|
      n = alloc_nsstring(s)
      assert((s.to_f - n.to_f).abs < 0.01)
    end
  end
  
  def test_to_i
    ['-12345', '42', '3358.123', ''].each do |s|
      n = alloc_nsstring(s)
      assert((s.to_i - n.to_i).abs < 0.01)
    end
  end
  
end
