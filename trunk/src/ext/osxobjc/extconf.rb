require 'mkmf'

$LDFLAGS = '-F../../framework/build -framework RubyCocoa'
$CFLAGS  = '-I../../framework'

$objs = 
  `ls cocoa/*.[mc]`.split.map{|i| "#{i.split('.')[0]}.o" } +
  `ls *.[mc]`.split.map{|i| "#{i.split('.')[0]}.o" }

create_makefile('osxobjc')
