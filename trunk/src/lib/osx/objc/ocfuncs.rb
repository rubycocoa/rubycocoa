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
      @__objcid__ = ObjcID.new(val)
      def inherited(k)
	p k
      end
    }
    klass
  end

  def OSX.ns_import(sym)
    if not const_defined?(sym) then
      const_name = sym.to_s
      sym_name = ":#{sym}"
      module_eval %[
        nsc = NSClassFromString(#{sym_name})
        #{const_name} = nsc if nsc
      ]
    end
  end

end				# module OSX
