#!/usr/bin/env ruby

# Created by Eloy Duran
# Copyright (c) 2007 Eloy Duran, SuperAlloy

unless ARGV[0].nil?
  case ARGV[0]
  when 'build'
    SUPPORTED_FRAMEWORKS = ['/Developer/ADC Reference Library/documentation/Cocoa/Reference/ApplicationKit/']

    start_time = Time.now

    # Parse the rdoc for each supported framework
    SUPPORTED_FRAMEWORKS.each do |f|
      system "ruby gen_bridge_doc/rdocify_framework.rb '#{f}'"
    end

    # Create the rdoc files
    system "rdoc gen_bridge_doc/output/"

    puts ""
    puts "Total Cocoa Reference to RDoc processing time: #{Time.now - start_time} seconds"
  when 'clean'
    system "rm -r doc"
    system "rm -r gen_bridge_doc/output"
  else
    puts "Usage:"
    puts "  #{__FILE__} [build|clean]"
    puts ""
    puts "Options:"
    puts "  build  Create the RDoc documentation for the supported frameworks"
    puts "  clean  Remove all the files created by this tool"
    puts ''
  end
else
  puts "Usage:"
  puts "  #{__FILE__} [build|clean]"
  puts ""
  puts "Options:"
  puts "  build  Create the RDoc documentation for the supported frameworks"
  puts "  clean  Remove all the files created by this tool"
  puts ''
end