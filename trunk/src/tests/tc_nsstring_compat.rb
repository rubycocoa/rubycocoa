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

  def test_times
    s = OSX::NSMutableString.stringWithString('foo')
    s = s * 5
    assert_equal('foo'*5, s)
  end
  
  def test_plus
    s = OSX::NSMutableString.stringWithString('foo')
    s = s + 'bar'
    assert_equal('foobar', s)
  end
  
  def test_concat
    with_kcode('utf-8') do
      s = OSX::NSMutableString.stringWithString('foo')
      s << 'abc'
      assert_equal('fooabc', s)
      s << 123
      assert_equal('fooabc{', s)
      s.concat 0x3053
      assert_equal('fooabc{こ', s)
    end
  end
  
  def test_capitalize
    s = OSX::NSMutableString.stringWithString('foo bar')
    assert_equal('Foo Bar', s.capitalize)
    assert_equal('Foo Bar', s.capitalize!)
  end
  
  def test_clear
    s = OSX::NSMutableString.stringWithString('Foobar')
    assert_equal(s, s.clear)
    assert_equal('', s)
    assert_equal(0, s.length)
  end
  
  def test_downcase
    s = OSX::NSMutableString.stringWithString('AbC dEF')
    assert_equal('abc def', s.downcase)
    assert_equal('abc def', s.downcase!)
  end
  
  def test_empty
    s = OSX::NSMutableString.stringWithString('Foobar')
    assert_equal(false, s.empty?)
    assert_equal(true, s.clear.empty?)
  end
  
  def test_end_with
    s = OSX::NSMutableString.stringWithString('abc def')
    assert_equal(false, s.end_with?('abc'))
    assert_equal(true, s.end_with?('def'))
  end
  
  def test_include
    with_kcode('utf-8') do
      s = OSX::NSMutableString.stringWithString('abc def')
      assert_equal(true, s.include?('c d'))
      assert_equal(true, s.include?(0x62))
      assert_equal(false, s.include?('C D'))
      assert_equal(false, s.include?(0x41))
      s = OSX::NSMutableString.stringWithString('abc かきくけこ')
      assert_equal(true, s.include?('かき'))
      assert_equal(true, s.include?(0x3053))
      assert_equal(false, s.include?('は'))
      assert_equal(false, s.include?(0x3060))
    end
  end
  
  def test_size
    assert_equal(6, 'Foobar'.to_ns.size)
  end
  
  def test_start_with
    s = OSX::NSMutableString.stringWithString('abc def')
    assert_equal(true, s.start_with?('abc'))
    assert_equal(false, s.start_with?('def'))
  end
  
  def test_upcase
    s = OSX::NSMutableString.stringWithString('AbC dEF')
    assert_equal('ABC DEF', s.upcase)
    assert_equal('ABC DEF', s.upcase!)
  end
  
  def test_to_f
    s = OSX::NSMutableString.stringWithString('3358.123')
    assert((s.to_f - 3358.123).abs < 0.01)
  end
  
  def test_to_i
    s = OSX::NSMutableString.stringWithString('3358.123')
    assert_equal(3358, s.to_i)
  end
  
end
