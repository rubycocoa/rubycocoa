#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni
#

module OSX

  # attachment module for NSArray group
  module RCArrayAttachment
    include Enumerable

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

  end                           # module RCArrayAttachment
  OSX::NSArray.class_eval 'include RCArrayAttachment'


  # attachment module for NSDictionary group
  module RCDictionaryAttachment
    include Enumerable

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

  end                           # module RCDictionaryAttachment
  OSX::NSDictionary.class_eval 'include RCDictionaryAttachment'


  # attachment module for NSData group
  module RCDataAttachment

    def rubyString
      cptr = self.bytes
      return cptr.bytestr( self.length )
    end

  end
  OSX::NSData.class_eval 'include RCDataAttachment'

  # attachment module for NSIndexSet group
  module RCIndexSetAttachment
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
  OSX::NSIndexSet.class_eval 'include RCIndexSetAttachment'

end
