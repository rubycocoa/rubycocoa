# Copyright (c) 2006-2007, The RubyCocoa Project.
# Copyright (c) 2001-2006, FUJIMOTO Hisakuni.
# All Rights Reserved.
#
# RubyCocoa is free software, covered under either the Ruby's license or the 
# LGPL. See the COPYRIGHT file for more information.

require 'osx/objc/oc_wrapper'

module OSX

  # NSString additions
  class NSString
    include OSX::OCObjWrapper

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

    # responds to Ruby String methods
    alias_method :_rbobj_respond_to?, :respond_to?
    def respond_to?(mname, private = false)
      String.public_method_defined?(mname) or _rbobj_respond_to?(mname, private)
    end

    alias_method :objc_method_missing, :method_missing
    def method_missing(mname, *args)
      ## TODO: should test "respondsToSelector:"
      if String.public_method_defined?(mname) && (mname != :length)
        # call as Ruby string
        rcv = self.to_s
        org_val = rcv.dup
        result = rcv.send(mname, *args)
        # bang methods modify receiver itself, need to set the new value.
        # if the receiver is immutable, NSInvalidArgumentException raises.
        if rcv != org_val
          self.setString(rcv)
        end
      else
        # call as objc string
        result = objc_method_missing(mname, *args)
      end
      result
    end
  end


  # NSArray additions
  class NSArray
    include OSX::OCObjWrapper

    def each
      iter = self.objectEnumerator
      while obj = iter.nextObject do
        yield(obj)
      end
      self
    end

    def [](*args)
      case args.length
      when 1
        count = self.count
        first = args.first
        case first
        when Numeric
          index = first.to_i
          index += count if index < 0
          if 0 <= index && index < count
            objectAtIndex(index)
          else
            nil
          end
        when Range
          range = OSX::NSRange.new(first, count)
          loc = range.location
          if 0 <= loc && loc < count
            indexset = OSX::NSIndexSet.indexSetWithIndexesInRange(range)
            result = objectsAtIndexes(indexset)
            result.to_a
          else
            nil
          end
        else
          raise TypeError, "can't convert #{args.first.class} into Integer"
        end
      when 2
        start, len = args
        unless start.is_a? Numeric
          raise TypeError, "can't convert #{start.class} into Integer"
        end
        unless len.is_a? Numeric
          raise TypeError, "can't convert #{len.class} into Integer"
        end
        start = start.to_i
        len = len.to_i
        if len < 0
          nil
        else
          range = start...(start + len)
          self[range]
        end
      else
        raise ArgumentError, "wrong number of arguments (#{args.length} for 2)"
      end
    end

    def []=(*args)
      case args.length
      when 2
        count = self.count
        case args.first
        when Numeric
          index, value = args
          unless index.is_a? Numeric
            raise TypeError, "can't convert #{index.class} into Integer"
          end
          if value == nil
            raise ArgumentError, "attempt insert nil to NSDictionary"
          end
          index = index.to_i
          index += count if index < 0
          if 0 <= index && index < count
            replaceObjectAtIndex_withObject(index, value)
          elsif index == count
            addObject(value)
          else
            raise IndexError, "index #{args[0]} out of array"
          end
          value
        when Range
          range, value = args
          nsrange = OSX::NSRange.new(range, count)
          loc = nsrange.location
          if 0 <= loc && loc < count
            if nsrange.length > 0
              removeObjectsInRange(nsrange)
            end
            value = value.to_a if value.is_a? NSArray
            if value != nil && value != []
              if value.is_a? Array
                index = loc
                value.each {|i| insertObject_atIndex(i, index); index += 1 }
              else
                insertObject_atIndex(value, loc)
              end
            end
          elsif loc == count
            value = value.to_a if value.is_a? NSArray
            if value != nil && value != []
              if value.is_a? Array
                addObjectsFromArray(value)
              else
                addObject(value)
              end
            end
          else
            raise IndexError, "index #{loc} out of array"
          end
          value
        else
          raise ArgumentError, "wrong number of arguments (#{args.length} for 3)"
        end
      when 3
        start, len, value = args
        unless start.is_a? Numeric
          raise TypeError, "can't convert #{start.class} into Integer"
        end
        unless len.is_a? Numeric
          raise TypeError, "can't convert #{len.class} into Integer"
        end
        start = start.to_i
        len = len.to_i
        if len < 0
          raise IndexError, "negative length (#{len})"
        else
          range = start...(start + len)
          self[range] = value
          value
        end
      else
        raise ArgumentError, "wrong number of arguments (#{args.length} for 3)"
      end
    end
    
    def +(other); to_a + other; end
    def *(times); to_a * times; end
    def -(other); to_a - other; end
    def &(other); to_a & other; end
    def |(other); to_a | other; end
    
    def <<(obj)
      addObject(obj)
      self
    end
    
    def assoc(key)
      each do |i|
        if i.is_a?(Array) || i.is_a?(NSArray)
          unless i.empty?
            val = i.first
            if val == key || val.is_a?(NSObject) && val.isEqual(key)
              return i.to_a
            end
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
    
    def collect!(*args, &block)
      setArray(collect(*args, &block))
      self
    end
    alias_method :map!, :collect!
    
    # does nothing because NSArray cannot have nil
    def compact; to_a; end
    def compact!; self; end
    
    def concat(other)
      addObjectsFromArray(other)
      self
    end
    
    def delete(val)
      set = OSX::NSMutableIndexSet.alloc.init
      each_with_index {|i,n| set.addIndex(n) if i.isEqual(val) }
      removeObjectsAtIndexes(set) if set.count > 0
      if block_given?
        yield
      elsif set.count > 0
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
      set = OSX::NSMutableIndexSet.alloc.init
      each_with_index {|i,n| set.addIndex(n) if yield(i) }
      if set.count > 0
        removeObjectsAtIndexes(set)
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

    def join(*args)
      to_ruby.join(*args)
    end

    def size
      count
    end
    alias_method :length, :size

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
    def method_missing(mname, *args)
      ## TODO: should test "respondsToSelector:"
      if Array.public_method_defined?(mname)
        # call as Ruby array
        rcv = to_a
        org_val = rcv.dup
        result = rcv.send(mname, *args)
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
  end
  class NSArray
    include Enumerable
  end

  # NSDictionary additions
  class NSDictionary
    include OSX::OCObjWrapper
    
    def each
      iter = self.keyEnumerator
      while key = iter.nextObject do
        yield(key, self.objectForKey(key))
      end
      self
    end
    
    def [](key)
      self.objectForKey(key)
    end

    def []=(key, obj)
      self.setObject_forKey(obj, key)
      obj
    end
    alias_method :store, :[]=

    def size
      self.count
    end
    alias_method :length, :size

    def keys
      self.allKeys.to_a
    end

    def values
      self.allValues.to_a
    end
    
    def clear
      self.removeAllObjects
      self
    end
    
    # enable to treat as Hash
    def to_hash
      h = {}
      self.each {|k,v| h[k] = v }
      h
    end
    
    # comparison between Ruby Hash and Cocoa NSDictionary
    def ==(other)
      if other.is_a? OSX::NSDictionary
        isEqualToDictionary?(other)
      elsif other.respond_to? :to_hash
        self.to_hash == other.to_hash
      else
        false
      end
    end

    def <=>(other)
      if other.respond_to? :to_hash
        self.to_hash <=> other.to_hash
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
    def method_missing(mname, *args)
      ## TODO: should test "respondsToSelector:"
      if Hash.public_method_defined?(mname)
        # call as Ruby hash
        rcv = self.to_hash
        org_val = rcv.dup
        result = rcv.send(mname, *args)
        # bang methods modify receiver itself, need to set the new value.
        # if the receiver is immutable, NSInvalidArgumentException raises.
        if rcv != org_val
          self.setDictionary(rcv)
        end
      else
        # call as objc dictionary
        result = objc_method_missing(mname, *args)
      end
      result
    end
  end
  class NSDictionary
    include Enumerable
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
  end

  # NSDate additions
  class NSDate
    def to_time
      Time.at(self.timeIntervalSince1970)
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
        OSX::CFNumberIsFloatType(self) ? self.to_f : self.to_i
      when OSX::NSString
        self.to_s
      when OSX::NSAttributedString
        self.string.to_s
      when OSX::NSArray
        self.map { |x| x.is_a?(OSX::NSObject) ? x.to_ruby : x }
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
