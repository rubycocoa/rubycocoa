#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
#
#  This program is free software.
#  You can distribute/modify this program under the terms of
#  the GNU Lesser General Public License version 2.
#

require 'osx/ocobject'

module OSX

  class OCController < OCObject

    def add_outlets(*names)
      @outlets = Hash.new if @outlets.nil?
      names.each do |oname|
	@outlets[oname.to_s] = nil
	define_outlet_method(oname.to_s)
      end
    end

    def initialize
      setup_outlet if respond_to? :setup_outlet
    end

    private

    def define_outlet_method(oname)
      puts "=== define_outlet_method ==="
      instance_eval %{
	def #{oname}
	  outlet_named("#{oname}")
	end
      }
    end

    def outlet_named(mname)
      @outlets[mname] = ocm_send(mname) if @outlets[mname].nil?
      @outlets[mname]
    end
    
  end

end
