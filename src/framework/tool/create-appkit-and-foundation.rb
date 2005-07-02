#!/usr/bin/env ruby

# generate foundation.rb and appkit.rb

def extract_class_names(enum)
  re = /^\s*@interface\s+(\w*)\b/

  names = enum.map { |line|
    m = re.match(line)
    m[1] if m && m.size > 0
  }
  names.compact!
  names.uniq!
  names
end

def read_all_from(fnames)
  str = ""
  fnames.each do |fname|
    str.concat File.open(fname){|f|f.read}
  end
  str
end  

if File.exists?('/System/Library') then
  foundation = "/System/Library/Frameworks/Foundation.framework/Headers/*.h";
  appkit = "/System/Library/Frameworks/AppKit.framework/Headers/*.h";
  require 'tool/cocoa_ignored'
else
  foundation = ENV['GNUSTEP_ROOT']+"/System/Library/Headers/Foundation/*.h";
  appkit = ENV['GNUSTEP_ROOT']+"/System/Library/Headers/AppKit/*.h";
  require 'tool/gnustep_ignored'
end

header_str = <<HEADER_STR
require 'osx/objc/oc_all'

module OSX

HEADER_STR

footer_str = "\nend\n"

[
  [ Dir[foundation],	"src/ruby/osx/objc/foundation.rb" ],
  [ Dir[appkit],	"src/ruby/osx/objc/appkit.rb" ]
].each do |src_headers, dst_fname|
  srcstr = read_all_from(src_headers)
  cnames = extract_class_names(srcstr)
  File.open(dst_fname, "w") do |f|
    f.puts header_str
    cnames.each do |cname|
      f.puts "  ns_import :#{cname}" if ! @ignored[cname]
    end
    f.puts footer_str
  end
end
