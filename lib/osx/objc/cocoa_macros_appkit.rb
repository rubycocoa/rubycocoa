# Copyright (c) 2006-2008, The RubyCocoa Project.
# Copyright (c) 2001-2006, FUJIMOTO Hisakuni.
# All Rights Reserved.
#
# RubyCocoa is free software, covered under either the Ruby's license or the 
# LGPL. See the COPYRIGHT file for more information.

module OSX

  # Utility functions for NSApplication.
  class NSApplication

    # A delegate class in NSApplication.run_with_temp_app.
    # @api private
    class RBCCTemporaryDelegate < OSX::NSObject
      attr_writer :proc, :terminate

      def applicationDidFinishLaunching(sender)
	begin
	  @proc.call
	rescue Exception => err
	  warn "#{err.message} (#{err.class})\n"
	  warn err.backtrace.join("\n    ")
	ensure
	  OSX::NSApplication.sharedApplication.terminate(self) if @terminate
	end
      end

    end

    # Runs given block as a Cocoa application.
    # @param [Boolean] terminate Whether app terminates after done given block or not
    # @example
    #     OSX::NSApplication.run_with_temp_app do
    #         # do something
    #     end
    def NSApplication.run_with_temp_app(terminate = true, &proc)
      # prepare delegate
      delegate = RBCCTemporaryDelegate.alloc.init
      delegate.proc = proc
      delegate.terminate = terminate
      # run a new app
      app = NSApplication.sharedApplication
      app.setDelegate(delegate)
      app.run
    end

  end

end
