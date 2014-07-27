# Copyright (c) 2006-2008, The RubyCocoa Project.
# Copyright (c) 2001-2006, FUJIMOTO Hisakuni.
# All Rights Reserved.
#
# RubyCocoa is free software, covered under either the Ruby's license or the 
# LGPL. See the COPYRIGHT file for more information.

module OSX

  # @!group Localization

  # Convenient function for -[NSBundle localizedStringForKey:value:table:] of mainBundle.
  def NSLocalizedString (key, comment = nil)
    OSX::NSBundle.mainBundle.
      localizedStringForKey_value_table(key, "", nil)
  end
  # Convenient function for -[NSBundle localizedStringForKey:value:table:] of mainBundle.
  def NSLocalizedStringFromTable (key, tbl, comment = nil)
    OSX::NSBundle.mainBundle.
      localizedStringForKey_value_table(key, "", tbl)
  end
  # Convenient function for -[NSBundle localizedStringForKey:value:table:].
  def NSLocalizedStringFromTableInBundle (key, tbl, bundle, comment = nil)
    bundle.localizedStringForKey_value_table(key, "", tbl)
  end
  module_function :NSLocalizedStringFromTableInBundle
  module_function :NSLocalizedStringFromTable
  module_function :NSLocalizedString

  # @!endgroup

  # NSData additions.
  class NSData

    # @return [OSX::NSData]
    # @deprecated DO NOT USE. use NSString#dataUsingEncoding().
    def NSData.dataWithRubyString (str)
      warn "#{caller[0]}:: NSData.dataWithRubyString will be deprecated."
      NSData.dataWithBytes_length( str )
    end

  end

  # NSMutableData additions.
  class NSMutableData

    # @return [OSX::NSMutableData]
    # @deprecated DO NOT USE. use NSString#dataUsingEncoding().
    def NSMutableData.dataWithRubyString (str)
      warn "#{caller[0]}:: NSMutableData.dataWithRubyString will be deprecated."
      NSMutableData.dataWithBytes_length( str )
    end

  end

  # CoreData additions.
  module CoreData
    # Defines wrapper methods from given NSManagedObjectModel.
    # @param [OSX::NSManagedObjectModel] model
    def define_wrapper(model)
      unless model.isKindOfClass? OSX::NSManagedObjectModel
        raise RuntimeError, "invalid class: #{model.class}"
      end

      model.entities.each do |ent|
        CoreData.define_wrapper_for_entity(ent)
      end
    end
    module_function :define_wrapper

    # Defines wrapper method from given NSEntityDescription.
    # @param [OSX::NSEntityDescription] entity
    def define_wrapper_for_entity(entity)
      klassname = entity.managedObjectClassName.to_s
      return if klassname == 'NSManagedObject'
      unless Object.const_defined?(klassname)
	warn "define_wrapper_for_entity: class \"#{klassname}\" is not defined."
        return
      end

      attrs = entity.attributesByName.allKeys.collect {|key| key.to_s}
      rels = entity.relationshipsByName.allKeys.collect {|key| key.to_s}
      klass = Object.const_get(klassname)
      klass.instance_eval <<-EOE_AUTOWRAP,__FILE__,__LINE__+1
	kvc_wrapper attrs
	kvc_wrapper_reader rels
      EOE_AUTOWRAP
    end
    module_function :define_wrapper_for_entity
  end

end
