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
      OSX.module_eval %[
        clsobj = NSClassFromString(#{sym_name})
        rbcls = class_new_for_occlass(clsobj)
        #{const_name} = rbcls if rbcls
      ]
    end
  end
  module_function :ns_import

  # create Ruby's class for Cocoa class
  def OSX.class_new_for_occlass(occls)
    klass = Class.new(OSX::ObjcID)
    klass.instance_eval %[
      include OCObjWrapper
      @ocid = #{occls.__ocid__}
    ]
    klass.extend OCObjWrapper

    def klass.new() alloc.init end
    def klass.__ocid__() @ocid end
    def klass.to_s() name end

    def klass.inherited(kls)
      spr_name = self.name.split('::')[-1]
      kls_name = kls.name.split('::')[-1]
      occls = OSX.objc_derived_class_new(kls, kls_name, spr_name)
      kls.instance_eval "@ocid = #{occls.__ocid__}"
      kls.extend NSBehaviorAttachment
      def kls.new
	raise "use 'alloc.initXXX' to instantiate Cocoa Object"
      end
    end

    klass
  end

  module NSBehaviorAttachment

    def ns_overrides(*args)
      args.each do |name|
	name = name.to_s.gsub('_',':')
	OSX.objc_derived_class_method_add(self, name)
      end
    end

    def ns_outlets(*args)
      attr_writer(*args)
    end

    # for look and feel
    alias_method :ib_overrides, :ns_overrides
    alias_method :ib_outlets,   :ns_outlets

  end				# module OSX::NSBehaviorAttachment

end				# module OSX
