# Copyright (c) 2006-2008, The RubyCocoa Project.
# Copyright (c) 2001-2006, FUJIMOTO Hisakuni.
# All Rights Reserved.
#
# RubyCocoa is free software, covered under either the Ruby's license or the 
# LGPL. See the COPYRIGHT file for more information.

# Utility methods for String.
class String

  # @!parse
  #     # @deprecated use NKF.guess.
  #     def nsencoding; nil; end

  # @deprecated use obj#to_ns.
  # @return [OSX::NSString]
  def to_nsstring
    warn "#{caller[0]}: to_nsstring is now deprecated and its use is discouraged, please use to_ns instead."
    OSX::NSString.stringWithRubyString(self)
  end

  # @deprecated use obj#to_ns.
  # @return [OSX::NSMutableString]
  def to_nsmutablestring
    warn "#{caller[0]}: to_nsmutablestring is now deprecated and its use is discouraged, please use to_ns instead."
    OSX::NSMutableString.stringWithRubyString(self)
  end

  # Returns Objective-C selector.
  # @return [String]
  def to_sel
    s = self.dup
    s.instance_variable_set(:@__is_sel__, true)
    return s
  end

end

# Property list API.
module OSX
  # Returns property list from input data.
  # @param data [String, OSX::NSString, OSX::NSData]
  # @return [OSX::NSPropertyList]
  def load_plist(data)
    case data
    when String
      if RUBY_VERSION >= '2.0'
        if data.encoding == Encoding::ASCII_8BIT
          nsdata = OSX::NSData.dataWithBytes_length(data, data.bytesize)
        else
          str = data.encode!(Encoding::UTF_8).to_ns
          nsdata = str.dataUsingEncoding(OSX::NSUTF8StringEncoding)
        end
      else
        nsdata = OSX::NSData.dataWithBytes_length(data, data.length)
      end
    when OSX::NSString
      nsdata = data.dataUsingEncoding(OSX::NSUTF8StringEncoding)
    when OSX::NSData
      nsdata = data
    else
      raise ArgumentError, 'argument should be String, OSX::NSString or OSX::NSData'
    end
    obj, error = OSX::NSPropertyListSerialization.objc_send \
      :propertyListFromData, nsdata,
      :mutabilityOption, OSX::NSPropertyListImmutable,
      :format, nil,
      :errorDescription
    raise error.to_s if obj.nil?
    obj.respond_to?(:to_ruby) ? obj.to_ruby : obj
  end
  module_function :load_plist

  # Serialize to property list.
  # @param object [String, OSX::NSString, OSX::NSData]
  # @param format [NSPropertyListFormat]
  # @return [String]
  def object_to_plist(object, format=nil)
    format ||= OSX::NSPropertyListXMLFormat_v1_0
    data, error = OSX::NSPropertyListSerialization.objc_send \
      :dataFromPropertyList, object,
      :format, format,
      :errorDescription
    raise error.to_s if data.nil?
    case format
      when OSX::NSPropertyListXMLFormat_v1_0, 
           OSX::NSPropertyListOpenStepFormat
        OSX::NSString.alloc.initWithData_encoding(data, 
          OSX::NSUTF8StringEncoding).to_s
      else
        data.rubyString
    end
  end
  module_function :object_to_plist
end

[Array, Hash, String, Numeric, TrueClass, FalseClass, Time].each do |k| 
  k.class_eval do
    def to_plist(format=nil)
      OSX.object_to_plist(self, format)
    end
    def to_ns
      OSX.rbobj_to_nsobj(self)
    end
  end
end

# Array additions.
class Array
  # Returns string into packed Pascal string.
  # @return [String]
  def pack_as_pstring
    len = self[0]
    self[1..-1].pack("C#{len}")
  end
end

class String
  # Returns an array unpacked from Pascal string.
  # @return [Array]
  def unpack_as_pstring
    ary = [self.length]
    ary.concat(self.unpack('C*'))
    return ary
  end
end
