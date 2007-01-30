class CocoaRef::ConstantDef < CocoaRef::MethodDef
  attr_accessor :value
  
  def initialize
    super
    @value = ''
  end

  def to_rdoc
    str  = ''
    unless @description.nil? or @description.empty?
      str += "  # Description:: #{@description.rdocify}\n"
    else
      puts "[WARNING] A `nil` or empty object was encountered as the description for constant #{@name}" if $COCOA_REF_DEBUG
    end
  
    unless @availability.nil? or @availability.empty?
      str += "  # Availability:: #{@availability.rdocify}\n"
    else
      puts "[WARNING] A `nil` or empty object was encountered as the availability for constant #{@name}" if $COCOA_REF_DEBUG
    end
  
    unless @value.nil? or @value.empty?
      if @value == 'OSX::NSString'
        str += "  #{@name} = '#{@name}'\n\n"
      else
        str += "  #{@name} = #{@value}\n\n"
      end
    else
      puts "[WARNING] A `nil` or empty object, or just a Notification, was encountered as the value for constant: #{@name}" if $COCOA_REF_DEBUG
      str += "  #{@name} = '#{@name}'\n\n"
    end
    return str
  end
end
