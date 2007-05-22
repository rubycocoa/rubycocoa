# Copyright (c) 2006-2007, The RubyCocoa Project.
# Copyright (c) 2001-2006, FUJIMOTO Hisakuni.
# All Rights Reserved.
#
# RubyCocoa is free software, covered under either the Ruby's license or the 
# LGPL. See the COPYRIGHT file for more information.

require 'nkf'

module OSX

  # for NSApplication
  class NSApplication 
    
    def NSApplication.run_with_temp_app(terminate = true, &proc)
      # prepare delegate
      delegate = Class.new(OSX::NSObject).alloc.init
      def delegate.applicationDidFinishLaunching(sender)
	begin
	  @proc.call
	rescue Exception => err
	  warn "#{err.message} (#{err.class})\n"
	  warn err.backtrace.join("\n    ")
	ensure
	  OSX::NSApplication.sharedApplication.terminate(self) if @terminate
	end
      end
      def delegate.proc=(block)
	@proc = block
      end
      def delegate.terminate=(terminate)
	@terminate = terminate
      end
      delegate.proc = proc
      delegate.terminate = terminate
      # run a new app
      app = NSApplication.sharedApplication
      app.setDelegate(delegate)
      app.run
    end

  end

end
