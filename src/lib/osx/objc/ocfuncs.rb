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
      def inherited(k)
	# create new Class in the Objective-C world
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
