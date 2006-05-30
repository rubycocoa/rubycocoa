#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni
#

require 'osx/objc/oc_all.rb'  # for ns_import

module OSX
  # Load classes lazily.
  def self.const_missing(c)
    ns_import(c)
  end

  def self.included(m)
    m.module_eval <<-EOC
      def self.const_missing(c)
        OSX::ns_import(c)
      end
    EOC
  end
end

require 'osx/objc/cocoa.rb'