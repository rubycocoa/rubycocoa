# -*- mode:ruby; indent-tabs-mode:nil -*-
#
#  oc_bundle_support.rb
#  RubyCocoa
#  $Id$
#
#  Copyright (c) 2007 FUJIMOTO Hisakuni

module OSX

  if not NSBundle.respondsToSelector?('_originalBundleForClass:') then
    NSBundle.objc_alias_class_method '_originalBundleForClass:', 'bundleForClass:'
    class NSBundle
      def NSBundle.bundleForClass(cls)
        OSX::NSClassFromString("NSObject") # some magic to suppress error,
                                           # i can't see why this effects.
        bdl = OSX::BundleSupport.bundle_for_class(cls)
        bdl ||= self._originalBundleForClass(cls)
        return bdl
      end
    end
    NSBundle.objc_class_method 'bundleForClass:', [:id, :class]
  end

  module BundleSupport
    @@bundles    = [] unless defined? @@bundles
    @@bundle_map = {} unless defined? @@bundle_map

    def do_with_bundle(bdl)
      _push_bundle!(bdl)
      yield(bdl)
    ensure
      _pop_bundle!
    end
    module_function :do_with_bundle

    def do_for_class(cls)
      do_with_bundle(OSX::NSBundle._originalBundleForClass(cls)) {|b| yield(b) }
    end
    module_function :do_for_class

    def bundle_for_class(cls)
      @@bundle_map[cls.__ocid__]
    end
    module_function :bundle_for_class

    def bind_class_with_current_bundle(cls)
      if bdl = _current_bundle then
        @@bundle_map[cls.__ocid__] = bdl
      end
    end
    module_function :bind_class_with_current_bundle

    private
    def self._push_bundle!(bdl) @@bundles.push(bdl) end
    def self._pop_bundle!;      @@bundles.pop  end
    def self._current_bundle;   @@bundles.last end
  end

end
