# Created by Eloy Duran
# Copyright (c) 2007 Eloy Duran, SuperAlloy

require 'rubygems'
require 'hpricot'

class String
  
  def to_rb_def
    self.strip_tags.clean_up.gsub(/\(\w+\)/, '').strip.split(':').join('_')
  end
  
  def unescape_chars
    self.gsub(/&lt;/, "<")
  end
  
  def strip_tags
    self.gsub(/<\/?[^>]*>/, "")
  end
  
  def clean_objc
    self.clean_special_chars.strip_tags.unescape_chars.strip_tags
  end
  
  def clean_special_chars
    self.gsub(/ /, ' ')
  end
  
  def guess_rb_type
    case self
    when 'NSString'
      return 'str'
    when 'NSArray'
      return 'array'
    else
      return self
    end
  end
  
  def rdocify
    self.convert_types.convert_tags.clean_up
  end
  
  def convert_types
    str = self
    
    # Replace the objc BOOL style with the ruby style
    str = str.gsub(/YES/, 'true')
    str = str.gsub(/NO/, 'false')
    
    return str
  end
  
  def convert_tags
    str = self
    
    # Convert code elements
    str = str.gsub(/<code>/, 'TWOPEN').gsub(/<\/code>/, 'TWCLOSE')
    
    # Convert italic style from the parameters section
    str = str.gsub(/<dt><i>/, '_')
    str = str.gsub(/<\/i><\/dt>/, '_ ')
    
    # Convert italic style
    str = str.gsub(/<i>/, '_')
    return str
  end
  
  def clean_up
    str = self
    str = str.gsub(/\n/, ' ')
    str = str.strip_tags
    str = str.gsub(/TWOPEN/, '<tt>').gsub(/TWCLOSE/, '</tt>')
    str = str.gsub(/&#8211;|&#xA0;/, '')
    str = str.gsub(/“/, '<em>').gsub(/”/, '</em>')
    str = str.gsub(/–/, '-')
    str = str.gsub(/’/, "'")
    str = str.strip
    return str
  end
end

module Hpricot
  class Elem
    def fits_the_description?(tag, text)
      self.name == tag and self.inner_html.include?(text)
    end
    def spaceabove?
      self.get_attribute('class') == 'spaceabove'
    end
    def spaceabovemethod?
      self.get_attribute('class') == 'spaceabovemethod'
    end
    def spacer?
      self.spaceabove? or self.spaceabovemethod?
    end
  end
end

module CocoaRef
  class Log
    def initialize
      @errors = []
    end
    
    def add(str)
      @errors.push(str)
      if $COCOA_REF_DEBUG
        puts str
      end
    end
    
    def errors?
      not @errors.empty?
    end
  end
  
  class HpricotProxy
    attr_accessor :elements
    attr_reader :log
    
    def initialize(file)
      @log = CocoaRef::Log.new
      doc = open(file) {|f| Hpricot f, :fixup_tags => true }
      @elements = (doc/"//body/*")
    end
    
    def start_of_method_def?(index)
      @elements[index].name == 'h3' and @elements[index].get_attribute('class') == 'tight' and @elements[index + 1].spacer?
    end
        
    def get_method_def(index, type)
      method_def = CocoaRef::MethodDef.new
      method_def.type         = type
      method_def.name         = self.get_name_for_method(index)
      method_def.description,  new_index = self.get_description_for_method(index)
      method_def.definition,   new_index = self.get_definition_for_method(new_index)
      method_def.parameters,   new_index = self.get_parameters_for_method(new_index)
      method_def.return_value, new_index = self.get_return_value_for_method(new_index)
      method_def.discussion,   new_index = self.get_discussion_for_method(new_index)
      method_def.availability, new_index = self.get_availability_for_method(new_index)
      method_def.see_also,     new_index = self.get_see_also_for_method(new_index)
      return method_def
    end
    
    def get_name_for_method(index)
      @elements[index].inner_html
    end
    
    def method_def_has_description?(index)
      @elements[index + 1].spaceabove?
    end
    
    def get_description_for_method(index)
      if self.method_def_has_description?(index)
        elm_index = find_next_tag('p', 'spaceabove', index)
        elm = @elements[elm_index]
        return [elm.inner_html, elm_index + 1]
      else
        return '', index
      end
    end
    
    def get_definition_for_method(index)
      elm_index = find_next_tag('p', 'spaceabovemethod', index)
      unless elm_index.nil?
        elm = @elements[elm_index]
        return [elm.inner_html, elm_index + 1]
      else
        return ['', index]
      end
    end
    
    def get_h5_section_for_method(index, search)
      elm_index = find_next_tag('h5', 'tight', index)
      unless elm_index.nil?
        elm = @elements[elm_index]
        if elm.inner_html == search
          return [@elements[index + 1].inner_html, elm_index + 2]
        end
      end
      return ['', index]
    end
    
    # When passed the index of a paragraph,
    # this method will try to retrieve the paragraph and any subsequent paragraphs.
    # It also returns the index of the last found paragraph.
    def get_the_text(index)
      str = ''
      arr = []
      while @elements[index].name == 'p'
        arr.push @elements[index].inner_html
        #str += @elements[index].inner_html
        index = index.next
      end
      arr.delete_if {|paragraph| paragraph.strip.empty? }
      return [arr, index]
    end
    
    def get_parameters_for_method(index)
      get_h5_section_for_method(index, 'Parameters')
    end
    
    def get_return_value_for_method(index)
      get_h5_section_for_method(index, 'Return Value')
    end
    
    def get_discussion_for_method(index)
      get_h5_section_for_method(index, 'Discussion')
    end
    
    def get_availability_for_method(index)
      get_h5_section_for_method(index, 'Availability')
    end
    
    def get_see_also_for_method(index)
      #get_h5_section_for_method(index, 'See Also')
      elm_index = find_next_tag('h5', 'tight', index)
      unless elm_index.nil?
        elm = @elements[elm_index]
        if elm.inner_html == 'See Also'
          children = @elements[elm_index + 1].children
          see_also_items = []
          children.each do |c|
            see_also_items.push(c.inner_html) if c.is_a?(Hpricot::Elem)
          end
          return [see_also_items, elm_index + 2]
        end
      end
      return [[], index]
    end
    
    def get_methodlike_constant_def(index)
      constant_def = CocoaRef::ConstantDef.new
      constant_def.name         = self.get_name_for_method(index)
      constant_def.description,  new_index = self.get_description_for_method(index)
      constant_def.discussion,   new_index = self.get_discussion_for_method(new_index)
      constant_def.availability, new_index = self.get_availability_for_method(new_index)
      return constant_def
    end
    
    def get_constant_defs(index)
      constants, new_elm_index = self.get_names_and_values_for_constants(index)      
      constants, new_elm_index = self.get_descriptions_and_availability_for_constants(new_elm_index, constants)
      
      unless constants.nil?
        constant_defs = []
        constants.each do |c|
          constant_def = CocoaRef::ConstantDef.new
          constant_def.name          = c[:name]
          constant_def.value         = c[:value]
          constant_def.description   = c[:description]
          constant_def.availability  = c[:availability]
          constant_defs.push constant_def
        end
      else
        warning_str  = "[WARNING] A `nil` value was detected in the constants section...\n"
        warning_str += "          It might be a bug, please cross check the original reference with the output.\n"
        puts warning_str if $COCOA_REF_DEBUG
      end
      
      return constant_defs
    end
    
    def get_names_and_values_for_constants(index)
      elm_index = find_next_tag('pre', '', index)
      children = @elements[elm_index].children
      names_and_values = []
      elm_index = elm_index.next
      children_index = 0
      children.each do |elm|
        # 16-01-2007: Added a extra comparison to exclude NSString links.
        if elm.is_a?(Hpricot::Elem) and elm.name == 'a' and not elm.inner_html == 'NSString'
          names_and_values.push({:name => elm.inner_html, :value => ''})
          
          # This is a check for constant names that are not the children of a <a> tag
        elsif elm.is_a?(Hpricot::Comment) and elm.to_s == '<!--a-->'
          names_and_values.push({:name => children[children_index + 1].to_s, :value => ''})
          
        elsif elm.is_a?(Hpricot::Text) and elm.to_s.include?('=')
          parsed_value = elm.to_s.gsub(/&lt;/, '<').scan(/([\s=]+)([\(\-\w\d\)<>\s]+)/).flatten
          unless names_and_values.last.nil? or names_and_values.last.empty?
            names_and_values.last[:value] = parsed_value[1]
          else
            error_str  = "[WARNING] A value was found without a matching name in the constants section...\n"
            error_str += "          It might be a bug, please cross check the original reference with the output.\n"
            error_str += "          Value: #{parsed_value[1]}\n"
            @log.add(error_str)
          end
        end
        children_index = children_index.next
        elm_index = elm_index.next
      end
      return [names_and_values, index + 1]
    end
    
    def get_descriptions_and_availability_for_constants(index, constants)
      # For some reason the dl tag where these constants
      # are the children of comes back empty...
      # So that's why we have this lengthy method.
      
      last_good_index = index
      
      # First let's get an array of the constant names of this section,
      # this is what we check against to see if the description belongs to a constant.
      names = constants.collect {|c| c[:name]}
      
      # Find the first constant description for this section
      elm_index = find_next_tag('dt', '', index)
      return nil if elm_index.nil?
      elm = @elements[elm_index]
      
      # Loop until we come across a constant which doesn't belong to this section.
      while names.include? elm.inner_html.strip_tags
        # Get a reference to the constant that we are processing
        constant_index = names.index(elm.inner_html.strip_tags)
        
        # Find the description that belongs to the constant
        elm_index = find_next_tag('dd', '', elm_index)
        elm = @elements[elm_index]
        
        # Add the description to it's constant
        constants[constant_index][:description] = elm.children.first.inner_html
        # Add the availability to it's constant
        constants[constant_index][:availability] = elm.children.last.inner_html
        
        # Get a reference to the last known good elm_index
        last_good_index = elm_index
        
        # Find the next start of an constant section
        elm_index = find_next_tag('dt', '', elm_index)
        break if elm_index.nil?
        elm = @elements[elm_index]
      end
      return [constants, last_good_index + 1]
    end
    
    def get_notification_def(index)
      notification_def = CocoaRef::NotificationDef.new
      notification_def.name         = self.get_name_for_method(index)
      notification_def.description,  new_index = self.get_description_for_method(index)
      notification_def.definition,   new_index = self.get_definition_for_method(new_index)
      notification_def.parameters,   new_index = self.get_parameters_for_method(new_index)
      notification_def.return_value, new_index = self.get_return_value_for_method(new_index)
      notification_def.discussion,   new_index = self.get_discussion_for_method(new_index)
      notification_def.availability, new_index = self.get_availability_for_method(new_index)
      notification_def.see_also,     new_index = self.get_see_also_for_method(new_index)
      return notification_def
    end
    
    def find_next_tag(tag, css_class, start_from = 0)
      found = false
      index = start_from
      until found
        break if @elements[index].nil?
        if @elements[index].name == tag
          unless css_class.empty?
            if @elements[index].get_attribute("class") == css_class
              found = true
            else
              index = index.next
            end
          else
            found = true
          end
        else
          index = index.next
        end
      end
      if found
        return index
      else
        return nil
      end
    end
    
  end
  
  class ClassDef
    attr_accessor :description, :name, :type, :method_defs, :constant_defs, :notification_defs
    
    def initialize
      @description, @name, @type, @method_defs, @constant_defs, @notification_defs = [], '', '', [], [], []
    end
    
    def errors?
      errors_in_methods = false
      @method_defs.each do |m|
        # First call the to_rdoc method, because it might contain errors
        m.to_rdoc
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
      
      return (errors_in_methods or errors_in_contstants)
    end
    
    def output_filename
      if @type == :class
        return "#{@name}.rb"
      elsif @type == :additions
        return "#{@name}Additions.rb"
      end
    end
    
    def parse_description
      arr = @description.collect {|paragraph| paragraph.rdocify}
      return arr
    end
    def to_s
      @method_defs.each {|m| m.to_s }
    end
    def to_rdoc
      str = ''
      
      if @type == :additions
        str += "# This module is automatically mixed-in in the #{@name} class.\n"
        str += "#\n"
      end
      
      self.parse_description.each do |paragraph|
        str += "# #{paragraph}\n"
        str += "#\n"
      end
      
      if @type == :class
        str += "class OSX::#{@name}\n"
      elsif @type == :additions
        str += "module OSX::#{@name}Additions\n"
      end
      
      @constant_defs.each {|c| str += c.to_rdoc }
      @method_defs.each {|m| str += m.to_rdoc }
      
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

  class MethodDef
    attr_accessor :type, :name, :description, :definition, :parameters, :return_value, :discussion, :availability, :see_also
    attr_reader :log
    
    def initialize
      @type, @name, @description, @definition, @parameters, @return_value, @discussion, @availability, @see_also = '', '', '', '', '', '', '', '', []
      @log = CocoaRef::Log.new
    end
    
    def to_s
      str  = "METHOD:\n#{@name}\n"
      str += "TYPE:\n#{@type.to_s}\n"
      str += "DEFINITION:\n#{self.definition.strip_tags}\n"
      str += "DESCRIPTION:\n#{@description.strip_tags}\n"
      str += "PARAMETERS:\n#{@parameters.strip_tags}\n"
      str += "RETURN VALUE:\n#{@return_value.strip_tags}\n"
      str += "DISCUSSION:\n#{@discussion.strip_tags}\n"
      str += "AVAILABILITY:\n#{@availability.strip_tags}\n\n"
      str += "SEE ALSO:\n#{@see_also.strip_tags}\n\n"
      return str
    end
  
    def to_rdoc
      str  = ''
      str += "  # Parameters::   #{@parameters.rdocify}\n"   unless @parameters.empty?
      str += "  # Description::  #{@description.rdocify}\n"  unless @description.empty?
      str += "  # Discussion::   #{@discussion.rdocify}\n"   unless @discussion.empty?
      str += "  # Return value:: #{@return_value.rdocify}\n" unless @return_value.empty?
      str += "  # Availability:: #{@availability.rdocify}\n" unless @availability.empty?
      unless @see_also.empty?
        str += "  # See also::     "
        @see_also.each do |s|
          str += "<tt>#{s.to_rb_def}</tt> "
        end
        str += "\n"
      end
      str += "  def #{'self.' if @type == :class_method}#{self.to_rb_def}\n"
      str += "    # #{self.definition.gsub(/\n/, ' ').strip_tags.clean_special_chars}\n"
      str += "    #\n"
    
      # objc_send_style = self.to_objc_send
      # p objc_send_style
      # unless objc_send_style.nil?
      #   objc_send_style.each do |line|
      #     str += "    # #{line}\n"
      #   end
      # end
    
      str += "  end\n\n"
    
      return str
    end
  
    def to_objc_send
      method_def_parts = self.parse
      return nil if method_def_parts.nil?
    
      objc_send_style = []
      index = 0
      method_def_parts.each do |m|
        if index.zero?
          objc_send_style.push "objc_send(:#{m[:name][index]}, #{m[:arg][index]},"
        else
          objc_send_style.push "          :#{m[:name][index]}, #{m[:arg][index]},"
        end
      end
      return objc_send_style
    end
    
    # This method checks if a override method (var method) exists.
    # If so it calls it with the optional args array.
    # If it doesn't exist it returns the default alt_result.
    def override_result(alt_result, method, args = [])
      if self.respond_to? method
        if args.empty?
          override_result = self.send(method)
        else
          override_result = self.send(method, *args)
        end
        return override_result unless override_result.nil?
      end
      return alt_result
    end
    
    def definition
      self.override_result(@definition, :new_definition)
    end
    
    def regexp_start
      self.override_result("([-+\\s]+\\()([\\w\\s]+)([\\s\\*\\)]+)", :new_regexp_start)
    end
    def regexp_repeater
      self.override_result("(\\w+)(:\\()([\\w\\s]+)([\\(\\w,\\s\\*\\)\\[\\d\\]]+\\)\\)|[\\s\\*\\)\\[\\d\\]]+)(\\w+)", :new_regexp_repeater)
    end
    
    def regexp_result_name(res, part)
      self.override_result(res[(part * 6) + 3], :new_regexp_result_name, [res, part])
    end
    def regexp_result_type(res, part)
      self.override_result(res[(part * 6) + 5], :new_regexp_result_type, [res, part])
    end
    def regexp_result_arg(res, part)
      self.override_result(res[(part * 6) + 7], :new_regexp_result_arg, [res, part])
    end
    
    def parse
      parsed_method_name = @name.split(':')
    
      regexp = regexp_start
      method_def_parts = []
      parsed_method_name.length.times do
        method_def_parts.push regexp_repeater
      end
      regexp += method_def_parts.join("(\\s+)")
      #puts regexp

      parsed_method_def = self.definition.clean_objc.scan(Regexp.new(regexp)).flatten
      #p parsed_method_def

      method_def_parts = []
      parsed_method_name.length.times do |i|
        method_def_part = {}
        md_name = regexp_result_name(parsed_method_def, i)
        method_def_part[:name] = md_name.strip unless md_name.nil?
        
        md_type = regexp_result_type(parsed_method_def, i)
        method_def_part[:type] = md_type.strip unless md_type.nil?
        
        md_arg = regexp_result_arg(parsed_method_def, i)
        method_def_part[:arg]  = md_arg.strip unless md_arg.nil?
        method_def_parts.push(method_def_part)
      end
      #p method_def_parts
      return method_def_parts
    end
    
    def to_rb_def
      #puts @definition.clean_objc
    
      parsed_method_name = @name.split(':')
      #p parsed_method_name
    
      if self.definition.strip_tags.include?(':') and not self.definition.strip_tags[-2...-1] == ':'
        method_def_parts = self.parse
        str = "#{method_def_parts.collect {|m| m[:name]}.join('_')}(#{method_def_parts.collect {|m| m[:arg] }.join(', ')})"
      else
        str = "#{parsed_method_name.join('_')}"
      end
    
      if str =~ /^[_(]+/
        error_str  = "[WARNING] A empty string was returned as the method definition for:\n"
        error_str += "          #{@name}\n"
        @log.add(error_str)
        return 'an_error_occurred_while_parsing_method_def!'
      else
        return str
      end
    end
  end

  class ConstantDef < MethodDef
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
        str += "  # Description:: No description was available/found.\n"
      end
    
      unless @availability.nil? or @availability.empty?
        str += "  # Availability:: #{@availability.rdocify}\n"
      else
        puts "[WARNING] A `nil` or empty object was encountered as the availability for constant #{@name}" if $COCOA_REF_DEBUG
        str += "  # Availability:: No availability was available/found.\n"
      end
    
      unless @value.nil? or @value.empty?
        str += "  #{@name} = #{@value}\n\n"
      else
        puts "[WARNING] A `nil` or empty object, or just a Notification, was encountered as the value for constant: #{@name}" if $COCOA_REF_DEBUG
        str += "  #{@name} = '#{@name}'\n\n"
      end
      return str
    end
  end

  class NotificationDef < MethodDef
    def to_rdoc
      str  = "\n"
      unless @description.nil? or @description.empty?
        str += "  # Description:: #{@description.rdocify}\n"
      else
        puts "[WARNING] A `nil` or empty object was encountered as the description for notification #{@name}" if $COCOA_REF_DEBUG
        str += "  # Description:: No description was available/found.\n"
      end
    
      unless @availability.nil? or @availability.empty?
        str += "  # Availability:: #{@availability.rdocify}\n"
      else
        puts "[WARNING] A `nil` or empty object was encountered as the availability for notification #{@name}" if $COCOA_REF_DEBUG
        str += "  # Availability:: No availability was available/found.\n"
      end
    
      str += "  #{@name} = ''\n"
      return str
    end
  end
  
  class Parser
    attr_reader :class_def
    
    def initialize(file, override_dir = '')
      @override_dir = override_dir
      @log = CocoaRef::Log.new
      @hpricot = CocoaRef::HpricotProxy.new(file)
      @class_def = parse_reference(file)
      
      # Check if there is a overrides file in the override_dir for the given class
      include_file = File.join(File.dirname(File.expand_path(__FILE__)), @override_dir, @class_def.output_filename)      
      if File.exist?(include_file)
        # If it exists, require it and extend the methods to use the overrides
        require include_file
        @class_def.method_defs.each do |m|
          m.instance_eval "self.send :extend, #{@class_def.name}"
        end
      end
    end
    
    def errors?
      @log.errors? or @hpricot.log.errors? or @class_def.errors?
    end
    
    def parse_reference(file)
      class_def = ClassDef.new
      busy_with = ''
      index = 0
      @hpricot.elements.each do |element|
        if element.fits_the_description?('h1', 'Class Reference') or element.fits_the_description?('h1', 'Class Objective-C Reference')
          class_def.type = :class
          class_def.name = element.inner_html.strip_tags.split(' ').first
        elsif element.fits_the_description?('h1', 'Additions Reference')
          class_def.type = :additions
          class_def.name = element.inner_html.strip_tags.split(' ').first
        elsif element.fits_the_description?('h1', 'Deprecation Reference')
          class_def.type = :class
          class_def.name = element.inner_html.strip_tags.split(' ').first
        end
        if element.fits_the_description?('h2', 'Class Description')
          class_def.description = @hpricot.get_the_text(index + 1).first
        end

        if element.fits_the_description?('h2', 'Class Methods')
          busy_with = 'Class Methods'
        end
        if busy_with == 'Class Methods' and @hpricot.start_of_method_def?(index)
          class_def.method_defs.push @hpricot.get_method_def(index, :class_method)
        end
        
        if element.fits_the_description?('h2', 'Instance Methods')
          busy_with = 'Instance Methods'
        end
        if busy_with == 'Instance Methods' and @hpricot.start_of_method_def?(index)
          class_def.method_defs.push @hpricot.get_method_def(index, :instance_method)
        end

        if element.fits_the_description?('h2', 'Notifications')
          busy_with = 'Notifications'
        end
        if busy_with == 'Notifications' and @hpricot.start_of_method_def?(index)
          class_def.notification_defs.push @hpricot.get_notification_def(index)
        end

        if element.fits_the_description?('h2', 'Constants')
          busy_with = 'Constants'
        end
        if busy_with == 'Constants' and @hpricot.start_of_method_def?(index)
          constants = @hpricot.get_constant_defs(index)
          class_def.constant_defs.concat(constants) unless constants.nil?
        end

        # There are also constant descriptions which are more like method descriptions
        if busy_with == 'Constants' and @hpricot.start_of_method_def?(index)
          constant = @hpricot.get_methodlike_constant_def(index)
          if not constant.discussion.empty? and not constant.availability.empty?
            class_def.constant_defs.push constant
          end
        end

        index = index.next
      end
      
      # Check if we got a name for the class
      if class_def.name.empty?
        error_str = "[ERROR] A empty string was returned as the class name\n"
        @log.add(error_str)
      end
      
      return class_def
    end
    
    def to_rb_file(dir)
      file = File.join(dir, @class_def.output_filename)
      File.open(file, 'w') {|f| f.write @class_def.to_rdoc}
    end
    
  end
end