#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
#
#  This program is free software.
#  You can distribute/modify this program under the terms of
#  the GNU Lesser General Public License version 2.
#

require 'osx/objc/oc_wrapper'

module OSX

  # create Ruby's class for Cocoa class,
  # then define Constant under module 'OSX'.
  def ns_import(sym)
    if not OSX.const_defined?(sym) then
      const_name = sym.to_s
      sym_name = ":#{sym}"
      OSX.module_eval %{
        clsobj = NSClassFromString(#{sym_name})
        rbcls = class_new_for_occlass(clsobj)
        #{const_name} = rbcls if rbcls
      }
    end
  end
  module_function :ns_import

  # create Ruby's class for Cocoa class
  def OSX.class_new_for_occlass(occls)
    klass = Class.new(OSX::ObjcID)
    klass.class_eval %{
      include OCObjWrapper
      self.extend OCObjWrapper
      self.extend NSBehaviorAttachment
      @ocid = #{occls.__ocid__}
    }
    def klass.__ocid__() @ocid end
    def klass.to_s() name end
    def klass.inherited(subklass) subklass.ns_inherited() end
    return klass
  end

  module NSBehaviorAttachment

    # restrict creating an instance by Class#new of NSObject gruop.
    def new
      raise "use 'alloc.initXXX' to instantiate Cocoa Object"
    end

    # initializer for definition of a derived class of a class on
    # Objective-C World.
    def ns_inherited()
      return if @inherited
      spr_name = superclass.name.split('::')[-1]
      kls_name = self.name.split('::')[-1]
      occls = OSX.objc_derived_class_new(self, kls_name, spr_name)
      self.instance_eval "@ocid = #{occls.__ocid__}"
      @inherited = true
    end

    # declare to override instance methods of super class which is
    # defined by Objective-C.
    def ns_overrides(*args)
      # In Ruby 1.8 (after 2002.9.27), this method may be called more
      # first than 'Class#inherited'.
      ns_inherited()

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

  end				# module OSX::NSBehaviorAttachment

end				# module OSX
