require 'osx/cocoa'
require 'test/unit'

class MyClass < OSX::NSObject
 attr_accessor :bool
 def control_textView_doCommandBySelector(control, textView, sel)
   return @bool
 end
end

class TCBool < Test::Unit::TestCase
 def test_informal_protocol
   rcv = MyClass.alloc.init
   [[false, false], [true, true], [1, true], [0, true],
    [42, true], [nil, false]].each do |val, expected|
    rcv.bool = val
    obj = rcv.objc_send(
      :control, nil, :textView, nil, :doCommandBySelector, nil)
    assert_equal(expected, obj, "testing #{val} <=> #{expected}")
   end
 end
end
