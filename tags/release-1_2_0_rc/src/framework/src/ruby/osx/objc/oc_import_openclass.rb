# Copyright (c) 2006-2008, The RubyCocoa Project.
# Copyright (c) 2001-2006, FUJIMOTO Hisakuni.
# All Rights Reserved.
#
# RubyCocoa is free software, covered under either the Ruby's license or the 
# LGPL. See the COPYRIGHT file for more information.

require 'osx/objc/oc_import'

# The following code defines a new subclass of Object (Ruby's).
#
#      module OSX
#        class NSCocoaClass end
#      end
#
# This Object.inherited() replaces the subclass of Object class by 
# a Cocoa class from # OSX.ns_import.
#
class Object
  class <<self
    def _real_class_and_mod(klass)
      unless klass.ancestors.include?(OSX::Boxed)
        klassname = klass.name.to_s
        unless klassname.nil? || klassname.empty?
          if Object.included_modules.include?(OSX) and /::/.match(klassname).nil?
            [klassname, Object]
          elsif klassname[0..4] == 'OSX::' and (tokens = klassname.split(/::/)).size == 2 and klass.superclass != OSX::Boxed
            [tokens[1], OSX]
          end
        end
      end
    end

    alias _before_osx_inherited inherited
    def inherited(subklass)
      nsklassname, mod = _real_class_and_mod(subklass) 
      if nsklassname and (first_char = nsklassname[0]) >= ?A and first_char <= ?Z
        # remove Ruby's class
        mod.instance_eval { remove_const nsklassname.intern }
        begin
          klass = OSX.ns_import nsklassname.intern
          raise NameError if klass.nil?
          subklass = klass
        rescue NameError
          # redefine subclass (looks not a Cocoa class)
          mod.const_set(nsklassname, subklass)
        end
      end
      _before_osx_inherited(subklass)
    end

    def _register_method(sym, class_method)
      if self != Object
        nsklassname, mod = _real_class_and_mod(self)
        if nsklassname
          begin
            nsklass = OSX.const_get(nsklassname)
            raise NameError unless nsklass.ancestors.include?(OSX::NSObject)
            if class_method
              method = self.method(sym).unbind
              OSX.__rebind_umethod__(nsklass.class, method)
              nsklass.module_eval do 
                (class << self; self; end).instance_eval do 
                  define_method(sym, method)
                end
              end
            else
              method = self.instance_method(sym)
              OSX.__rebind_umethod__(nsklass, method)
              nsklass.module_eval do
                define_method(sym, method)
              end
            end
          rescue NameError
          end
        end
      end
    end

    alias _before_method_added method_added
    def method_added(sym)
      _register_method(sym, false)
      _before_method_added(sym)
    end

    alias _before_singleton_method_added singleton_method_added
    def singleton_method_added(sym)
      _register_method(sym, true)
      _before_singleton_method_added(sym)
    end

    def method_missing(symbol, *args)
      nsklassname, mod = _real_class_and_mod(self)
      if nsklassname
        begin
          nsklass = OSX.const_get(nsklassname)
          if nsklass.respond_to?(symbol)
            return nsklass.send(symbol, *args)
          end
        rescue NameError
        end
      end
      raise NoMethodError, "undefined method `#{symbol.to_s}' for #{self}"
    end
  end
end
