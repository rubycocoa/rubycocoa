# coding: euc-jp
#  $Id$
#
#  Copyright (c) 2005 kimura wataru
#  Copyright (c) 2001-2003 FUJIMOTO Hisakuni
#

require 'test/unit'
require 'osx/cocoa'
require 'kconv'

class TC_NSString < Test::Unit::TestCase
  include OSX

  def setup
    @teststr = "Hello World".freeze
    @eucstr = "オブジェクト指向スクリプト言語Ruby".toeuc.freeze
    if RUBY_VERSION < '2.0'
      $KCODE = 'NONE'
    end
  end

  def teardown
    if RUBY_VERSION < '2.0'
      $KCODE = 'NONE'
    end
  end

  def test_s_alloc
    obj = NSString.alloc.init
    assert( obj.isKindOfClass?(NSString) )
  end

  def test_s_stringWithString
    obj = NSString.stringWithString(@teststr)
    assert_equal(@teststr, obj.to_s)
  end

  def test_initWithString
    obj = NSString.alloc.initWithString(@teststr)
    assert_equal(@teststr, obj.to_s)
  end

  def test_dataUsingEncoding_euc
    nsstr = NSString.stringWithCString_encoding(@eucstr, NSJapaneseEUCStringEncoding)
    data = nsstr.dataUsingEncoding( NSJapaneseEUCStringEncoding )
    bytes = "." * data.length
    data.getBytes_length( bytes )
    assert_equal( @eucstr, bytes )
  end

  def test_dataUsingEncoding_sjis
    nsstr = NSString.stringWithCString_encoding(@eucstr, NSJapaneseEUCStringEncoding)
    data = nsstr.dataUsingEncoding( NSShiftJISStringEncoding )
    bytes = "." * data.length
    data.getBytes_length( bytes )
    sjisstr = @eucstr.tosjis
    if RUBY_VERSION >= '2.0'
      assert_equal( sjisstr.bytesize, data.length )
      bytes.force_encoding("Shift_JIS")
    end
    assert_equal( sjisstr, bytes )
  end

  def test_dataUsingEncoding_jis
    nsstr = NSString.stringWithCString_encoding(@eucstr, NSJapaneseEUCStringEncoding)
    data = nsstr.dataUsingEncoding( NSISO2022JPStringEncoding )
    bytes = "." * data.length
    data.getBytes_length( bytes )
    jisstr = @eucstr.tojis
    if RUBY_VERSION >= '2.0'
      assert_equal( jisstr.bytesize, data.length )
      bytes.force_encoding("ISO-2022-JP")
    end
    assert_equal( jisstr, bytes )
  end
  
  def test_copy
    assert_nothing_raised {
      a = NSString.stringWithString('abc')
      b = a.dup
      b += 'def'
      b = a.clone
      b += 'def'
    }
  end

  def test_hash
    str1 = NSString.stringWithString('abc')
    str2 = NSString.stringWithString('abc')
    assert(str1.hash == str2.hash)
  end
  
  def test_to_ns
    assert_equal(OSX::NSString.stringWithString('abc'), 'abc'.to_ns)
    assert_equal(nil, "\270\236\010\210\245".to_ns)
  end
end
