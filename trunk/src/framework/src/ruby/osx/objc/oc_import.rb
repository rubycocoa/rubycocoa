#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni
#

require 'osx/objc/oc_wrapper'

module OSX

  init_cocoa # define OSX.NSClassFromString

  # create Ruby's class for Cocoa class,
  # then define Constant under module 'OSX'.
  def ns_import(sym)
    if not OSX.const_defined?(sym)
      NSLog("importing #{sym}...") if $DEBUG
      const_name = sym.to_s
      sym_name = ":#{sym}"
      klass = OSX.module_eval <<-EOE_NS_IMPORT,__FILE__,__LINE__+1
      if clsobj = NSClassFromString(#{sym_name})
        if rbcls = class_new_for_occlass(clsobj)
          #{const_name} = rbcls
        end
      end
      EOE_NS_IMPORT
      if methods_hash = @bridge_support_signatures[const_name]
        if methods = methods_hash[:class_methods]
          methods.each { |a| klass.register_objc_passbyref_class_method(*a) }
        end
        if methods = methods_hash[:instance_methods]
          methods.each { |a| klass.register_objc_passbyref_instance_method(*a) }
        end
      end
      NSLog("importing #{sym}... done (-> #{klass.ancestors.join(' -> ')})") if $DEBUG
      return klass
    end
  end
  module_function :ns_import

  # overwrite NSClassFromString to set up a flag while it's called (see mdl_osxobjc.m:rb_osx_const())
  self.class_eval { class << self; alias_method :old_NSClassFromString, :NSClassFromString; end }
  def self.NSClassFromString(*x)
    @within_NSClassFromString = true
    retval = old_NSClassFromString(*x)
    @within_NSClassFromString = false    
    return retval
  end

  # create Ruby's class for Cocoa class
  def OSX.class_new_for_occlass(occls)
    superclass = if md = /^NSCF(.+)$/.match(occls.to_s)
      # Translate CoreFoundation toll-free bridged classes to Cocoa.
       OSX.const_get("NS" + md[1])
    else
      # Get real superclass if possible.
      _objc_lookup_superclass(occls)
    end
    klass = Class.new(superclass)
    klass.class_eval <<-EOE_CLASS_NEW_FOR_OCCLASS,__FILE__,__LINE__+1
      if superclass == OSX::ObjcID
        include OCObjWrapper 
        self.extend OCClsWrapper
      end
      @ocid = #{occls.__ocid__}
    EOE_CLASS_NEW_FOR_OCCLASS
    if superclass == OSX::ObjcID
      def klass.__ocid__() @ocid end
      def klass.to_s() name end
      def klass.inherited(subklass) subklass.ns_inherited() end
    end
    return klass
  end
  
  # Load classes lazily.
  def self.const_missing(c)
    (OSX::ns_import(c) or raise NameError, "uninitialized constant #{c}")
  end

  def self.included(m)
    return if m.respond_to? :_osx_const_missing_prev
    if m.respond_to? :const_missing
      m.module_eval <<-EOC,__FILE__,__LINE__+1
        class <<self
          alias_method :_osx_const_missing_prev, :const_missing
          def const_missing(c)
            begin
              OSX.const_missing(c)
            rescue NameError
              _osx_const_missing_prev(c)
            end
          end
	end
      EOC
    else
      m.module_eval <<-EOC,__FILE__,__LINE__+1
        def self.const_missing(c)
          OSX.const_missing(c)
        end
      EOC
    end
  end

  def OSX.load_bridge_support_signatures
    @bridge_support_signatures ||= {}
    @bridge_support_signatures.clear
    NSLog("loading bridge support signatures...") if $DEBUG
    ['/System/Library/BridgeSupport', 
     '/Library/BridgeSupport', 
     File.join(ENV['HOME'], 'Library', 'BridgeSupport')].each do |dir|
      Dir.glob(File.join(dir, "*.xml")).each do |xmlfile|
        load_bridge_support_file(xmlfile)
      end
    end
  end
  
=begin
  # This is a pure Ruby (and very slow) replacement for OSX.load_bridge_support_file 
  # defined in mdl_osxobjc.m. The native version uses libxml2, this version is based on REXML. 
  require 'rexml/document'
  def OSX.load_bridge_support_file(path)
    NSLog("loading bridge support file '#{path}'...") if $DEBUG
    document = REXML::Document.new(File.open(path))
    document.elements.each('/signatures/class') do |class_element|
      unless name = class_element.attributes['name']
        raise "Class element #{class_elememt} does not have a 'name' attribute."
      end
      @bridge_support_signatures[name] ||= {}
      class_hash = @bridge_support_signatures[name]
      [[:class_methods, class_element.elements['class_methods']],
       [:instance_methods, class_element.elements['instance_methods']]].each do |key, methods_element|
        next if methods_element.nil?
        methods_element.elements.each('method') do |method_element|
          unless selector = method_element.elements['selector']
            raise "Method element #{method_element} does not have a 'signature' child."
          end
          passbyref_args = []
          method_element.elements.each('by_reference_argument') { |arg| passbyref_args << arg.text.to_i }
          if passbyref_args.empty?
            raise "Method element #{method_element} does not have 'by_reference_argument' children."
          end
          class_hash[key] ||= []
          class_hash[key] << [selector.text, *passbyref_args]
        end
      end
      if class_hash.empty?
        @bridge_support_signatures.delete(name)
      end
    end
  end
=end

  def OSX._objc_lookup_superclass(occls)
    occls_superclass = occls.oc_superclass
    if occls_superclass.nil?
      OSX::ObjcID
    else
      begin
	OSX.const_get("#{occls_superclass}".to_sym) 
      rescue NameError
	# some ObjC internal class cannot become Ruby cosntant
	# because of prefix '%' or '_'
	if occls.__ocid__ != occls_superclass.__ocid__
	  OSX._objc_lookup_superclass(occls_superclass)
	else
	  OSX::ObjcID # root class of ObjC
	end
      end
    end
  end

  module NSBehaviorAttachment

    ERRMSG_FOR_RESTRICT_NEW = "use 'alloc.initXXX' to instantiate Cocoa Object"

    # restrict creating an instance by Class#new of NSObject gruop.
    def new
      raise ERRMSG_FOR_RESTRICT_NEW
    end

    # initializer for definition of a derived class of a class on
    # Objective-C World.
    def ns_inherited()
      return if ns_inherited?
      spr_name = superclass.name.split('::')[-1]
      kls_name = self.name.split('::')[-1]
      occls = OSX.objc_derived_class_new(self, kls_name, spr_name)
      self.instance_eval "@ocid = #{occls.__ocid__}",__FILE__,__LINE__+1
      @inherited = true
    end

    def ns_inherited?
      return defined?(@inherited) && @inherited
    end

    # declare to override instance methods of super class which is
    # defined by Objective-C.
    def ns_overrides(*args)
      # insert specified selectors to Objective-C method table.
      args.each do |name|
	name = name.to_s.gsub('_',':')
	OSX.objc_derived_class_method_add(self, name)
      end
    end

    # declare write-only attribute accessors which are named IBOutlet
    # in the Objective-C world.
    def ns_outlets(*args)
      attr_writer(*args)
    end

    # for look and feel
    alias_method :ns_override,  :ns_overrides
    alias_method :ib_override,  :ns_overrides
    alias_method :ib_overrides, :ns_overrides
    alias_method :ns_outlet,  :ns_outlets
    alias_method :ib_outlet,  :ns_outlets
    alias_method :ib_outlets, :ns_outlets

    def _ns_behavior_method_added(sym)
      sel = sym.to_s.gsub(/([^_])_/, '\1:')
      sel << ':' if instance_method(sym).arity > 0 and /[^:]\z/ =~ sel
      return unless _ns_enable_override?(sel)
      ns_override sel
    end

    def _ns_enable_override?(sel)
      if ns_inherited? && self.objc_instance_method_type(sel)
        true
      else
        false
      end
    end

  end				# module OSX::NSBehaviorAttachment

  module NSKVCAccessorUtil
    private

    def kvc_internal_setter(key)
      return '_kvc_internal_' + key.to_s + '=' 
    end

    def kvc_setter_wrapper(key)
      return '_kvc_wrapper_' + key.to_s + '=' 
    end
  end				# module OSX::NSKVCAccessorUtil

  module NSKeyValueCodingAttachment
    include NSKVCAccessorUtil

    # invoked from valueForUndefinedKey: of a Cocoa object
    def rbValueForKey(key)
      if m = kvc_getter_method(key.to_s)
	return send(m)
      else
	kvc_accessor_notfound(key)
      end
    end

    # invoked from setValue:forUndefinedKey: of a Cocoa object
    def rbSetValue_forKey(value, key)
      if m = kvc_setter_method(key.to_s)
	willChangeValueForKey(key)
	send(m, value)
	didChangeValueForKey(key)
      else
	kvc_accessor_notfound(key)
      end
    end

    private
    
    # find accesor for key-value coding
    # "key" must be a ruby string

    def kvc_getter_method(key)
      [key, key + '?'].each do |m|
	return m if respond_to? m
      end
      return nil # accessor not found
    end
 
    def kvc_setter_method(key)
      [kvc_internal_setter(key), key + '='].each do |m|
	return m if respond_to? m
      end
      return nil
    end

    def kvc_accessor_notfound(key)
      fmt = '%s: this class is not key value coding-compliant for the key "%s"'
      raise sprintf(fmt, self.class, key.to_s)
    end

  end				# module OSX::NSKeyValueCodingAttachment

  module NSKVCBehaviorAttachment
    include NSKVCAccessorUtil

    def kvc_reader(*args)
      attr_reader(*args)
    end

    def kvc_writer(*args)
      args.flatten.each do |key|
	setter = key.to_s + '='
	attr_writer(key) unless method_defined?(setter)
	alias_method kvc_internal_setter(key), setter
	self.class_eval <<-EOE_KVC_WRITER,__FILE__,__LINE__+1
	  def #{kvc_setter_wrapper(key)}(value)
	    willChangeValueForKey('#{key.to_s}')
	    send('#{kvc_internal_setter(key)}', value)
	    didChangeValueForKey('#{key.to_s}')
	  end
	EOE_KVC_WRITER
	alias_method setter, kvc_setter_wrapper(key)
      end
    end

    def kvc_accessor(*args)
      kvc_reader(*args)
      kvc_writer(*args)
    end

    def kvc_depends_on(keys, *dependencies)
      dependencies.flatten.each do |dependentKey|
        setKeys_triggerChangeNotificationsForDependentKey(Array(keys), dependentKey)
      end
    end
 
    # define accesor for keys defined in Cocoa, 
    # such as NSUserDefaultsController and NSManagedObject
    def kvc_wrapper(*keys)
      kvc_wrapper_reader(*keys)
      kvc_wrapper_writer(*keys)
    end

    def kvc_wrapper_reader(*keys)
      keys.flatten.compact.each do |key|
        class_eval <<-EOE_KVC_WRAPPER,__FILE__,__LINE__+1
    	def #{key}
  	  valueForKey("#{key}")
	end
  	EOE_KVC_WRAPPER
      end
    end

    def kvc_wrapper_writer(*keys)
      keys.flatten.compact.each do |key|
        class_eval <<-EOE_KVC_WRAPPER,__FILE__,__LINE__+1
	def #{key}=(val)
	  setValue_forKey(val, "#{key}")
	end
  	EOE_KVC_WRAPPER
      end
    end

    # Define accessors that send change notifications for an array.
    # The array instance variable must respond to the following methods:
    #
    #  length
    #  [index]
    #  [index]=
    #  insert(index,obj)
    #  delete_at(index)
    #
    # Notifications are only sent for accesses through the Cocoa methods:
    #  countOfKey, objectInKeyAtIndex_, insertObject_inKeyAtIndex_,
    #  removeObjectFromKeyAtIndex_, replaceObjectInKeyAtIndex_withObject_
    #
    def kvc_array_accessor(*args)
      args.each do |key|
	keyname = key.to_s
	keyname[0..0] = keyname[0..0].upcase
	self.addRubyMethod_withType("countOf#{keyname}".to_sym, "i4@8:12")
	self.addRubyMethod_withType("objectIn#{keyname}AtIndex:".to_sym, "@4@8:12i16")
	self.addRubyMethod_withType("insertObject:in#{keyname}AtIndex:".to_sym, "@4@8:12@16i20")
	self.addRubyMethod_withType("removeObjectFrom#{keyname}AtIndex:".to_sym, "@4@8:12i16")
	self.addRubyMethod_withType("replaceObjectIn#{keyname}AtIndex:withObject:".to_sym, "@4@8:12i16@20")
	# get%s:range: - unimplemented. You can implement this method for performance improvements.
	self.class_eval <<-EOT,__FILE__,__LINE__+1
	  def countOf#{keyname}()
	    return @#{key.to_s}.length
	  end

	  def objectIn#{keyname}AtIndex(index)
	    return @#{key.to_s}[index]
	  end

	  def insertObject_in#{keyname}AtIndex(obj, index)
	    indexes = OSX::NSIndexSet.indexSetWithIndex(index)
	    willChange_valuesAtIndexes_forKey(OSX::NSKeyValueChangeInsertion, indexes, #{key.inspect})
	    @#{key.to_s}.insert(index, obj)
	    didChange_valuesAtIndexes_forKey(OSX::NSKeyValueChangeInsertion, indexes, #{key.inspect})
	    nil
	  end

	  def removeObjectFrom#{keyname}AtIndex(index)
	    indexes = OSX::NSIndexSet.indexSetWithIndex(index)
	    willChange_valuesAtIndexes_forKey(OSX::NSKeyValueChangeRemoval, indexes, #{key.inspect})
	    @#{key.to_s}.delete_at(index)
	    didChange_valuesAtIndexes_forKey(OSX::NSKeyValueChangeRemoval, indexes, #{key.inspect})
	    nil
	  end

	  def replaceObjectIn#{keyname}AtIndex_withObject(index, obj)
	    indexes = OSX::NSIndexSet.indexSetWithIndex(index)
	    willChange_valuesAtIndexes_forKey(OSX::NSKeyValueChangeReplacement, indexes, #{key.inspect})
	    @#{key.to_s}[index] = obj
	    didChange_valuesAtIndexes_forKey(OSX::NSKeyValueChangeReplacement, indexes, #{key.inspect})
	    nil
	  end
	EOT
      end
    end

    # re-wrap at overriding setter method
    def _kvc_behavior_method_added(sym)
      return unless sym.to_s =~ /\A([^=]+)=\z/
      key = $1
      setter = kvc_internal_setter(key)
      wrapper = kvc_setter_wrapper(key)
      return unless method_defined?(setter) && method_defined?(wrapper)
      return if instance_method(wrapper) == instance_method(sym)
      alias_method setter, sym
      alias_method sym, wrapper
    end

  end				# module OSX::NSKVCBehaviorAttachment

  module OCObjWrapper

    include NSKeyValueCodingAttachment
  
  end

  module OCClsWrapper

    include OCObjWrapper
    include NSBehaviorAttachment
    include NSKVCBehaviorAttachment

    def method_added(sym)
      _ns_behavior_method_added(sym)
      _kvc_behavior_method_added(sym)
    end

  end

end				# module OSX

# The following code defines a new subclass of Object (Ruby's).
# 
#    module OSX 
#      class NSCocoaClass end 
#    end
#
# This Object.inherited() replaces the subclass of Object class by 
# a Cocoa class from # OSX.ns_import.
#
class Object
  class <<self
    alias __before_osx_inherited inherited
    def inherited(subklass)
      klassname = subklass.name
      if /\AOSX::/ =~ klassname && klassname.split(/::/).size == 2
	nsklass = klassname.split(/::/)[1]
	# remove Ruby's class
	OSX.instance_eval { remove_const nsklass.intern }
        begin
	  subklass = OSX.ns_import nsklass.intern
	rescue NameError
	  # redefine subclass (looks not a Cocoa class)
	  OSX.const_set(nsklass, subklass)
	end
      end
      __before_osx_inherited(subklass)
    end
  end
end

OSX.load_bridge_support_signatures
