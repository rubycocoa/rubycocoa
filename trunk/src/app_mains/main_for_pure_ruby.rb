#!/usr/bin/ruby

require 'osx/cocoa'
require 'osx/objc/application'

module OSX
  class RubyCocoaAppConfig

    DEFAULT_RUBY_PROGRAM = "/usr/bin/ruby"
    DEFAULT_MAIN_SCRIPT = "rb_main.rb"

    attr_reader :ruby_program, :main_script

    def initialize
      bundle = OSX::NSBundle.mainBundle
      dic = bundle.objectForInfoDictionaryKey "RubyAppConfig"

      # main script path
      nspath = nil
      if dic.nil? then
	# default ruby program 
	@ruby_program = DEFAULT_RUBY_PROGRAM
	# default main script path
	nspath = bundle.pathForResource_ofType (DEFAULT_MAIN_SCRIPT, nil)
      else
	dic.extend RCDictionaryAttachment
	# ruby program 
	@ruby_program = dic["RubyProgram"]
	# main script path
	nsstr = dic["MainScript"]
	exit_with_msg ("config error: MainScript missing.") if nsstr.nil?
	nspath = bundle.pathForResource_ofType (nsstr, nil)
      end
      exit_with_msg ("config error: path of MainScript missing.") if nspath.nil?
      @main_script = nspath.to_s

    end

    private
    def exit_with_msg (msg)
      $stderr.puts "#{__FILE__}: #{msg}"
      exit 1
    end

  end
end

conf = OSX::RubyCocoaAppConfig.new
load (conf.main_script)
