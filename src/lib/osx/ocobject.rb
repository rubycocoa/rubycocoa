#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
#
#  This program is free software.
#  You can distribute/modify this program under the terms of
#  the GNU Lesser General Public License version 2.
#

require 'osxobjc'

module OSX

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

  module OCStubCreator

    def nib_loadable(super_name = nil)
      super_name = :NSObject unless super_name
      OSX.create_objc_stub (self.to_s, super_name.to_s)
    end

    def derived_methods(*args)
      class_name = self.to_s
      args.each do |method_name|
	OSX.add_method_for_objc_stub (class_name.to_s, method_name.to_s)
      end
    end

  end

#   class NIBObject < OCObject
#     def NIBObject.inherited(klass)
#       OSX.create_objc_stub klass.to_s.intern
#     end
#   end

  module ToFloat
    def force_to_f(val)
      begin
	val.to_f
      rescue NameError
	0.0
      end
    end
  end
  
  class NSPoint
    include ToFloat
    attr_accessor :x, :y
    def initialize(*args)
      @x = force_to_f(args[0])
      @y = force_to_f(args[1])
    end
    def to_a
      [ @x, @y ]
    end
  end

  class NSSize
    include ToFloat
    attr_accessor :width, :height
    def initialize(*args)
      @width = force_to_f(args[0])
      @height = force_to_f(args[1])
    end
    def to_a
      [ @width, @height ]
    end
  end

  class NSRect
    attr_accessor :origin, :size
    def initialize(*args)
      if args.size == 2 then
	@origin = NSPoint.new(*(args[0].to_a))
	@size = NSSize.new(*(args[1].to_a))
      elsif args.size == 4 then
	@origin = NSPoint.new(*(args[0,2]))
	@size = NSSize.new(*(args[2,2]))
      else
	@origin = NSPoint.new
	@size = NSSize.new
      end
    end
    def to_a
      [ @origin.to_a, @size.to_a ]
    end
  end

  class OCObject
    extend OCStubCreator

    def to_s
      if self.ocm_send(:isKindOfClass_, OSX::NSString) != 0 then
	self.ocm_send(:cString)
      else
	self.ocm_send(:description).ocm_send(:cString)
      end
    end

    def to_a
      if self.ocm_send(:isKindOfClass_, OSX::NSArray) != 0 then
	ary = Array.new
	iter = self.ocm_send(:objectEnumerator)
	while obj = iter.ocm_send(:nextObject) do
	  ary.push(obj)
	end
	ary
      elsif self.ocm_send(:isKindOfClass_, OSX::NSEnumerator) != 0 then
	self.ocm_send(:allObjects).to_a
      else
	[ self ]
      end
    end

    def method_missing(mname, *args)
      analyze_missing(mname, args)
      ret = self.ocm_send(@m_name, *@m_args)
      ret.ocm_send(:release) if occur_ownership?(ret)
      ret = (ret != 0) if @m_method_predicate
      ret
    end

    private

    def analyze_missing(mname, args)
      @m_name = mname.to_s
      @m_args = args

      # remove `oc_' prefix
      @m_name.sub!(/^oc_/, '')

      # is predicate ?
      @m_method_predicate = @m_name.sub!(/\?$/,'')
      # @m_method_predicate = (/^is/ =~ @m_name) unless @m_method_predicate

      # check call style
      # as Objective-C: [self aaa: a0 Bbb: a1 Ccc: a2]
      # as Ruby:   self.aaa_Bbb_Ccc_ (a0, a1, a2)
      # as Ruby:   self.aaa_Bbb_Ccc (a0, a1, a2)
      # as Ruby:   self.aaa (a0, :Bbb, a1, :Ccc, a2)
      if (@m_args.size >= 3) && ((@m_args.size % 2) == 1) && (not @m_name.include?('_')) then
	mname = @m_name.dup
	args = Array.new
	@m_args.each_with_index do |val, index|
	  if (index % 2) == 0 then
	    args.push (val)
	  else
	    mname += "_#{val.to_s}"
	  end
	end
	@m_name = "#{mname}_"
	@m_args = args
      else
	@m_name.sub!(/[^_:]$/, '\0_') if @m_args.size > 0
      end
    end

    def occur_ownership?(obj)
      obj.is_a?(OSX::OCObject) &&
	(@m_name =~ /^alloc/ ||
	 @m_name =~ /^new/ ||
	 @m_name =~ /^retain/ ||
	 @m_name =~ /^copy/ ||
	 @m_name =~ /^mutableCopy/)
    end

  end				# class OCObject

end				# module OSX
