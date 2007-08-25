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
      if args.length == 1
        index = args[0]
        if index.is_a? Numeric
          index = self.count + index if index < 0
          self.objectAtIndex(index)
        else
          method_missing(:[], *args)
        end
      else
        method_missing(:[], *args)
      end
    end

    def []=(*args)
      if args.length == 2
        index, obj = args
        if index.is_a? Numeric
          index = self.count + index if index < 0
          self.replaceObjectAtIndex_withObject(index, obj)
          obj
        else
          method_missing(:[]=, *args)
        end
      else
        method_missing(:[]=, *args)
      end
    end

    def size
      self.count
    end
    alias_method :length, :size
    
    def clear
      self.removeAllObjects
      self
    end

    def push(*args)
      case args.length
      when 0
        ;
      when 1
        self.addObject(args[0])
      else
        self.addObjectsFromArray(args)
      end
      self
    end
    
    def <<(obj)
      self.addObject(obj)
      self
    end

    # enable to treat as Array
    def to_ary
      self.to_a
    end

    # comparison between Ruby Array and Cocoa NSArray
    def ==(other)
      if other.is_a? OSX::NSArray
        isEqualToArray?(other)
      elsif other.respond_to? :to_ary
        self.to_a == other.to_ary
      else
        false
      end
    end

    def <=>(other)
      if other.respond_to? :to_ary
        self.to_a <=> other.to_ary
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
        rcv = self.to_a
        org_val = rcv.dup
        result = rcv.send(mname, *args)
        # bang methods modify receiver itself, need to set the new value.
        # if the receiver is immutable, NSInvalidArgumentException raises.
        if rcv != org_val
          self.setArray(rcv)
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
