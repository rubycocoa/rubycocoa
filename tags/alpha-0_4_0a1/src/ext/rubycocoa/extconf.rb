require 'mkmf'

def command(cmd)
  $stderr.puts "execute '#{cmd}' ..."
  raise(RuntimeError, cmd) unless system(cmd)
  $stderr.puts "execute '#{cmd}' done"
end

$CFLAGS  = '-F../../framework/build -framework RubyCocoa'
$LDFLAGS  = '-F../../framework/build -framework RubyCocoa'

create_makefile('rubycocoa')
command "mv -f Makefile Makefile.bak"
command "sed -e 's/-no-cpp-precomp//' -e 's/-no-precomp//' Makefile.bak > Makefile"
