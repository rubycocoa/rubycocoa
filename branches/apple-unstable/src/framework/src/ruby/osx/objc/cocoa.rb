#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni
#

OSX.init_cocoa

require 'osx/objc/oc_all.rb'  # for ns_import

module OSX
  # Load classes lazily.
  def self.const_missing(c)
    (OSX::ns_import(c) or raise NameError, "uninitialized constant #{c}")
  end

  def self.included(m)
    m.module_eval <<-EOC
      def self.const_missing(c)
        (OSX::ns_import(c) or raise NameError, "uninitialized constant \#{c}")
      end
    EOC
  end
end

OSX.load_bridge_support_signatures

require 'osx/objc/cocoa_macros'
