#!/usr/bin/env ruby

# Created by Eloy Duran
# Copyright (c) 2007 Eloy Duran, SuperAlloy

require 'rbconfig'

def show_options
  puts "Usage:"
  puts "  #{__FILE__} build [options] <output dir>"
  puts ""
  puts "  build  Create the RDoc documentation for the supported frameworks"
  puts ''
  puts "Options:"
  puts "  The extra options only apply to 'build' option and are options passed"
  puts "  to the actual rdocify_framework.rb script."
  puts "  These are:"
  puts "  -v Verbose output."
  puts "  -f Force the output files to be written even if there were errors during parsing."
  puts ''
  puts "Output Dir:"
  puts "  If a optional output dir is specified,"
  puts "  the documentation will be generated in that location."
  puts ""
  puts "Examples:"
  puts "  #{__FILE__} build ~/documentation"
  puts "  #{__FILE__} build -v -f"
  puts ''
end

unless ARGV[0].nil?
  case ARGV[0]
  when 'build'
    options = []
    output_dir = ''
    
    # Check if there are any other args
    if ARGV.length > 1
      ARGV[1..-1].each do |arg|
        case arg
        when '-v'
          options.push '-v'
        when '-f'
          options.push '-f'
        else
          output_dir = arg
        end
      end
    end
    
    # Get a reference to the output dir and create it if necessary
    unless output_dir.empty?
      output_dir = File.expand_path(output_dir)
      unless File.exist?(output_dir)
        system "mkdir -p #{output_dir}"
      end
    else
      output_dir = File.join(File.expand_path(__FILE__), '../doc/')
    end
    
    SUPPORTED_FRAMEWORKS = ['/Developer/ADC Reference Library/documentation/Cocoa/Reference/ApplicationKit/',
                            '/Developer/ADC Reference Library/documentation/Cocoa/Reference/Foundation/',
                            '/Developer/ADC Reference Library/documentation/Cocoa/Reference/WebKit/',
                            '/Developer/ADC Reference Library/documentation/Cocoa/Reference/CoreDataFramework/',
                            '/Developer/ADC Reference Library/documentation/QuickTime/Reference/QTKitFramework/']
    #SUPPORTED_FRAMEWORKS = ['/Developer/ADC Reference Library/documentation/UserExperience/Reference/AddressBook/']
    #SUPPORTED_FRAMEWORKS = ['/Developer/ADC Reference Library/documentation/Cocoa/Reference/ApplicationKit/']
    start_time = Time.now

    # Parse the rdoc for each supported framework
    SUPPORTED_FRAMEWORKS.each do |f|
      system "#{Config::CONFIG["bindir"]}/ruby gen_bridge_doc/rdocify_framework.rb #{options.join(' ')} '#{f}' #{output_dir}/ruby"
    end

    # Create the rdoc files
    #system "rdoc  --line-numbers --inline-source --template gen_bridge_doc/allison/allison.rb gen_bridge_doc/output -o doc/html"
    system "rdoc #{output_dir}/ruby -o #{output_dir}/html"
    system "rdoc --ri #{output_dir}/ruby -o #{output_dir}/ri"
    
    puts ""
    puts "Total Cocoa Reference to RDoc processing time: #{Time.now - start_time} seconds"
  else
    show_options
    exit 1
  end
else
  show_options
  exit 1
end
