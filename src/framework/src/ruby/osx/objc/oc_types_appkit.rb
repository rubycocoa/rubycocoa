#
#  $Id: oc_types.rb 1270 2006-12-10 17:20:00Z lrz $
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni
#

# Same as oc_types but AppKit-specific.

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
