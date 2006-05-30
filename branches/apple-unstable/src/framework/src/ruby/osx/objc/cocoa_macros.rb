#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni
#

require 'nkf'

module OSX

  # from NSBundle
  def NSLocalizedString (key, comment = nil)
    OSX::NSBundle.mainBundle.
      localizedStringForKey_value_table(key, "", nil)
  end
  def NSLocalizedStringFromTable (key, tbl, comment = nil)
    OSX::NSBundle.mainBundle.
      localizedStringForKey_value_table(key, "", tbl)
  end
  def NSLocalizedStringFromTableInBundle (key, tbl, bundle, comment = nil)
    bundle.localizedStringForKey_value_table(key, "", tbl)
  end
  module_function :NSLocalizedStringFromTableInBundle
  module_function :NSLocalizedStringFromTable
  module_function :NSLocalizedString

  # for NSData
  ns_import :NSData
  class NSData

    def NSData.dataWithRubyString (str)
      NSData.dataWithBytes_length( str, str.size )
    end

  end

  # for NSMutableData
  ns_import :NSMutableData
  class NSMutableData

    def NSMutableData.dataWithRubyString (str)
      NSMutableData.dataWithBytes_length( str, str.size )
    end

  end

  # for NSString
  ns_import :NSString
  class NSString

    def NSString.guess_nsencoding(rbstr)
      case NSString.guess_encoding(rbstr)
      when NKF::JIS then NSISO2022JPStringEncoding
      when NKF::EUC then NSJapaneseEUCStringEncoding
      when NKF::SJIS then NSShiftJISStringEncoding
      else NSProprietaryStringEncoding
      end
    end

    def NSString.guess_encoding(rbstr)
      NKF.guess(rbstr)
    end

    # NKF.guess fails on ruby-1.8.2
    if NKF.respond_to?('guess1') && NKF::NKF_VERSION == "2.0.4"
      def NSString.guess_encoding(rbstr)
        NKF.guess1(rbstr)
      end
    end

    def NSString.stringWithRubyString (str)
      data = NSData.dataWithRubyString( str )
      enc = guess_nsencoding( str )
      NSString.alloc.initWithData_encoding( data, enc )
    end

  end

  # for NSMutableString
  ns_import :NSMutableString
  class NSMutableString
    def NSMutableString.stringWithRubyString (str)
      data = NSData.dataWithRubyString( str )
      enc = NSString.guess_nsencoding( str )
      NSMutableString.alloc.initWithData_encoding( data, enc )
    end
  end

  # for NSApplication
  ns_import :NSApplication
  class NSApplication 
    
    def NSApplication.run_with_temp_app(terminate = true, &proc)
      # prepare delegate
      delegate = Class.new(OSX::NSObject).alloc.init
      def delegate.applicationDidFinishLaunching(sender)
	begin
	  @proc.call
	rescue Exception => err
	  $stderr.puts "#{err.message} (#{err.class})"  
	  $stderr.puts err.backtrace.join("\n    ")
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
