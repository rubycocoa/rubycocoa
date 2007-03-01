#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni
#

module OSX

  # NSArray additions
  class NSArray
    def each
      iter = self.objectEnumerator
      while obj = iter.nextObject do
        yield(obj)
      end
      self
    end

    def size
      self.count
    end

    def [] (index)
      index = self.count + index if index < 0
      self.objectAtIndex(index)
    end

    def []= (index, obj)
      index = self.count + index if index < 0
      self.replaceObjectAtIndex_withObject(index, obj)
      obj
    end

    def push (obj)
      self.addObject(obj)
    end
  end
  class NSArray
    include Enumerable
  end

  # NSDictionary additions
  class NSDictionary
    def each
      iter = self.keyEnumerator
      while key = iter.nextObject do
        yield(key, self.objectForKey(key))
      end
      self
    end

    def size
      self.count
    end

    def keys
      self.allKeys.to_a
    end

    def values
      self.allValues.to_a
    end

    def [] (key)
      self.objectForKey(key)
    end

    def []= (key, obj)
      self.setObject_forKey(obj, key)
      obj
    end
  end
  class NSDictionary
    include Enumerable
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
end
