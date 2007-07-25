# Copyright (c) 2006-2007, The RubyCocoa Project.
# Copyright (c) 2001-2006, FUJIMOTO Hisakuni.
# All Rights Reserved.
#
# RubyCocoa is free software, covered under either the Ruby's license or the 
# LGPL. See the COPYRIGHT file for more information.

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
  class << self
    alias_method :__inherited_before_proxy__, :inherited
    def inherited(klass)
      proxy_klass = "#{klass.to_s}Proxy"
      unless Object.const_defined?(proxy_klass)
        eval "class ::#{proxy_klass} < OSX::ActiveRecordProxy; end;"
        # FIXME: This leads to a TypeError originating from: oc_import.rb:618:in `method_added'
        # Object.const_set(proxy_klass, Class.new(OSX::ActiveRecordProxy))
      end
      self.__inherited_before_proxy__(klass)
    end
  end
  
  # Returns a proxy for this instance.
  def to_activerecord_proxy
    if self.class.instance_variable_get(:@proxy_klass).nil?
      self.class.instance_variable_set(:@proxy_klass, Object.const_get("#{self.class.to_s}Proxy"))
    end
    return self.class.instance_variable_get(:@proxy_klass).alloc.initWithRecord(self)
  end
  alias_method :to_activerecord_proxies, :to_activerecord_proxy
end

class Array
  # Returns an array with proxies for all the original records in this array.
  def to_activerecord_proxies
    self.map { |rec| rec.to_activerecord_proxy }
  end
  alias_method :to_activerecord_proxy, :to_activerecord_proxies
  
  # Returns an array with all the original records for the proxies in this array.
  def original_records
    self.map { |rec| rec.original_record }
  end
end

