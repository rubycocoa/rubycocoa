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

header_str = "require 'osx/objc/ocobject'\n\nmodule OSX\n\n"
footer_str = "\nend\n"

[
  [ Dir["/System/Library/Frameworks/Foundation.framework/Headers/*.h"],
    "foundation.rb" ],
  [ Dir["/System/Library/Frameworks/AppKit.framework/Headers/*.h"],
    "appkit.rb" ]
].each do |src_headers, dst_fname|
  srcstr = read_all_from (src_headers)
  cnames = extract_class_names (srcstr)
  File.open(dst_fname, "w") do |f|
    f.puts header_str
    cnames.each do |cname|
      f.puts "  ns_import :#{cname}"
    end
    f.puts footer_str
  end
end
