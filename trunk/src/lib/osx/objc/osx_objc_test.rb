module OSX

  class ObjcID
    attr_reader :__ocid__
    def initialize(val)
      @__ocid__ = val
    end
  end

  module OCObjWrapper

    def ocm_send(mname, *args)
      puts "#{__ocid__}.#{mname}(#{args})"
    end

    def __ocid__
      if self.is_a? ObjcID then
	super
      else
	@__objcid__.__ocid__
      end
    end

    def method_missing(mname, *args)
      ocm_send(mname, *args)
    end

  end

  class OCObject < ObjcID
    include OCObjWrapper

    def initialize(val)
      super(val)
    end
    
  end

  def OSX.objc_class_new(val)
    klass = Class.new(OSX::OCObject)
    klass.instance_eval %{
      extend OCObjWrapper
      @__objcid__ = ObjcID.new(val)
      def inherited(k)
	p k
      end
    }
    klass
  end

  NSObject = objc_class_new(1964)

end

class MyObj < OSX::NSObject

  @__objcid__ = OSX::ObjcID.new(328)

end