module OSX
  
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
    
    # Sets up the ActiveRecordSetController for a given model and sets the content if it's specified.
    #
    # <tt>:model</tt> should be the model that we'll be handling.
    # <tt>:content</tt> is optional, if specified it should be an array with or without any proxies for the model that we're handling.
    def setup_for(options)
      raise ArgumentError, ":model was nil, expected a ActiveRecord::Base subclass" if options[:model].nil?
      # FIXME: not DRY, duplicated from ActiveRecord::Base#to_activerecord_proxy
      self.setObjectClass( Object.const_get("#{options[:model].to_s}Proxy") )
      self.setContent(options[:content]) unless options[:content].nil?
    end
    
  end
  
  class ActiveRecordTableView < OSX::NSTableView
    require 'active_support/core_ext/string/inflections'
    include ActiveSupport::CoreExtensions::String::Inflections

    # <tt>:model</tt> should be the model class that you want to scaffold.
    # <tt>:bind_to</tt> should be the ActiveRecordSetController instance that you want the columns to be bound too.
    # <tt>:except</tt> can be either a string or an array that says which columns should not be displayed.
    # <tt>:validates_immediately</tt> set this to +true+ to add validation to every column. Defaults to +false+.
    #
    #   ib_outlets :customersTableView, :customersRecordSetController
    #  
    #   def awakeFromNib
    #     @customersTableView.scaffold_columns_for :model => Customer, :bind_to => @customersRecordSetController, :validates_immediately => true, :except => "id"
    #   end
    #
    # You can also pass it a block which will yield 2 objects for every column, namely +table_column+ which is the new NSTableColumn
    # and +column_opyions+ which is a hash that can be used to set additional options for the binding.
    #
    #   ib_outlets :customersTableView, :customersRecordSetController
    #  
    #   def awakeFromNib
    #     @customersTableView.scaffold_columns_for :model => Customer, :bind_to => @customersRecordSetController do |table_column, column_options|
    #       p table_column
    #       p column_options
    #       column_options['NSValidatesImmediately'] = true
    #     end
    #   end
    def scaffold_columns_for(options, &block)
      raise ArgumentError, ":model was nil, expected a ActiveRecord::Base subclass" if options[:model].nil?
      raise ArgumentError, ":bind_to was nil, expected an instance of ActiveRecordSetController" if options[:bind_to].nil?
      options[:except] ||= []
      options[:validates_immediately] ||= false
      
      # if there are any columns already, first remove them.
      cols = self.tableColumns
      if cols.count > 0
        # we create a temporary array because we do not want to mutate the
        # original one during the enumeration
        tmpCols = OSX::NSArray.arrayWithArray(cols)
        tmpCols.each { |column| self.removeTableColumn(column) }
      end
      
      options[:model].column_names.each do |column_name|
        # skip columns
        next if options[:except].include?(column_name)
        # setup new table column
        table_column = OSX::NSTableColumn.alloc.init
        table_column.setIdentifier(column_name)
        table_column.headerCell.setStringValue(column_name.titleize)
        # create a hash that will hold the options that will be passed as options to the bind method
        column_options = {}
        column_options['NSValidatesImmediately'] = options[:validates_immediately]
        unless block.nil?
          yield table_column, column_options
        end
        # set the binding
        table_column.bind_toObject_withKeyPath_options(OSX::NSValueBinding, options[:bind_to], "arrangedObjects.#{column_name}", column_options)
        # and add it to the table view
        self.addTableColumn(table_column)
      end
    end
  end
  
  class ActiveRecordProxy < OSX::NSObject
    
    # class methods
    class << self
      # Use this class method to set any filters you need when a specific value for a key is requested.
      # You can pass it a block, or a hash that contains either the key:
      # - <tt>:return</tt> which needs an array that holds the class to be instantiated as the first element
      # and the method to be called if the data isn't nil as the second element.
      # If the data is nil the class will simply be instantiated with the normal alloc.init call.
      # - <tt>:call</tt> which needs the method that it should call. When the method is called the data is sent as the argument.
      #
      #   class EmailProxy < OSX::ActiveRecordProxy
      #     # on_get filter with: block
      #     on_get :body do |content|
      #       content ||= 'I'm so empty'
      #       OSX::NSAttributedString.alloc.initWithString(content)
      #     end
      # 
      #     # on_get filter with: return
      #     on_get :subject, :return => [OSX::NSAttributedString, :initWithString]
      # 
      #     # on_get filter with: call
      #     on_get :address, :call => :nsattributed_string_from_address
      #     # and the method to be called
      #     def nsattributed_string_from_address(address)
      #       address ||= 'Emptier than this isn't possible'
      #       OSX::NSAttributedString.alloc.initWithString(address)
      #     end
      #   end
      def on_get(key, options={}, &block)
        @on_get_filters ||= {}
        @on_get_filters[key.to_sym] = ( block.nil? ? options : block )
      end
      
      # This find class method passes the message on to the model, but it will return proxies for the returned records
      def find(*args)
        result = self.model_class.find(*args)
        return result.to_activerecord_proxies
      end
      
      # This method_missing class method passes the find_by_ message on to the model, but it will return proxies for the returned records
      def method_missing(method, *args)
        if method.to_s.index('find_by_') == 0
          result = self.model_class.send(method, *args)
          return result.to_activerecord_proxies
        else
          super
        end
      end
      
      # Returns the model class for this proxy
      def model_class
        @model_class ||= Object.const_get(self.to_s[0..-6])
        return @model_class
      end
    end
    
    # Creates a new record and returns a proxy for it.
    def init
      if super_init
        # instantiate a new record if necessary
        unless @record
          @record = self.record_class.send(:new)
          return nil unless @record.save
        end
        
        # define all the record attributes getters and setters
        @record.attribute_names.each do |m|
          self.class.class_eval do
            define_method(m) do
              return @record.send(m)
            end
            sym = "#{m}=".to_sym
            define_method(sym) do |*args|
              return @record.send(sym, *args)
            end
          end
        end
        # define the normal instance methods of the record
        (@record.methods - self.methods).each do |m|
          self.class.class_eval do
            define_method(m) do |*args|
              return @record.send(m, *args)
            end
          end
        end
        
        return self
      end
    end
    
    # Takes an existing record as an argument and returns a proxy for it.
    def initWithRecord(record)
      @record = record
      self.init
    end
    
    # Creates a new record with the given attributes and returns a proxy for it.
    def initWithAttributes(attributes)
      @record = record_class.send(:new, attributes)
      return nil unless @record.save
      self.init
    end
    
    # Returns the model class for this proxy
    def record_class
      self.class.model_class
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
  
    # KVC stuff
    
    # Get the filter for a given key if it exists.
    def on_get_filter_for_key(key)
      filters = self.class.instance_variable_get(:@on_get_filters)
      filters[key.to_sym] unless filters.nil?
    end
    
    # This method is called by the object that self is bound to,
    # if the requested key is a association return proxies for the records.
    def rbValueForKey(key)
      #puts "valueForKey('#{key}')"
    
      if is_association? key
        # return the associated records as record proxies
        return @record.send(key.to_s.to_sym).to_activerecord_proxies
      else
        if filter = self.on_get_filter_for_key(key)
          #puts "filter for key: #{key}"
          if filter.is_a?(Hash)
            case filter.keys.first
            when :return
              klass, method = filter[:return]
              data = @record[key.to_s]
              unless data.nil?
                # if we have data, call the given init method and pass the data
                return klass.alloc.send(method.to_sym, data)
              else
                # if we have no data simply initialize a new instance of klass
                return klass.alloc.init
              end
            when :call
              # call the given method and pass it the data
              return self.send(filter[:call], @record[key.to_s])
            end
          elsif filter.is_a?(Proc)
            # call the proc and pass it the data
            return filter.call(@record[key.to_s])
          end
        else
          # no filter, so simply return the data
          return @record[key.to_s]
        end
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
        @record[key.to_s] = value.to_ruby rescue nil
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
  
  module ActiveRecordSupport
    # Check to see if the database exists for the current environment
    def database_exists?
      require 'erb'
      database_file = YAML::load(ERB.new(IO.read(File.join(RUBYCOCOA_ROOT, 'config', 'database.yml'))).result)
      File.exists?(database_file[RUBYCOCOA_ENV]['database'])
    end

    def database_needs_migration?     
      ActiveRecord::Migrator.current_version != ActiveRecord::Migrator.latest_version(File.join(RUBYCOCOA_ROOT, 'db', 'migrate'))
    end
  end
end


module ActiveRecord
  class Migrator
    def self.latest_version(migrations_path)
      files = Dir["#{migrations_path}/[0-9]*_*.rb"].sort
      files.last.split('/').last.scan(/^[0-9]+/).first.to_i
    end
  end
end

include OSX::ActiveRecordSupport
