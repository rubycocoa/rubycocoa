require 'mkmf'

$LDFLAGS = '-F../../framework/build -framework LibRuby -framework RubyCocoa'
$CFLAGS  = '-F../../framework/build'

$objs = 
  `ls cocoa/*.[mc]`.split.map{|i| "#{i.split('.')[0]}.o" } +
  `ls *.[mc]`.split.map{|i| "#{i.split('.')[0]}.o" }

create_makefile('osxobjc')
