#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni
#

class String

  def nsencoding
    OSX::NSString.guess_nsencoding(self)
  end

  def to_nsstring
    OSX::NSString.stringWithRubyString(self)
  end

  def to_nsmutablestring
    OSX::NSMutableString.stringWithRubyString(self)
  end

end

module OSX
  def load_plist(data)
    nsdata = OSX::NSData.alloc.initWithBytes_length(data.to_s)
    obj, error = OSX::NSPropertyListSerialization.objc_send \
      :propertyListFromData, nsdata,
      :mutabilityOption, OSX::NSPropertyListImmutable,
      :format, nil,
      :errorDescription
    raise error.to_s if obj.nil?
    return obj
  end
  module_function :load_plist

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
        data.bytes.bytestr(data.length)
    end
  end
  module_function :object_to_plist
end

[Array, Hash, String, Numeric, TrueClass, FalseClass, Time].each do |k| 
  k.class_eval do
    def to_plist(format=nil)
      OSX.object_to_plist(self, format)
    end
  end
end
