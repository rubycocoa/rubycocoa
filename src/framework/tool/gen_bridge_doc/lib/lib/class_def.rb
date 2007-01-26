class CocoaRef::ClassDef
  attr_accessor :description, :name, :type, :method_defs, :constant_defs, :notification_defs, :function_defs, :datatype_defs, :framework
  
  def initialize
    @description       = []
    @name              = ''
    @type              = ''
    @method_defs       = []
    @constant_defs     = []
    @notification_defs = []
    @function_defs     = []
    @datatype_defs     = []
    @framework         = ''
  end
  
  def errors?
    errors_in_methods = false
    @method_defs.each do |m|
      # First call the to_rdoc method, because it might contain errors
      m.to_rdoc(@name)
      if m.log.errors?
        errors_in_methods = true
        break
      end
    end
          
    errors_in_contstants = false
    @constant_defs.each do |c|
      # First call the to_rdoc method, because it might contain errors
      c.to_rdoc
      if c.log.errors?
        errors_in_contstants = true
        break
      end
    end
    
    errors_in_functions = false
    @function_defs.each do |f|
      # First call the to_rdoc method, because it might contain errors
      f.to_rdoc
      if f.log.errors?
        errors_in_functions = true
        break
      end
    end
    
    errors_in_datatypes = false
    @function_defs.each do |d|
      # First call the to_rdoc method, because it might contain errors
      d.to_rdoc
      if d.log.errors?
        errors_in_functions = true
        break
      end
    end
    
    return (errors_in_methods or errors_in_contstants or errors_in_functions or errors_in_datatypes)
  end
  
  def output_filename
    if @type == :class
      return "#{@name}.rb"
    elsif @type == :additions
      return "#{@name}Additions.rb"
    elsif @type == :functions
      return "#{@name}Functions.rb"
    elsif @type == :data_types
      return "#{@name}DataTypes.rb"
    end
  end
  
  def parse_description
    arr = @description.collect {|paragraph| paragraph.rdocify}
    return arr
  end
  def to_s
    @method_defs.each {|m| m.to_s }
  end
  
  def module_name
    "OSX::#{@framework}::"
  end
  
  def to_rdoc
    str = ''
    
    if @type == :additions
      str += "# This module is automatically mixed-in in the #{@name} class.\n"
      str += "#\n"
    end
    if @type == :functions or @type == :data_types
      str += "# This module is automatically mixed-in in the OSX module.\n"
      str += "#\n"
    end
    
    self.parse_description.each do |paragraph|
      str += "# #{paragraph}\n"
      str += "#\n"
    end
    
    if @type == :class
      if @name == 'NSObject'
        str += "class #{module_name}#{@name}\n"
      else
        str += "class #{module_name}#{@name} < #{OSX.const_get(@name).superclass}\n"
      end
    elsif @type == :additions
      str += "module #{module_name}#{@name}Additions\n"
    elsif @type == :functions
      str += "module #{module_name}#{@name}Functions\n"
    elsif @type == :data_types
      str += "module OSX::#{@framework}::DataTypes\n"
    end
    
    @constant_defs.each {|c| str += c.to_rdoc }
    @method_defs.each {|m| str += m.to_rdoc(@name) }
    @function_defs.each {|f| str += f.to_rdoc }
    @datatype_defs.each {|d| str += d.to_rdoc }
    
    unless @notification_defs.empty?
      str += "  # ------------------------\n"
      str += "  # :section: Notifications\n"
      str += "  #\n"
      str += "  # This section contains the notifications posted by the #{@name} class\n"
      str += "  #\n"
      str += "  # ------------------------\n"
      @notification_defs.each {|n| str += n.to_rdoc }
    end
    
    str += "end\n"
    return str
  end
end
