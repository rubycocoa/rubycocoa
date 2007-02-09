# -*- mode:ruby; indent-tabs-mode:nil -*-
#
#  oc_bundle_support.rb
#  RubyCocoa
#  $Id$
#
#  Copyright (c) 2007 FUJIMOTO Hisakuni

module OSX

  module BundleSupport

    def init_for_bundle
      bdl, prm = _current_bundle
      logger = Logger.new(bdl)
      logger.info("init_for_bundle ...")
      ret = yield(bdl, prm, logger)
      logger.info("init_for_bundle done.")
      ret
    rescue Exception => err
      logger.error(err)
      logger.info("init_for_bundle failed.")
      raise
    end
    module_function :init_for_bundle

    private
    class Logger
      def initialize(bdl)
        @bundle_name  = bdl.to_s.sub(/^.*<(.*)>.*$/,'\1').split('/').last
        @process_name = OSX::NSProcessInfo.processInfo.processName
      end

      def info(fmt, *args)
        OSX.NSLog("#{@bundle_name} (#{@process_name}): #{fmt % args}")
      end
      
      def error(err)
        info("*ERROR* - %s", err)
        err.backtrace.each { |s| info("    %s", s) }
      end
    end
  end

  def init_for_bundle
    BundleSupport.init_for_bundle { |*x| yield(*x) }
  end
  module_function :init_for_bundle

end
