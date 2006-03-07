#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
#
#  This program is free software.
#  You can distribute/modify this program under the terms of
#  the GNU Lesser General Public License version 2.
#

require 'test/unit'
require 'osx/cocoa'

class TC_Attachments < Test::Unit::TestCase
  include OSX

  def setup
    @a = NSMutableArray.arrayWithArray(["a","b","c"])
    @d = NSMutableDictionary.dictionaryWithDictionary({"a"=>1,"b"=>2})
  end

  def test_array_kind_of
    assert_kind_of RCArrayAttachment, @a
  end
  
  def test_dictionary_kind_of
    assert_kind_of RCDictionaryAttachment, @d
  end
  
  def test_array_size
    assert_equal 3, @a.size
  end
  
  def test_dictionary_size
    assert_equal 2, @d.size
  end

  def test_array_index
    assert_equal "a", @a[0].to_s
    assert_equal "c", @a[-1].to_s
  end
  
  def test_dictionary_index
    assert_nil @d["x"]
    assert_equal 2, @d["b"].to_i
  end
  
  def test_array_push
    @a.push "d"
    assert_equal 4, @a.size
    assert_equal "d", @a[3].to_s
  end
  
  def test_array_assign
    assert_equal "BB", (@a[1] = "BB")
    assert_equal "BB", @a[1].to_s
  end
  
  def test_array_enum
    assert_equal ["a","b","c"], @a.map { |e| e.to_s }
  end
  
  def test_dictionary_keys
    assert_kind_of Array, @d.keys
    assert_equal ["a", "b"], @d.keys.map { |e| e.to_s }.sort
  end
  
  def test_dictionary_values
    assert_kind_of Array, @d.values
    assert_equal [1,2], @d.values.map { |e| e.to_i }.sort
  end
  
  def test_dictionary_assign
    assert_equal 3, (@d["c"] = 3)
    assert_equal 3, @d["c"].to_i
  end
  
  def test_data
    data = NSData.dataWithBytes_length("somedata",8)
    assert_equal "somedata", data.rubyString
  end

end
