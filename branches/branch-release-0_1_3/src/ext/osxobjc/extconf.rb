require 'mkmf'

def command(cmd)
  $stderr.puts "execute '#{cmd}' ..."
  raise (RuntimeError, cmd) unless system(cmd)
  $stderr.puts "execute '#{cmd}' done"
end

$LDFLAGS = '-F../../framework/build -framework LibRuby -framework RubyCocoa'
$CFLAGS  = '-F../../framework/build'

$objs = 
  `ls cocoa/*.[mc]`.split.map{|i| "#{i.split('.')[0]}.o" } +
  `ls *.[mc]`.split.map{|i| "#{i.split('.')[0]}.o" }

create_makefile('osxobjc')

command "mv -f Makefile Makefile.bak"
command "sed -e 's/-no-precomp//' Makefile.bak > Makefile"
