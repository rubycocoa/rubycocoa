#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
#
#  This program is free software.
#  You can distribute/modify this program under the terms of
#  the GNU Lesser General Public License version 2.
#

require 'osx_objc'

module OSX

  module NSArrayAttachment
    include Enumerable

    def each
      iter = self.objectEnumerator
      while obj = iter.nextObject do
	yield (obj)
      end
      self
    end

    def [] (index)
      index = self.count + index if index < 0
      self.objectAtIndex (index)
    end

    def []= (index, obj)
      index = self.count + index if index < 0
      self.replaceObjectAtIndex_withObject (index, obj)
      obj
    end

    def push (obj)
      self.addObject (obj)
    end

  end				# module NSArrayAttachment

  module NSDictionaryAttachment
    include Enumerable

    def each
      iter = self.keyEnumerator
      while key = iter.nextObject do
	yield (key, self.objectForKey (key))
      end
      self
    end

    def [] (key)
      self.objectForKey (key)
    end

    def []= (key, obj)
      self.setObject_forKey (obj, key)
      obj
    end

  end				# module NSDictionaryAttachment

end
