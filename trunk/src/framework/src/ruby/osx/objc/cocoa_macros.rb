# Copyright (c) 2006-2008, The RubyCocoa Project.
# Copyright (c) 2001-2006, FUJIMOTO Hisakuni.
# All Rights Reserved.
#
# RubyCocoa is free software, covered under either the Ruby's license or the 
# LGPL. See the COPYRIGHT file for more information.

module OSX

  # from NSBundle
  def NSLocalizedString (key, comment = nil)
    OSX::NSBundle.mainBundle.
      localizedStringForKey_value_table(key, "", nil)
  end
  def NSLocalizedStringFromTable (key, tbl, comment = nil)
    OSX::NSBundle.mainBundle.
      localizedStringForKey_value_table(key, "", tbl)
  end
  def NSLocalizedStringFromTableInBundle (key, tbl, bundle, comment = nil)
    bundle.localizedStringForKey_value_table(key, "", tbl)
  end
  module_function :NSLocalizedStringFromTableInBundle
  module_function :NSLocalizedStringFromTable
  module_function :NSLocalizedString

  # for NSData
  class NSData

    def NSData.dataWithRubyString (str)
      NSData.dataWithBytes_length( str )
    end

  end

  # for NSMutableData
  class NSMutableData

    def NSMutableData.dataWithRubyString (str)
      NSMutableData.dataWithBytes_length( str )
    end

  end

  # CoreData additions.
  module CoreData
    # define wrappers from NSManagedObjectModel
    def define_wrapper(model)
      unless model.isKindOfClass? OSX::NSManagedObjectModel
        raise RuntimeError, "invalid class: #{model.class}"
      end

      model.entities.each do |ent|
        CoreData.define_wrapper_for_entity(ent)
      end
    end
    module_function :define_wrapper

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
