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

    def init_bundle(bdl)
      _push_bundle!(bdl)
      loginfo("init_bundle ...")
      yield(self)
    rescue Exception => err
      logerr(err)
    ensure
      loginfo("init_bundle done.")
      _pop_bundle!
    end
    module_function :init_bundle

    def init_bundle_for_class(cls)
      init_bundle(OSX::NSBundle._originalBundleForClass(cls)) {|*x| yield(*x) }
    end
    module_function :init_bundle_for_class

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

    def loginfo(fmt, *args)
      OSX.NSLog("#{_bundle_name} (#{_process_name}): #{fmt % args}")
    end
    module_function :loginfo

    def logerr(err)
      loginfo("*ERROR* - %s", err)
      err.backtrace.each { |s| loginfo("    %s", s) }
    end
    module_function :logerr

    private
    def self._push_bundle!(bdl) @@bundles.push(bdl) end
    def self._pop_bundle!;      @@bundles.pop  end
    def self._current_bundle;   @@bundles.last end

    def self._bundle_name
      if bdl = _current_bundle then
        bdl.to_s.sub(/^.*<(.*)>.*$/,'\1').split('/').last
      end
    end

    def self._process_name
      @@process_name ||= OSX::NSProcessInfo.processInfo.processName
    end
  end

  def init_bundle(bdl)
    BundleSupport.init_bundle(bdl) { |*x| yield(*x) }
  end
  module_function :init_bundle

  def init_bundle_for_class(cls)
    BundleSupport.init_bundle_for_class(cls) { |*x| yield(*x) }
  end
  module_function :init_bundle_for_class

end
