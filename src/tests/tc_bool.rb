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


class RubyDataClass < OSX::NSObject
  def setNil; @v = nil; end
  def setFalse; @v = false; end
  def setTrue; @v = true; end
  def setZero; @v = 0; end
  def setOne; @v = 1; end
  def set42; @v = 42; end
  
  def testBool; @v; end
  def testChar; @v; end
  def testInt; @v; end
end

class AnnotatedRubyDataClass < RubyDataClass
  objc_method :testBool, 'B@:'
  objc_method :testChar, 'c@:'
  objc_method :testInt, 'i@:'
end

class TC_BoolTypeConversion < Test::Unit::TestCase
  def test_bool_type_conversions
    objcdata = OSX::ObjcDataClass.alloc.init
    [[:boolNo, 0], [:boolYes, 1], [:cppBoolFalse, false], [:cppBoolTrue, true],
     [:intZero, 0], [:intOne, 1], [:int42, 42], [:intMinusOne, -1], [:biguint, 2147483650],
     [:charZero, 0], [:charOne, 1]].each do |method, expected|
      res = objcdata.__send__(method)
      assert_equal(expected, res, "testing objc to ruby convertion: #{method} <=> #{expected}")
    end
    
    test = OSX::ObjcConvertionTest.alloc.init
    #rubydata = RubyDataClass.alloc.init
    #test.startTests_withMessage(rubydata, '(raw)')
    rubydata = AnnotatedRubyDataClass.alloc.init
    test.startTests_withMessage(rubydata, '(with objc_method)')
    
    OSX.load_bridge_support_file('ObjcTest.bridgesupport')    
    
    [[:boolNo, false], [:boolYes, true], [:cppBoolFalse, false], [:cppBoolTrue, true],
     [:intZero, 0], [:intOne, 1], [:int42, 42], [:intMinusOne, -1], [:biguint, 2147483650],
     [:charZero, 0], [:charOne, 1]].each do |method, expected|
      res = objcdata.__send__(method)
      assert_equal(expected, res, "testing objc to ruby convertion (informal protocol): #{method} <=> #{expected}")
    end
    
    rubydata = RubyDataClass.alloc.init
    test.startTests_withMessage(rubydata, '(informal protocol)')
  end
end
