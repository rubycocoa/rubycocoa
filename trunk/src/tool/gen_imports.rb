
# example: 
# ruby gen_imports.rb /System/Library/Frameworks/Foundation.framework/Headers/*.h

def extract_names(enum)
  re = /^\s*@interface\s+(\w*)\b/

  names = enum.map { |line|
    m = re.match(line)
    m[1] if m && m.size > 0
  }
  names.compact!
  names.uniq!
  names
end

HEADER = "require 'osx/ocobject'\n\nmodule OSX\n\n"
FOOTER = "\nend\n"

if $0 == __FILE__ then
  names = extract_names(ARGF)
  puts HEADER
  names.each do |name|
    puts "  ns_import :#{name}"
  end
  puts FOOTER
end
