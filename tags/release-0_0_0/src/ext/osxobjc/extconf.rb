require 'mkmf'

def objs
  `ls cocoa/*.[mc]`.split.map{|i| "#{i.split('.')[0]}.o" } +
    `ls *.[mc]`.split.map{|i| "#{i.split('.')[0]}.o" }
end

$objs = objs
$LDFLAGS = ' -Fframework/build -framework RubyCocoa'

create_makefile('osxobjc')
