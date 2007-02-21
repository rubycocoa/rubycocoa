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
    
    # Make sure the first letter is upcased.
    name = @name[0...1].upcase << @name[1..-1]
    str += "  #{name} = nil\n\n"
    return str
  end
end
