#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni
#

module OSX

  class << self
    attr_accessor :relaxed_syntax
  end

  module OCObjWrapper

    def method_missing(mname, *args)
      m_name, m_args, m_predicate = analyze_missing(mname, args)
      ret = self.ocm_send(m_name, *m_args)
      ret = (ret != 0) if m_predicate
      ret
    end

    def ocnil?
      self.__ocid__ == 0
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

    def to_i
      if self.ocm_send(:isKindOfClass_, OSX::NSNumber) != 0 then
        self.ocm_send(:stringValue).to_s.to_i
      else
        super
      end
    end

    def to_f
      if self.ocm_send(:isKindOfClass_, OSX::NSNumber) != 0 then
        self.ocm_send(:floatValue)
      else
        super
      end
    end

    private

    def analyze_missing(mname, args)
      m_name = mname.to_s
      m_args = args

      # remove `oc_' prefix
      m_name.sub!(/^oc_/, '')

      # is predicate ?
      m_predicate = m_name.sub!(/\?$/,'')
      # m_predicate = (/^is/ =~ m_name) unless m_predicate

      # check call style
      #   as Objective-C: [self aaa: a0 Bbb: a1 Ccc: a2]
      #   as Ruby:   self.aaa_Bbb_Ccc_ (a0, a1, a2)
      # check relaxed call styles (only if OSX.relaxed_syntax == true)
      #   as Ruby:   self.aaa_Bbb_Ccc (a0, a1, a2)
      #   as Ruby:   self.aaa (a0, :Bbb, a1, :Ccc, a2)
      #   as Ruby:   self.aaa (a0, :Bbb => a1, :Ccc => a2)
      if OSX.relaxed_syntax
        if (m_args.size == 2) && (not m_name.include?('_')) && m_args[1].is_a?(Hash) && (m_args[1].size >= 1) then
          # Parse the inline Hash case.
          mname = m_name.dup
          args = []
          args << m_args[0]
          if m_args[1].size == 1
            m_args[1].each do |key, val|
              mname << "_#{key}"
              args << val
            end
          else
            # FIXME: do some caching here
            self.objc_methods.each do |sel|
              selname, *selargs = sel.split(/:/)
              if selname == m_name and selargs.all? { |selarg| m_args[1].has_key?(selarg.to_sym) } then
                selargs.each do |selarg|
                  mname << "_#{selarg}"
                  args << m_args[1][selarg.to_sym]
                end
                break
              end
            end
          end
          m_name = "#{mname}_"
          m_args = args
        elsif (m_args.size >= 3) && ((m_args.size % 2) == 1) && (not m_name.include?('_')) then
          # Parse the symbol-value-symbol-value-... case.
          mname = m_name.dup
          args = []
          m_args.each_with_index do |val, index|
            if (index % 2) == 0 then
              args << val
            else
              mname << "_#{val.to_s}"
            end
          end
          m_name = "#{mname}_"
          m_args = args
        else
          m_name.sub!(/[^_:]$/, '\0_') if m_args.size > 0
        end
      end
      [ m_name, m_args, m_predicate ]
    end

  end

end				# module OSX
