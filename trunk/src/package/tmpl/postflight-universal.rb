#!/usr/bin/ruby
# $Id$
# install extlib "rubycocoa.bundle"

require 'rbconfig'

srcfile = File.join('<%= @config['so-dir'] %>', 'rubycocoa.bundle')
destdir = Config::CONFIG['sitearchdir']
destfile = File.join(destdir, File.basename(srcfile))

exit 0 if destfile == srcfile

begin

  if File.exist? destfile
    puts "old extlib exists. remove:#{destfile}"
    File.unlink(destfile) 
  end

  unless File.exist? destdir
    puts "mkdir :#{destdir}"
    Dir.mkdir(destdir, 0755) 
  end

  puts "copy #{srcfile} to #{destfile}"

  exit 0
rescue 
  $stderr.print <<EOS
##########################
postflight process failed!
##########################
Error: #{$!.inspect}
EOS
  exit 1
end
