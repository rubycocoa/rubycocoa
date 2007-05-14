require 'osx/cocoa'
begin
  require 'active_record'
rescue LoadError
  msg = "ActiveRecord was not found, if you have it installed as a gem you have to require 'rubygems' before you require 'osx/active_record'"
  $stderr.puts msg
  raise LoadError, msg
end

# ---------------------------------------------------------
# Class additions
# ---------------------------------------------------------

class ActiveRecord::Base
  def to_activerecord_proxy
    klass = self.class.to_s.to_activerecord_proxy_class
    return klass.alloc.init(self)
  end
  alias_method :to_activerecord_proxies, :to_activerecord_proxy
end

class Array
  def to_activerecord_proxies
    return self if self.empty?
    klass = self.first.class.to_s.to_activerecord_proxy_class
    return self.map { |rec| klass.alloc.init(rec) }
  end
  alias_method :to_activerecord_proxy, :to_activerecord_proxies
end

class String
  def to_activerecord_proxy_class
    Object.const_get("#{self}Proxy")
  end
end

# ---------------------------------------------------------
# Subclasses of cocoa classes that add ActiveRecord support
# ---------------------------------------------------------

class ActiveRecordSetController < OSX::NSArrayController
  # First tries to destroy the record then lets the super method do it's work
  # FIXME: Currently only expects one selected object
  def remove(sender)
    if self.selectedObjects.to_a.first.destroy
      super_remove(sender)
    end
  end
end

class ActiveRecordProxy < OSX::NSObject
  # Returns a new record proxy instance.
  # If the +arg+ is a ActiveRecord::Base instance it will return a proxy for that record.
  # If the +arg+ is a hash a new ActiveRecord::Base instance will be instantiated and will be passed the hash.
  def init(arg = nil)
    if super_init
      if arg.nil?
        # instantiate a new record
        @record = record_class.send(:new)
        return nil unless @record.save
      elsif arg.is_a? Hash
        # instantiate a new record with the options in arg
        @record = record_class.send(:new, arg)
        return nil unless @record.save
      elsif arg.is_a? ActiveRecord::Base
        # use the passed record
        @record = arg
      else
        return nil
      end
      return self
    end
  end
  
  def record_class
    Object.const_get( self.class.to_s[0..-6] )
  end
  
  # Returns an Array of all the available methods on the corresponding record object
  def record_methods
    @record.methods
  end
  
  # Returns the corresponding record object
  def to_activerecord
    @record
  end
  # Returns the corresponding record object
  def original_record
    @record
  end
  
  # Returns +true+ if the given key is an association, otherwise returns +false+
  def is_association?(key)
    key_sym = key.to_s.to_sym
    @record.class.reflect_on_all_associations.each { |assoc| return true if assoc.name == key_sym }
    return false
  end
  
  # Passes a method call on to the corresponding record object
  def method_missing(method, *args)
    if @record.respond_to? method
      @record.send method, *args
    else
      super
    end
  end
  
  # KVC stuff
  
  # This method is called by the object that self is bound to,
  # if the requested key is a association return proxies for the records.
  def rbValueForKey(key)
    # puts "valueForKey('#{key}')"
    
    if is_association? key
      # return the associated records as record proxies
      return @record.send(key.to_s.to_sym).to_activerecord_proxies
    else
      return @record[key.to_s]
    end
  end
  
  # This method is called by the object that self is bound to,
  # it's called when a update has occured.
  def rbSetValue_forKey(value, key)
    # puts "setValue_forKey('#{value}', '#{key}')"
    
    if is_association? key
      # we are dealing with an association (only has_many for now),
      # so add the newest record to the has_many association of the @record
      @record.send(key.to_s.to_sym) << value.to_a.last.to_activerecord
      result = @record.save
      # reload the @record, if we don't do this then the newest record will not show up in the array
      # FIXME: this is slow! check if there's another way to add the latest record to the array without reloading everything.
      @record.reload
    else
      # FIXME: this code should be refactored once we will provide a unique API to convert ObjC proxy objects to native Ruby types.
      @record[key.to_s] = case value
        when OSX::NSString
          value.to_s
        when OSX::NSArray
          value.to_a
        when OSX::NSAttributedString
          value.string.to_s
        else
          value
      end
      result = @record.save
    end
    return result
  end
  
  # This method is called by the object that self is bound to,
  # it passes the value on to the record object and returns the validation result.
  def validateValue_forKeyPath_error(value, key, error)
    original_value = @record[key.to_s]
    @record[key.to_s] = value[0].to_s
    @record.valid?
    # we only want to check if the value for this attribute is valid and not every attribute
    if @record.errors[key.to_s].nil?
      return true
    else
      # set the original value back
      @record[key.to_s] = original_value
      # create a error message for each validation error on this attribute
      error_msg = ''
      @record.errors[key.to_s].each do |err|
        error_msg += "#{self.record_class} #{key.to_s} #{err}\n"
      end
      # construct the NSError object
      error.assign( OSX::NSError.alloc.initWithDomain_code_userInfo( OSX::NSCocoaErrorDomain, -1, { OSX::NSLocalizedDescriptionKey => error_msg } ) )
      return false
    end
  end

end
