#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni
#

# This module adds syntax-suggar APIs on top of the Cocoa structures.
# This is mostly to preserve backward compatibility with previous versions
# of RubyCocoa where the C structures support was hardcoded in the bridge.
# Now structures are automatically handled via the metadata mechanism, but
# the API is not compatible with what we used to have.

class OSX::NSRect
  class << self
    alias_method :orig_new, :new
    def new(*args)
      origin, size = case args.size
      when 0
        [[0, 0], [0, 0]]
      when 2
        [args[0], args[1]]
      when 4
        [args[0..1], args[2..3]]
      else
        raise ArgumentError, "wrong number of arguments (#{args.size} for either 0, 2 or 4)"
      end
      origin = OSX::NSPoint.new(*origin) unless origin.is_a?(OSX::NSPoint)
      size = OSX::NSSize.new(*size) unless size.is_a?(OSX::NSSize)
      orig_new(origin, size)
    end
  end
  def x; origin.x; end
  def y; origin.y; end
  def width; size.width; end
  def height; size.height; end
  def to_a; [origin.to_a, size.to_a]; end
end

class OSX::NSRange
  class << self
    alias_method :orig_new, :new
    def new(*args)
      location, length = case args.size
      when 0
        [0, 0]
      when 1
        if args.first.is_a?(Range)
          rng = args.first
          [rng.first, rng.last - rng.first + (rng.exclude_end? ? 0 : 1)]
        else
          raise ArgumentError, "wrong type of argument #1 (expected Range, got #{args.first.class})"
        end
      when 2
        [args[0], args[1]]
      else 
        raise ArgumentError, "wrong number of arguments (#{args.size} for either 0, 1 or 2)"
      end
      orig_new(location, length)
    end
  end
  def to_range
    Range.new(location, location + length - 1)
  end
end
