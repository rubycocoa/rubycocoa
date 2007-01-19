#
#  $Id: cocoa_macros.rb 1342 2007-01-05 00:16:09Z lrz $
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni
#

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
