# Copyright (c) 2006-2007, The RubyCocoa Project.
# Copyright (c) 2001-2006, FUJIMOTO Hisakuni.
# All Rights Reserved.
#
# RubyCocoa is free software, covered under either the Ruby's license or the 
# LGPL. See the COPYRIGHT file for more information.

require 'osx/objc/oc_wrapper'

module OSX

  # Enumerable module for NSValue types
  module NSEnumerable
    include Enumerable
    
    def grep(pattern)
      result = OSX::NSMutableArray.array
      if block_given?
        each {|i| result.addObject(yield(i)) if pattern === i }
      else
        each {|i| result.addObject(i) if pattern === i }
      end
      result
    end
    
    def map
      result = OSX::NSMutableArray.array
      each {|i| result.addObject(yield(i)) }
      result
    end
    alias_method :collect, :map
    
    def select
      result = OSX::NSMutableArray.array
      each {|i| result.addObject(i) if yield(i) }
      result
    end
    alias_method :find_all, :select
    
    def partition
      selected = OSX::NSMutableArray.array
      others = OSX::NSMutableArray.array
      each do |i|
        if yield(i)
          selected.addObject(i)
        else
          others.addObject(i)
        end
      end
      OSX::NSMutableArray.arrayWithArray([selected, others])
    end
    
    def reject
      result = OSX::NSMutableArray.array
      each {|i| result.addObject(i) unless yield(i) }
      result
    end
    
    def sort(&block)
      OSX::NSMutableArray.arrayWithArray(to_a.sort(&block))
    end
    
    def sort_by
      map {|i| [yield(i),i] }.
      sort {|a,b| a[0] <=> b[0] }.
      map! {|i| i[1] }
    end
    
    def zip(*args)
      if block_given?
        each_with_index do |obj,n|
          cur = OSX::NSMutableArray.array
          [self, *args].each {|i| cur.addObject(i[n]) }
          yield(cur)
        end
        nil
      else
        result = OSX::NSMutableArray.array
        each_with_index do |obj,n|
          cur = OSX::NSMutableArray.array
          [self, *args].each {|i| cur.addObject(i[n]) }
          result.addObject(cur)
        end
        result
      end
    end
  end

  # NSString additions
  class NSString
    include OSX::OCObjWrapper

    def dup
      mutableCopy
    end
    
    def clone
      obj = dup
      obj.freeze if frozen?
      obj.taint if tainted?
      obj
    end
    
    # enable to treat as String
    def to_str
      self.to_s
    end

    # comparison between Ruby String and Cocoa NSString
    def ==(other)
      if other.is_a? OSX::NSString
        isEqualToString?(other)
      elsif other.respond_to? :to_str
        self.to_s == other.to_str
      else
        false
      end
    end

    def <=>(other)
      if other.respond_to? :to_str
        self.to_str <=> other.to_str
      else
        nil
      end
    end

    def inspect
      "#<#{self.class.to_s.gsub(/^OSX::/, '')} \"#{self.to_s}\">"
    end

    # responds to Ruby String methods
    alias_method :_rbobj_respond_to?, :respond_to?
    def respond_to?(mname, private = false)
      String.public_method_defined?(mname) or _rbobj_respond_to?(mname, private)
    end

    alias_method :objc_method_missing, :method_missing
    def method_missing(mname, *args, &block)
      ## TODO: should test "respondsToSelector:"
      if String.public_method_defined?(mname) && (mname != :length)
        # call as Ruby string
        rcv = to_s
        org_val = rcv.dup
        result = rcv.send(mname, *args, &block)
        if result.__id__ == rcv.__id__
          result = self
        end
        # bang methods modify receiver itself, need to set the new value.
        # if the receiver is immutable, NSInvalidArgumentException raises.
        if rcv != org_val
          setString(rcv)
        end
      else
        # call as objc string
        result = objc_method_missing(mname, *args)
      end
      result
    end
    
    # For NSString duck typing

    def [](*args)
      count = length
      case args.length
      when 1
        first = args.first
        case first
        when Numeric,OSX::NSNumber
          n = first.to_i
          n += count if n < 0
          if 0 <= n && n < count
            characterAtIndex(n)
          else
            nil
          end
        when String,OSX::NSString
          str = first.to_s
          if include?(str)
            OSX::NSMutableString.stringWithString(str)
          else
            nil
          end
        #when Regexp
        when Range
          range = first
          n = range.first
          n += count if n < 0
          if n < 0 || count < n
            return nil
          end
          last = range.last
          last += count if last < 0
          last -= 1 if range.exclude_end?
          len = last - n + 1
          len = 0 if len < 0
          len = count - n if count < n + len

          if 0 <= n && n < count
            nsrange = OSX::NSRange.new(n, len)
            substringWithRange(nsrange).mutableCopy
          elsif n == count
            OSX::NSMutableString.string
          else
            nil
          end
        else
          raise TypeError, "can't convert #{first.class} into Integer"
        end
      when 2
        first, second = args
        case first
        when Numeric,OSX::NSNumber
          unless second.is_a?(Numeric) || second.is_a?(OSX::NSNumber)
            raise TypeError, "can't convert #{second.class} into Integer"
          end
          n, len = first.to_i, second.to_i
          n += count if n < 0
          if n < 0 || count < n
            nil
          elsif len < 0
            nil
          else
            self[n...n+len]
          end
        #when Regexp
        else
          raise TypeError, "can't convert #{first.class} into Integer"
        end
      else
        raise ArgumentError, "wrong number of arguments (#{args.length} for 2)"
      end
    end
    
    def []=(*args)
      count = length
      case args.length
      when 2
        first, second = args
        case first
        when Numeric,OSX::NSNumber
          n = first.to_i
          n += count if n < 0
          if n < 0 || count <= n
            raise IndexError, "index #{first.to_i} out of string"
          end
          self[n..n] = second
        when String,OSX::NSString
          str = first
          str = str.to_ns if str.is_a?(String)
          n = index(str)
          unless n
            raise IndexError, "string not matched"
          end
          self[n...n+str.length] = second
        when Range
          range = first
          n = range.first
          n += count if n < 0
          if n < 0 || count < n
            raise RangeError, "#{range} out of range"
          end
          last = range.last
          last += count if last < 0
          last -= 1 if range.exclude_end?
          len = last - n + 1
          len = 0 if len < 0
          
          value = second
          case value
          when Numeric,OSX::NSNumber
            str = OSX::NSString.stringWithFormat("%C", value.to_i)
            setString(self[0...n] + str + (self[n+len...count] || ''))
          when String,OSX::NSString
            setString(self[0...n] + value + (self[n+len...count] || ''))
          else
            raise TypeError, "can't convert #{val.class} into String"
          end
          value
          
        #when Regexp
        else
          raise TypeError, "can't convert #{first.class} into Integer"
        end
      when 3
        first = args.first
        case first
        when Numeric,OSX::NSNumber
          n, len, value = args
          unless len.is_a?(Numeric) || len.is_a?(OSX::NSNumber)
            raise TypeError, "can't convert #{len.class} into Integer"
          end
          n = n.to_i
          len = len.to_i
          n += count if n < 0
          if n < 0 || count < n
            raise IndexError, "index #{first.to_i} out of string"
          end
          if len < 0
            raise IndexError, "negative length (#{len})"
          end
          self[n...n+len] = value
          value
          
        #when Regexp
        else
          raise TypeError, "can't convert #{first.class} into Integer"
        end
      else
        raise ArgumentError, "wrong number of arguments (#{args.length} for 3)"
      end
    end

    def *(times)
      unless times.is_a?(Numeric) || times.is_a?(OSX::NSNumber)
        raise TypeError, "can't convert #{times.class} into Integer"
      end
      i = times.to_i
      s = OSX::NSMutableString.string
      times.times { s.appendString(self) }
      s
    end

    def +(other)
      unless other.is_a?(String) || other.is_a?(OSX::NSString)
        raise TypeError, "can't convert #{other.class} into String"
      end
      s = mutableCopy
      s.appendString(other)
      s
    end
    
    def <<(other)
      case other
      when Numeric,OSX::NSNumber
        i = other.to_i
        if 0 <= i && i < 65536
          appendString(OSX::NSString.stringWithFormat("%C", i))
        else
          raise TypeError, "can't convert #{other.class} into String"
        end
      when String,OSX::NSString
        appendString(other)
      else
        raise TypeError, "can't convert #{other.class} into String"
      end
      self
    end
    alias_method :concat, :<<
    
    def capitalize
      if length > 0
        self[0..0].upcase + self[1..-1].downcase
      else
        OSX::NSMutableString.string
      end
    end
    
    def capitalize!
      s = capitalize
      if self != s
        setString(s)
        self
      else
        nil
      end
    end
    
    def chomp(rs=$/)
      return mutableCopy unless rs
      if rs.empty?
        prev = self
        while prev != (s = prev.chomp)
          prev = s
        end
        s
      else
        if rs == "\n"
          if end_with?("\r\n")
            self[0...length-2]
          elsif end_with?("\n")
            self[0...length-1]
          elsif end_with?("\r")
            self[0...length-1]
          else
            mutableCopy
          end
        else
          if end_with?(rs)
            self[0...length-rs.to_ns.length]
          else
            mutableCopy
          end
        end
      end
    end
    
    def chomp!(rs=$/)
      s = chomp(rs)
      if self != s
        setString(s)
        self
      else
        nil
      end
    end
    
    def chop
      len = length
      if len == 0
        OSX::NSMutableString.string
      elsif hasSuffix("\r\n")
        self[0...len-2]
      else
        self[0...len-1]
      end
    end
    
    def chop!
      s = chop
      if self != s
        setString(s)
        self
      else
        nil
      end
    end
    
    def chr
      if empty?
        OSX::NSMutableString.string
      else
        self[0..0]
      end
    end
    
    def clear
      setString('')
      self
    end
    
    def downcase
      lowercaseString.mutableCopy
    end
    
    def downcase!
      s = lowercaseString
      if self != s
        setString(lowercaseString)
        self
      else
        nil
      end
    end
    
    def each(rs=$/)
      if rs == nil
        yield mutableCopy
      else
        length = self.length
        pos = 0
        if rs.empty?
          paragraph_mode = true
          sep = ($/*2).to_ns
          lf = $/.to_ns
        else
          paragraph_mode = false
          sep = rs.to_ns
        end
        
        loop do
          break if length <= pos
          n = index(sep, pos)
          unless n
            yield self[pos..-1]
            return
          end
          len = sep.length
          if paragraph_mode
            loop do
              start = n + len
              break if self[start,lf.length] != lf
              len += lf.length
            end
          end
          yield self[pos...n+len]
          pos = n + len
        end
      end
      self
    end
    alias_method :each_line, :each
    
    def empty?
      length == 0
    end
    
    def end_with?(str)
      hasSuffix(str)
    end
    
    def include?(str)
      index(str) != nil
    end
    
    def index(pattern, pos=0)
      case pattern
      when Numeric,OSX::NSNumber
        i = pattern.to_i
        if 0 <= i && i < 65536
          s = OSX::NSString.stringWithFormat("%C", i)
        else
          return nil
        end
      when String,OSX::NSString
        s = pattern
      #when Regexp
      else
        raise TypeError, "can't convert #{pattern.class} into String"
      end
      
      if s.empty?
        0
      else
        len = length
        n = pos.to_i
        n += len if n < 0
        if n < 0 || len <= n
          return nil
        end
        range = rangeOfString_options_range(s, 0, OSX::NSRange.new(n, len - n))
        if range.location == OSX::NSNotFound
          nil
        else
          range.location
        end
      end
    end
    
    def intern
      to_s.intern
    end
    alias_method :to_sym, :intern
    
    def lines
      result = OSX::NSMutableArray.array
      each {|i| result << i }
      result
    end
    
    def size
      length
    end
    
    def start_with?(str)
      hasPrefix(str)
    end
    
    def to_f
      doubleValue
    end
    
    def to_i
      intValue
    end
    
    def upcase
      uppercaseString.mutableCopy
    end
    
    def upcase!
      s = uppercaseString
      if self != s
        setString(uppercaseString)
        self
      else
        nil
      end
    end

  end

  # NSArray additions
  class NSArray
    include OSX::OCObjWrapper

    def dup
      mutableCopy
    end
    
    def clone
      obj = dup
      obj.freeze if frozen?
      obj.taint if tainted?
      obj
    end

    # enable to treat as Array
    def to_ary
      to_a
    end

    # comparison between Ruby Array and Cocoa NSArray
    def ==(other)
      if other.is_a? OSX::NSArray
        isEqualToArray?(other)
      elsif other.respond_to? :to_ary
        to_a == other.to_ary
      else
        false
      end
    end

    def <=>(other)
      if other.respond_to? :to_ary
        to_a <=> other.to_ary
      else
        nil
      end
    end

    # responds to Ruby String methods
    alias_method :_rbobj_respond_to?, :respond_to?
    def respond_to?(mname, private = false)
      Array.public_method_defined?(mname) or _rbobj_respond_to?(mname, private)
    end

    alias_method :objc_method_missing, :method_missing
    def method_missing(mname, *args, &block)
      ## TODO: should test "respondsToSelector:"
      if Array.public_method_defined?(mname)
        # call as Ruby array
        rcv = to_a
        org_val = rcv.dup
        result = rcv.send(mname, *args, &block)
        if result.__id__ == rcv.__id__
          result = self
        end
        # bang methods modify receiver itself, need to set the new value.
        # if the receiver is immutable, NSInvalidArgumentException raises.
        if rcv != org_val
          setArray(rcv)
        end
      else
        # call as objc array
        result = objc_method_missing(mname, *args)
      end
      result
    end

    # For NSArray duck typing
    
    def each
      iter = objectEnumerator
      while obj = iter.nextObject
        yield(obj)
      end
      self
    end

    def reverse_each
      iter = reverseObjectEnumerator
      while obj = iter.nextObject
        yield(obj)
      end
      self
    end

    def [](*args)
      _read_impl(:[], args)
    end

    def []=(*args)
      count = self.count
      case args.length
      when 2
        case args.first
        when Numeric
          n, value = args
          unless n.is_a?(Numeric) || n.is_a?(OSX::NSNumber)
            raise TypeError, "can't convert #{n.class} into Integer"
          end
          if value == nil
            raise ArgumentError, "attempt insert nil to NSArray"
          end
          n = n.to_i
          n += count if n < 0
          if 0 <= n && n < count
            replaceObjectAtIndex_withObject(n, value)
          elsif n == count
            addObject(value)
          else
            raise IndexError, "index #{args[0]} out of array"
          end
          value
        when Range
          range, value = args
          n = range.first
          n += count if n < 0
          if n < 0 || count < n
            raise RangeError, "#{range} out of range"
          end
          last = range.last
          last += count if last < 0
          last -= 1 if range.exclude_end?
          len = last - n + 1
          len = 0 if len < 0
          len = count - n if count < n + len
          
          if 0 <= n && n < count
            if len > 0
              removeObjectsInRange(OSX::NSRange.new(n, len))
            end
            if value != nil
              if value.is_a?(Array) || value.is_a?(OSX::NSArray)
                unless value.empty?
                  indexes = OSX::NSIndexSet.indexSetWithIndexesInRange(NSRange.new(n, value.length))
                  insertObjects_atIndexes(value, indexes)
                end
              else
                insertObject_atIndex(value, n)
              end
            end
          else
            if value != nil
              if value.is_a?(Array) || value.is_a?(OSX::NSArray)
                unless value.empty?
                  addObjectsFromArray(value)
                end
              else
                addObject(value)
              end
            end
          end
          args[1]
        else
          raise ArgumentError, "wrong number of arguments (#{args.length} for 3)"
        end
      when 3
        n, len, value = args
        unless n.is_a?(Numeric) || n.is_a?(OSX::NSNumber)
          raise TypeError, "can't convert #{n.class} into Integer"
        end
        unless len.is_a?(Numeric) || len.is_a?(OSX::NSNumber)
          raise TypeError, "can't convert #{len.class} into Integer"
        end
        n = n.to_i
        len = len.to_i
        n += count if n < 0
        if n < 0 || count < n
          raise IndexError, "index #{args[0]} out of array"
        end
        if len < 0
          raise IndexError, "negative length (#{len})"
        end
        self[n...n+len] = value
        value
      else
        raise ArgumentError, "wrong number of arguments (#{args.length} for 3)"
      end
    end

    def <<(obj)
      addObject(obj)
      self
    end

    def &(other)
      ary = other
      unless ary.is_a?(Array) || ary.is_a?(OSX::NSArray)
        if ary.respond_to?(:to_ary)
          ary = ary.to_ary
          unless ary.is_a?(Array) || ary.is_a?(OSX::NSArray)
            raise TypeError, "can't convert #{other.class} into Array"
          end
        else
          raise TypeError, "can't convert #{other.class} into Array"
        end
      end
      result = OSX::NSMutableArray.array
      dic = OSX::NSMutableDictionary.dictionary
      each {|i| dic.setObject_forKey(i, i) }
      ary.each do |i|
        if dic.objectForKey(i)
          result.addObject(i)
          dic.removeObjectForKey(i)
        end
      end
      result
    end

    def |(other)
      ary = other
      unless ary.is_a?(Array) || ary.is_a?(OSX::NSArray)
        if ary.respond_to?(:to_ary)
          ary = ary.to_ary
          unless ary.is_a?(Array) || ary.is_a?(OSX::NSArray)
            raise TypeError, "can't convert #{other.class} into Array"
          end
        else
          raise TypeError, "can't convert #{other.class} into Array"
        end
      end
      result = OSX::NSMutableArray.array
      dic = OSX::NSMutableDictionary.dictionary
      [self, ary].each do |obj|
        obj.each do |i|
          unless dic.objectForKey(i)
            dic.setObject_forKey(i, i)
            result.addObject(i)
          end
        end
      end
      result
    end

    def *(arg)
      case arg
      when Numeric
        OSX::NSMutableArray.arrayWithArray(to_a * arg)
      when String
        join(arg)
      else
        raise TypeError, "can't convert #{arg.class} into Integer"
      end
    end

    def +(other)
      ary = other
      unless ary.is_a?(Array) || ary.is_a?(OSX::NSArray)
        if ary.respond_to?(:to_ary)
          ary = ary.to_ary
          unless ary.is_a?(Array) || ary.is_a?(OSX::NSArray)
            raise TypeError, "can't convert #{other.class} into Array"
          end
        else
          raise TypeError, "can't convert #{other.class} into Array"
        end
      end
      result = mutableCopy
      result.addObjectsFromArray(other)
      result
    end

    def -(other)
      ary = other
      unless ary.is_a?(Array) || ary.is_a?(OSX::NSArray)
        if ary.respond_to?(:to_ary)
          ary = ary.to_ary
          unless ary.is_a?(Array) || ary.is_a?(OSX::NSArray)
            raise TypeError, "can't convert #{other.class} into Array"
          end
        else
          raise TypeError, "can't convert #{other.class} into Array"
        end
      end
      result = OSX::NSMutableArray.array
      dic = OSX::NSMutableDictionary.dictionary
      ary.each {|i| dic.setObject_forKey(i, i) }
      each {|i| result.addObject(i) unless dic.objectForKey(i) }
      result
    end

    def assoc(key)
      each do |i|
        if i.is_a? OSX::NSArray
          unless i.empty?
            return i if i.first.isEqual(key)
          end
        end
      end
      nil
    end

    def at(pos)
      self[pos]
    end

    def clear
      removeAllObjects
      self
    end

    def collect!
      copy.each_with_index {|i,n| replaceObjectAtIndex_withObject(n, yield(i)) }
      self
    end
    alias_method :map!, :collect!

    # does nothing because NSArray cannot have nil
    def compact; mutableCopy; end
    def compact!; nil; end

    def concat(other)
      addObjectsFromArray(other)
      self
    end

    def delete(val)
      indexes = OSX::NSMutableIndexSet.indexSet
      each_with_index {|i,n| indexes.addIndex(n) if i.isEqual(val) }
      removeObjectsAtIndexes(indexes) if indexes.count > 0
      if block_given?
        yield
      elsif indexes.count > 0
        val
      else
        nil
      end
    end

    def delete_at(pos)
      unless pos.is_a? Numeric
        raise TypeError, "can't convert #{pos.class} into Integer"
      end
      count = self.count
      pos = pos.to_i
      pos += count if pos < 0
      if 0 <= pos && pos < count
        result = self[pos]
        removeObjectAtIndex(pos)
        result
      else
        nil
      end
    end

    def delete_if(&block)
      reject!(&block)
      self
    end

    def reject!
      indexes = OSX::NSMutableIndexSet.alloc.init
      each_with_index {|i,n| indexes.addIndex(n) if yield(i) }
      if indexes.count > 0
        removeObjectsAtIndexes(indexes)
        self
      else
        nil
      end
    end

    def each_index
      each_with_index {|i,n| yield(n) }
    end

    def empty?
      count == 0
    end

    def fetch(*args)
      count = self.count
      len = args.length
      if len == 0 || len > 2
        raise ArgumentError, "wrong number of arguments (#{len} for 2)"
      end
      index = args.first
      unless index.is_a? Numeric
        raise TypeError, "can't convert #{index.class} into Integer"
      end
      index = index.to_i
      index += count if index < 0
      if 0 <= index && index < count
        objectAtIndex(index)
      else
        if len == 2
          args[1]
        elsif block_given?
          yield
        else
          raise IndexError, "index #{args.first} out of array"
        end
      end
    end

    def fill(*args)
      count = self.count
      len = args.length
      len -= 1 unless block_given?
      case len
      when 0
        val = args.first
        n = -1
        map! do |i|
          n += 1
          block_given? ? yield(n) : val
        end
      when 1
        if block_given?
          first = args.first
        else
          val, first = args
        end
        case first
        when Numeric
          start = first.to_i
          start += count if start < 0
          n = -1
          map! do |i|
            n += 1
            if start <= n
              block_given? ? yield(n) : val
            else
              i
            end
          end
        when Range
          range = first
          left = range.first
          right = range.last
          left += count if left < 0
          right += count if right < 0
          right += range.exclude_end? ? 0 : 1
          if left < 0 || count < left
            raise RangeError, "#{range} out of range"
          end
          n = -1
          map! do |i|
            n += 1
            if left <= n && n < right
              block_given? ? yield(n) : val
            else
              i
            end
          end
          (n+1).upto(right-1) do |i|
            n += 1
            addObject(block_given? ? yield(n) : val)
          end
          self
        else
          raise TypeError, "can't convert #{first.class} into Integer"
        end
      when 2
        if block_given?
          first, len = args
        else
          val, first, len = args
        end
        start = first
        unless start.is_a? Numeric
          raise TypeError, "can't convert #{start.class} into Integer"
        end
        unless len.is_a? Numeric
          raise TypeError, "can't convert #{len.class} into Integer"
        end
        start = start.to_i
        len = len.to_i
        start += count if start < 0
        if start < 0 || count < start
          raise IndexError, "index #{first} out of array"
        end
        len = 0 if len < 0
        last = start + len
        n = -1
        map! do |i|
          n += 1
          if start <= n && n < last
            block_given? ? yield(n) : val
          else
            i
          end
        end
        (n+1).upto(last-1) do |i|
          n += 1
          addObject(block_given? ? yield(i) : val)
        end
        self
      else
        raise ArgumentError, "wrong number of arguments (#{args.length} for 2)"
      end
    end

    def first(n=nil)
      if n
        if n.is_a? Numeric
          len = n.to_i
          if len < 0
            raise ArgumentError, "negative array size (or size too big)"
          end
          self[0...n]
        else
          raise TypeError, "can't convert #{n.class} into Integer"
        end
      else
        self[0]
      end
    end

    def flatten
      result = OSX::NSMutableArray.array
      each do |i|
        if i.is_a? OSX::NSArray
          result.addObjectsFromArray(i.flatten)
        else
          result.addObject(i)
        end
      end
      result
    end

    def flatten!
      flat = true
      result = OSX::NSMutableArray.array
      each do |i|
        if i.is_a? OSX::NSArray
          flat = false
          result.addObjectsFromArray(i.flatten)
        else
          result.addObject(i)
        end
      end
      if flat
        nil
      else
        setArray(result)
        self
      end
    end

    def include?(val)
      index(val) != nil
    end

    def index(*args)
      if block_given?
        each_with_index {|i,n| return n if yield(i) }
      elsif args.length == 1
        val = args.first
        each_with_index {|i,n| return n if i.isEqual(val) }
      else
        raise ArgumentError, "wrong number of arguments (#{args.length} for 1)"
      end
      nil
    end

    def insert(n, *vals)
      if n  == -1
        push(*vals)
      else
        n += count + 1 if n < 0
        self[n, 0] = vals
      end
      self
    end

    def join(sep=$,)
      s = ''
      each do |i|
        s += sep if sep && !s.empty?
        if i == self
          s += '[...]'
        elsif i.is_a? OSX::NSArray
          s += i.join(sep)
        else
          s += i.to_s
        end
      end
      s
    end

    def last(n=nil)
      if n
        if n.is_a? Numeric
          len = n.to_i
          if len < 0
            raise ArgumentError, "negative array size (or size too big)"
          end
          if len == 0
            OSX::NSMutableArray.array
          elsif len >= count
            mutableCopy
          else
            self[(-len)..-1]
          end
        else
          raise TypeError, "can't convert #{n.class} into Integer"
        end
      else
        self[-1]
      end
    end

    def pack(template)
      to_ruby.pack(template)
    end

    def pop
      if count > 0
        result = lastObject
        removeLastObject
        result
      else
        nil
      end
    end

    def push(*args)
      case args.length
      when 0
        ;
      when 1
        addObject(args.first)
      else
        addObjectsFromArray(args)
      end
      self
    end

    def rassoc(key)
      each do |i|
        if i.is_a? OSX::NSArray
          if i.count >= 1
            return i if i[1].isEqual(key)
          end
        end
      end
      nil
    end

    def replace(another)
      setArray(another)
      self
    end

    def reverse
      OSX::NSMutableArray.arrayWithArray(to_a.reverse)
    end

    def reverse!
      setArray(to_a.reverse)
      self
    end

    def rindex(*args)
      if block_given?
        n = count
        reverse_each do |i|
          n -= 1
          return n if yield(i)
        end
      elsif args.length == 1
        val = args.first
        n = count
        reverse_each do |i|
          n -= 1
          return n if i.isEqual(val)
        end
      else
        raise ArgumentError, "wrong number of arguments (#{args.length} for 1)"
      end
      nil
    end

    def shift
      unless empty?
        result = objectAtIndex(0)
        removeObjectAtIndex(0)
        result
      else
        nil
      end
    end

    def size
      count
    end
    alias_method :length, :size
    alias_method :nitems, :size

    def slice(*args)
      self[*args]
    end

    def slice!(*args)
      _read_impl(:slice!, args)
    end

    def sort!(&block)
      setArray(to_a.sort(&block))
      self
    end

    def to_splat
      to_a
    end

    def transpose
      OSX::NSMutableArray.arrayWithArray(to_a.transpose)
    end

    def uniq
      result = OSX::NSMutableArray.array
      dic = OSX::NSMutableDictionary.dictionary
      each do |i|
        unless dic.has_key?(i)
          dic.setObject_forKey(i, i)
          result.addObject(i)
        end
      end
      result
    end

    def uniq!
      if empty?
        nil
      else
        dic = OSX::NSMutableDictionary.dictionary
        indexes = OSX::NSMutableIndexSet.indexSet
        each_with_index do |i,n|
          if dic.has_key?(i)
            indexes.addIndex(n)
          else
            dic.setObject_forKey(i, i)
          end
        end
        if indexes.count > 0
          removeObjectsAtIndexes(indexes)
          self
        else
          nil
        end
      end
    end

    def unshift(*args)
      if count == 0
        push(*args)
      else
        case args.length
        when 0
          ;
        when 1
          insertObject_atIndex(args.first, 0)
        else
          indexes = OSX::NSIndexSet.indexSetWithIndexesInRange(NSRange.new(0, args.length))
          insertObjects_atIndexes(args, indexes)
        end
        self
      end
    end

    def values_at(*indexes)
      result = OSX::NSMutableArray.array
      indexes.each {|i| result.addObject(self[i]) }
      result
    end
    alias_method :indexes, :values_at
    alias_method :indices, :values_at

    def inspect
      "#<#{self.class.to_s.gsub(/^OSX::/, '')} #{ self.to_a.inspect }>"
    end

    private

    def _read_impl(method, args)
      slice = method == :slice!
      count = self.count
      case args.length
      when 1
        first = args.first
        case first
        when Numeric,OSX::NSNumber
          n = first.to_i
          n += count if n < 0
          if 0 <= n && n < count
            result = objectAtIndex(n)
            removeObjectAtIndex(n) if slice
            result
          else
            nil
          end
        when Range
          range = first
          n = range.first
          n += count if n < 0
          if n < 0 || count < n
            if slice
              raise RangeError, "#{first} out of range"
            end
            return nil
          end
          last = range.last
          last += count if last < 0
          last -= 1 if range.exclude_end?
          len = last - n + 1
          len = 0 if len < 0
          len = count - n if count < n + len
          
          if 0 <= n && n < count
            nsrange = OSX::NSRange.new(n, len)
            indexes = OSX::NSIndexSet.indexSetWithIndexesInRange(nsrange)
            result = objectsAtIndexes(indexes).mutableCopy
            removeObjectsAtIndexes(indexes) if slice
            result
          else
            OSX::NSMutableArray.array
          end
        else
          raise TypeError, "can't convert #{args.first.class} into Integer"
        end
      when 2
        n, len = args
        unless n.is_a?(Numeric) || n.is_a?(OSX::NSNumber)
          raise TypeError, "can't convert #{n.class} into Integer"
        end
        unless len.is_a?(Numeric) || len.is_a?(OSX::NSNumber)
          raise TypeError, "can't convert #{len.class} into Integer"
        end
        n = n.to_i
        len = len.to_i
        if len < 0
          if slice
            raise IndexError, "negative length (#{args[1]})"
          end
          nil
        else
          n += count if n < 0
          if n < 0
            nil
          else
            _read_impl(method, [n...n+len])
          end
        end
      else
        raise ArgumentError, "wrong number of arguments (#{args.length} for 2)"
      end
    end
  end
  class NSArray
    include NSEnumerable
  end

  # NSDictionary additions
  class NSDictionary
    include OSX::OCObjWrapper

    def dup
      mutableCopy
    end
    
    def clone
      obj = dup
      obj.freeze if frozen?
      obj.taint if tainted?
      obj
    end
    
    # enable to treat as Hash
    def to_hash
      h = {}
      each {|k,v| h[k] = v }
      h
    end
    
    # comparison between Ruby Hash and Cocoa NSDictionary
    def ==(other)
      if other.is_a? OSX::NSDictionary
        isEqualToDictionary?(other)
      elsif other.respond_to? :to_hash
        to_hash == other.to_hash
      else
        false
      end
    end

    def <=>(other)
      if other.respond_to? :to_hash
        to_hash <=> other.to_hash
      else
        nil
      end
    end

    # responds to Ruby Hash methods
    alias_method :_rbobj_respond_to?, :respond_to?
    def respond_to?(mname, private = false)
      Hash.public_method_defined?(mname) or _rbobj_respond_to?(mname, private)
    end

    alias_method :objc_method_missing, :method_missing
    def method_missing(mname, *args, &block)
      ## TODO: should test "respondsToSelector:"
      if Hash.public_method_defined?(mname)
        # call as Ruby hash
        rcv = to_hash
        org_val = rcv.dup
        result = rcv.send(mname, *args, &block)
        if result.__id__ == rcv.__id__
          result = self
        end
        # bang methods modify receiver itself, need to set the new value.
        # if the receiver is immutable, NSInvalidArgumentException raises.
        if rcv != org_val
          setDictionary(rcv)
        end
      else
        # call as objc dictionary
        result = objc_method_missing(mname, *args)
      end
      result
    end
    
    # For NSDictionary duck typing
    def each
      iter = keyEnumerator
      while key = iter.nextObject
        yield([key, objectForKey(key)])
      end
      self
    end

    def each_pair
      iter = keyEnumerator
      while key = iter.nextObject
        yield(key, objectForKey(key))
      end
      self
    end

    def each_key
      iter = keyEnumerator
      while key = iter.nextObject
        yield(key)
      end
      self
    end

    def each_value
      iter = objectEnumerator
      while obj = iter.nextObject
        yield(obj)
      end
      self
    end

    def [](key)
      result = objectForKey(key)
      if result
        result
      else
        default(key)
      end
    end

    def []=(key, obj)
      setObject_forKey(obj, key)
      obj
    end
    alias_method :store, :[]=

    def clear
      removeAllObjects
      self
    end

    def default(*args)
      if args.length <= 1
        if @default_proc
          @default_proc.call(self, args.first)
        elsif @default
          @default
        else
          nil
        end
      else
        raise ArgumentError, "wrong number of arguments (#{args.length} for 2)"
      end
    end

    def default=(value)
      @default = value
    end

    def default_proc
      @default_proc
    end

    def default_proc=(value)
      @default_proc = value
    end

    def delete(key)
      obj = objectForKey(key)
      if obj
        removeObjectForKey(key)
        obj
      else
        if block_given?
          yield(key)
        else
          nil
        end
      end
    end

    def delete_if(&block)
      reject!(&block)
      self
    end

    def fetch(key, *args)
      result = objectForKey(key)
      if result
        result
      else
        if args.length > 0
          args.first
        elsif block_given?
          yield(key)
        else
          raise IndexError, "key not found"
        end
      end
    end

    def reject!
      keys = OSX::NSMutableArray.array
      each {|key,value| keys.addObject(key) if yield(key, value) }
      if keys.count > 0
        removeObjectsForKeys(keys)
        self
      else
        nil
      end
    end

    def empty?
      count == 0
    end

    def has_key?(key)
      objectForKey(key) != nil
    end
    alias_method :include?, :has_key?
    alias_method :key?, :has_key?
    alias_method :member?, :has_key?

    def has_value?(value)
      each_value {|i| return true if i.isEqual?(value) }
      false
    end
    alias_method :value?, :has_value?

    def invert
      result = {}
      each_pair {|key,value| result[value] = key }
      result
    end

    def key(val)
      each_pair {|key,value| return key if value.isEqual?(val) }
      nil
    end

    def keys
      allKeys
    end

    def merge(other, &block)
      dic = mutableCopy
      dic.merge!(other, &block)
      dic
    end

    def merge!(other)
      if block_given?
        other.each do |key,value|
          if mine = objectForKey(key)
            setObject_forKey(yield(key, mine, value),key)
          else
            setObject_forKey(value,key)
          end
        end
      else
        other.each {|key,value| setObject_forKey(value,key) }
      end
      self
    end
    alias_method :update, :merge!

    def shift
      if empty?
        default
      else
        key = allKeys.objectAtIndex(0)
        value = objectForKey(key)
        removeObjectForKey(key)
        OSX::NSMutableArray.arrayWithArray([key, value])
      end
    end

    def size
      count
    end
    alias_method :length, :size

    def rehash; self; end

    def reject(&block)
      to_hash.delete_if(&block)
    end

    def replace(other)
      setDictionary(other)
      self
    end

    def values
      allValues
    end

    def values_at(*args)
      result = OSX::NSMutableArray.array
      args.each do |k|
        if v = objectForKey(k)
          result.addObject(v)
        else
          result.addObject(default)
        end
      end
      result
    end
    
    def inspect
      "#<#{self.class.to_s.gsub(/^OSX::/, '')} #{ self.to_hash.inspect }>"
    end
  end
  class NSDictionary
    include NSEnumerable
  end

  class NSUserDefaults
    def [] (key)
      self.objectForKey(key)
    end

    def []= (key, obj)
      self.setObject_forKey(obj, key)
    end

    def delete (key)
      self.removeObjectForKey(key)
    end
  end

  # NSData additions
  class NSData
    def rubyString
      cptr = self.bytes
      return cptr.bytestr( self.length )
    end
  end

  # NSIndexSet additions
  class NSIndexSet
    def to_a
      result = []
      index = self.firstIndex
      until index == OSX::NSNotFound
        result << index
        index = self.indexGreaterThanIndex(index)
      end
      return result
    end
    
    def inspect
      "#<#{self.class.to_s.gsub(/^OSX::/, '')} #{ self.to_a.inspect }>"
    end
  end

  # NSEnumerator additions
  class NSEnumerator
    def to_a
      self.allObjects.to_a
    end
  end

  # NSNumber additions
  class NSNumber
    def to_i
      self.stringValue.to_s.to_i
    end

    def to_f
      self.floatValue
    end
    
    def float?
      OSX::CFNumberIsFloatType(self)
    end
    
    def ==(other)
      if other.is_a? NSNumber
        isEqualToNumber?(other)
      elsif other.is_a? Numeric
        if float?
          to_f == other
        else
          to_i == other
        end
      else
        false
      end
    end

    def <=>(other)
      if other.is_a? NSNumber
        compare(other)
      elsif other.is_a? Numeric
        if float?
          to_f <=> other
        else
          to_i <=> other
        end
      else
        nil
      end
    end
    
    def inspect
      "#<#{self.class.to_s.gsub(/^OSX::/, '')} #{self.description}>"
    end
  end

  # NSCFBoolean additions
  class NSCFBoolean
    def inspect
      "#<#{self.class.to_s.gsub(/^OSX::/, '')} #{ (self == 1) ? true : false }>"
    end
  end

  # NSDate additions
  class NSDate
    def to_time
      Time.at(self.timeIntervalSince1970)
    end
    def inspect
      "#<#{self.class.to_s.gsub(/^OSX::/, '')} #{self.description}>"
    end
  end

  # NSObject additions
  class NSObject
    def to_ruby
      case self 
      when OSX::NSDate
        self.to_time
      when OSX::NSCFBoolean
        self.boolValue
      when OSX::NSNumber
        self.float? ? self.to_f : self.to_i
      when OSX::NSString
        self.to_s
      when OSX::NSAttributedString
        self.string.to_s
      when OSX::NSArray
        self.to_a.map { |x| x.is_a?(OSX::NSObject) ? x.to_ruby : x }
      when OSX::NSDictionary
        h = {}
        self.each do |x, y| 
          x = x.to_ruby if x.is_a?(OSX::NSObject)
          y = y.to_ruby if y.is_a?(OSX::NSObject)
          h[x] = y
        end
        h
      else
        self
      end
    end
  end
end
