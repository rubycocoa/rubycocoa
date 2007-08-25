require 'test/unit'
require 'osx/cocoa'

class TC_NSDictionary < Test::Unit::TestCase
  include OSX
  
  def test_equal
    dic = NSMutableDictionary.alloc.init
    dic[1] = '111'
    dic[2] = '222'
    h= {}
    h[NSNumber.numberWithInt(1)] = NSString.stringWithString '111'
    h[NSNumber.numberWithInt(2)] = NSString.stringWithString '222'
    assert(dic == h)
    assert(dic == dic)
  end
  
  def test_size
    dic = NSMutableDictionary.alloc.init
    dic[1] = '111'
    dic[2] = '222'
    assert_equal(2, dic.size)
    assert_equal(2, dic.length)
  end
  
  def test_clear
    dic = NSMutableDictionary.alloc.init
    dic[1] = '111'
    dic[2] = '222'
    dic.clear
    assert_equal(0, dic.length)
  end
  
  def test_merge
    dic = NSMutableDictionary.alloc.init
    dic[1] = '111'
    dic[2] = '222'
    h= {}
    h[3] = '333'
    h[4] = '444'
    r = dic.merge(h)
    assert_equal(4, r.size)
    assert_equal(2, dic.size)
    dic.merge!(h)
    assert_equal(4, r.size)
    assert(dic[2] == '222')
  end
  
  def test_ref
    dic = NSMutableDictionary.alloc.init
    dic[1] = '111'
    dic[2] = '222'
    assert(dic[1] == '111')
    assert(dic[2] == '222')
  end
  
  def test_replace
    dic = NSMutableDictionary.alloc.init
    dic[1] = '111'
    dic[2] = '222'
    h = { 3 => '333', 4 => '444', 'str' => 'string' }
    dic.replace(h)
    assert_equal(3, dic.size)
    assert(dic['str'] == 'string')
  end
end
