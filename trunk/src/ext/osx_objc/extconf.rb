require 'mkmf'

def command(cmd)
  $stderr.puts "execute '#{cmd}' ..."
  raise (RuntimeError, cmd) unless system(cmd)
  $stderr.puts "execute '#{cmd}' done"
end

$LDFLAGS = '-F../../framework/build -framework LibRuby -framework RubyCocoa'
$CFLAGS  = '-F../../framework/build'

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
command "sed -e 's/-no-precomp//' Makefile.bak > Makefile"
