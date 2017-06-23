require "mkmf"

# :stopdoc:

config = RbConfig::MAKEFILE_CONFIG
if with_config('libruby-static')
  $LIBRUBYARG = config['LIBRUBYARG_STATIC']
end

# libffi
dir_config('libffi')
if have_header(ffi_header = 'ffi.h')
  # ok
elsif have_header(ffi_header = 'ffi/ffi.h')
  $defs.push(format('-DUSE_HEADER_HACKS'))
end
unless (have_library('ffi') || have_library('libffi'))
  raise "missing libffi. Please install libffi."
end

# libxml2
dir_config('xml2', '/usr/include/libxml2', '/usr/lib')
unless have_library('xml2')
  raise "missing libxml2. Please install libxml2."
end
unless have_header('libxml/xmlreader.h')
  raise "missing libxml/xmlreader.h of libxml2. Please pass --with-xml-include to extconf.rb"
end

$CFLAGS << ' -g -fobjc-exceptions -Wall'
$LDFLAGS = ' -undefined suppress -flat_namespace -framework Foundation'
$CFLAGS << ' -DRB_ID=ID'

macosx_deployment_target =
  with_config('macosx-deployment-target', `xcrun --show-sdk-version`.chomp)
$defs.push("-DRUBYCOCOA_DEPLOYMET_TARGET=#{macosx_deployment_target}")
$defs.push("-DBUILD_RUBY_VERSION=#{RUBY_VERSION}")

create_header
create_makefile("rubycocoa/rubycocoa")
