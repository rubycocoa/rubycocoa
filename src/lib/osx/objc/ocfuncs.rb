#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
#
#  This program is free software.
#  You can distribute/modify this program under the terms of
#  the GNU Lesser General Public License version 2.
#

require 'osx_objc'

module OSX

  module OCStubCreator

    def ns_loadable(super_name = nil)
      name = self.to_s
      if super_name.nil? then
	OSX.objc_proxy_class_new (name)
      else
	super_name = :NSObject unless super_name
	OSX.objc_derived_class_new (name, super_name.to_s)
      end
      OSX.ns_import name
    end

    def ns_overrides(*args)
      class_name = self.to_s
      args.each do |method_name|
	OSX.objc_derived_class_method_add (class_name, method_name.to_s)
      end
    end

    def ns_outlets(*args)
      attr_writer *args
    end

    # for look and feel
    alias_method :ib_loadable,  :ns_loadable
    alias_method :ib_overrides, :ns_overrides
    alias_method :ib_outlets,   :ns_outlets

    # for backword compatibility (<= 0.1.1)
    alias_method :derived_methods, :ns_overrides

  end

  def OSX.objc_class_new(val)
    klass = Class.new(OSX::OCObject)
    klass.instance_eval %{
      extend OCObjWrapper
      @__ocobj__ = OCObject.new(val)
      def method_missing(mname, *args)
	@__ocobj__.send(mname, *args)
      end
      def __ocid__
	@__ocobj__.__ocid__
      end
      def inherited(kls)
	spr_name = self.description.to_s
	cls_name = kls.name.split(':')[-1]
	OSX.objc_derived_class_new (cls_name, spr_name)
      end
    }
    klass
  end

  def OSX.ns_import(sym)
    if not const_defined?(sym) then
      const_name = sym.to_s
      sym_name = ":#{sym}"
      module_eval %[
        nsc = objc_class_new(NSClassFromString(#{sym_name}).__ocid__)
        #{const_name} = nsc if nsc
      ]
    end
  end

end				# module OSX
