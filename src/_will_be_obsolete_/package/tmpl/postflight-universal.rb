#!/usr/bin/env ruby
# $Id$
# install extlib "rubycocoa.bundle"

require 'rbconfig'
require 'fileutils'

srcfile = File.join('<%= @config['so-dir'] %>', 'rubycocoa.bundle')
destdir = Config::CONFIG['sitearchdir']
destfile = File.join(destdir, File.basename(srcfile))

begin

  if destfile != srcfile

    if File.exist? destfile
      puts "old extlib exists. remove:#{destfile}"
      File.unlink(destfile) 
    end

    unless File.exist? destdir
      puts "mkdir :#{destdir}"
      Dir.mkdir(destdir, 0755) 
    end

    puts "copy #{srcfile} to #{destfile}"
    File.link srcfile, destfile

  end


  Dir.chdir ENV['RECEIPT_PATH'] do
    libruby_path = "libruby/libruby.1.dylib-tiger-%s.tar.gz" % `arch`.chomp
    puts "libruby tarball is #{libruby_path}"
    if File.exist? libruby_path
      puts "overriding libruby"
      exit 1 unless system("tar -xzf '#{libruby_path}' -C libruby") 
      FileUtils.mv '/usr/lib/libruby.1.dylib', '/usr/lib/libruby.1.dylib.original'
      FileUtils.mv libruby_path.sub(/\.tar\.gz$/, ''), '/usr/lib/libruby.1.dylib'
    end
  end

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
