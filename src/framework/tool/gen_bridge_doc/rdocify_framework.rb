#!/usr/bin/env ruby

# Created by Eloy Duran
# Copyright (c) 2007 Eloy Duran, SuperAlloy

script_dir = File.dirname(File.expand_path(__FILE__))
require "#{script_dir}/lib/cocoa_ref"

def command( str )
  $stderr.puts str
  system str or raise RuntimeError, "'system #{str}' failed"
end

def ruby( str )
  command "#{Config::CONFIG["bindir"]}/ruby #{str}"
end

def rdoc( str )
  command "#{Config::CONFIG["bindir"]}/rdoc #{str}"
end

def get_reference_files(framework_path)
  classes_dir = File.join(framework_path, 'Classes/')
  reference_files = []
  Dir.entries(classes_dir).each do |f|
    class_path = File.join(classes_dir, f)
    if File.directory?(class_path) and not f == '.' and not f == '..'
      ref_dir_path = File.join(class_path, 'Reference/')
      Dir.entries(ref_dir_path).each do |rf|
        if File.extname(rf) == '.html'
          ref_path = File.join(ref_dir_path, rf)
          reference_files.push({:name => File.basename(class_path), :path => ref_path})
        end
      end
    end
  end
  return reference_files
end

$COCOA_REF_DEBUG = false
output_files_with_errors = false
framework_path = ''
output_dir = ''

unless ARGV.empty?
  ARGV.each do |arg|
    case arg
    when '-f'
      output_files_with_errors = true
    when '-v'
      $COCOA_REF_DEBUG = true
    else
      if framework_path.empty?
        framework_path = arg
      else
        output_dir = arg
      end
    end
  end
else
  puts "Usage:"
  puts "  #{__FILE__} [options] path/to/the/framework <output dir>"
  puts ""
  puts "Options:"
  puts "  -v Verbose output."
  puts "  -f Force the output files to be written even if there were errors during parsing."
  puts ""
  puts "Example:"
  puts "  #{__FILE__} /Developer/ADC Reference Library/documentation/Cocoa/Reference/ApplicationKit/ output/"
  puts "  #{__FILE__} -v /Developer/ADC Reference Library/documentation/Cocoa/Reference/ApplicationKit/"
  puts "  #{__FILE__} -v -f /Developer/ADC Reference Library/documentation/Cocoa/Reference/ApplicationKit/"
  puts ""
  
  exit
end

puts ""
puts "Working on: #{framework_path}"
puts ""

reference_files = get_reference_files(framework_path)

unless output_dir.empty?
  output_dir = File.expand_path(output_dir)
else
  output_dir = File.join(script_dir, 'output/')
end

if not File.exists?(output_dir)
  command "mkdir -p #{output_dir}"
end

success = 0
errors = 0
reference_files.each do |ref|
  puts "Processing reference file: #{ref[:name]}"
  cocoa_ref_parser = CocoaRef::Parser.new(ref[:path], File.basename(framework_path))
  if not cocoa_ref_parser.errors? or output_files_with_errors
    success = success.next
    puts "      Writing output file: #{cocoa_ref_parser.class_def.output_filename}"
    cocoa_ref_parser.to_rb_file(output_dir)
  else
    errors = errors.next
    puts 'Skipping because there were errors while parsing...'
  end
end

puts ''
puts "Stats for: #{framework_path}"
puts "  Written: #{success} files"
puts "  Skipped: #{errors} files"
puts ''
