# Copyright (c) 2006-2007, The RubyCocoa Project.
# Copyright (c) 2001-2006, FUJIMOTO Hisakuni.
# All Rights Reserved.
#
# RubyCocoa is free software, covered under either the Ruby's license or the 
# LGPL. See the COPYRIGHT file for more information.

# This module adds syntax-sugar APIs on top of the Cocoa structures.
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
  alias_method :old_to_a, :to_a # To remove a warning.
  def to_a; [origin.to_a, size.to_a]; end
end
