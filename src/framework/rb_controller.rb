#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
#
#  This program is free software.
#  You can distribute/modify this program under the terms of
#  the GNU Lesser General Public License version 2.
#

class RubyController

  attr_reader :oc_self

  def add_outlets(*names)
    @outlets = Hash.new if @outlets.nil?
    names.each do |oname|
      @outlets[oname.to_s] = nil
      define_outlet_method(oname.to_s)
    end
  end

  private

  def initialize
    @oc_self = nil
    setup_outlet if respond_to? :setup_outlet
  end

  # Special method called from RubyController.m
  def set_ocobj(ocobj)
    @oc_self = ocobj
  end

  def method_missing(mname, *args)
    @oc_self.send(mname, *args)
  end

  def define_outlet_method(oname)
    instance_eval %{
      def #{oname}
	outlet_named("#{oname}")
      end
    }
  end

  def outlet_named(mname)
    @outlets[mname] = @oc_self.send(mname) if @outlets[mname].nil?
    @outlets[mname]
  end

end
