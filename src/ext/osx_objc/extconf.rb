require 'mkmf'

def command(cmd)
  $stderr.puts "execute '#{cmd}' ..."
  raise (RuntimeError, cmd) unless system(cmd)
  $stderr.puts "execute '#{cmd}' done"
end

# avoid `ID' and `T_DATA' confict headers between Cocoa and Ruby.
def create_modified_ruby_headers(new_filename_prefix)
  ruby_h = "#{Config::CONFIG['archdir']}/ruby.h"
  intern_h = "#{Config::CONFIG['archdir']}/intern.h"
  [ ruby_h, intern_h ].each do |src_path|
    dst_fname = new_filename_prefix + File.basename(src_path)
    $stderr.puts "create #{File.expand_path(dst_fname)} ..."
    File.open(dst_fname, 'w') do |dstfile|
      IO.foreach(src_path) do |line|
	line = line.gsub (/\bID\b/, 'RB_ID')
	line = line.gsub (/\bT_DATA\b/, 'RB_T_DATA')
	line = line.gsub (/\bintern.h\b/, "#{new_filename_prefix}intern.h")
	dstfile.puts line
      end
    end
  end
end

$CFLAGS  = '-I..'
$LDFLAGS = '-framework Cocoa'

cocoadir =
  if `uname -r`.to_f >= 6.0 then
    'cocoa-10.2'
  else
    'cocoa-10.1'
  end

$objs = 
  `ls #{cocoadir}/*.[mc]`.split.map{|i| "#{i.sub(/.[mc]$/,"")}.o" } +
  `ls *.[mc]`.split.map{|i| "#{i.sub(/.[mc]$/,"")}.o" }

create_makefile('osx_objc')

command "mv -f Makefile Makefile.bak"
command "sed -e 's/-no-cpp-precomp//' -e 's/-no-precomp//' Makefile.bak > Makefile"
create_modified_ruby_headers "osx_"
