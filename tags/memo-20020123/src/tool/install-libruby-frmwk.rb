#!/usr/bin/env ruby

# $Id$

FRAMEWORK_NAME = 'LibRuby'
FRAMEWORKS_DIR = '/Library/Frameworks'

require 'rbconfig'

def mkdir(dir)
  $stderr.puts "mkdir '#{dir}' ..."
  unless File.exist?(dir) then
    Dir.mkdir dir
  end
end

def chdir(dir)
  $stderr.puts "chdir '#{dir}' ..."
  Dir.chdir dir
end

def copy(src, dst)
  cmd = "cp -f #{src} #{dst}"
  $stderr.puts "#{cmd} ..."
  raise RuntimeError, cmd unless system(cmd)
end

def symlink(orig, new)
  $stderr.puts "symlink #{orig} #{new} ..."
  File.symlink(orig, new)
end

def command(cmd)
  $stderr.puts "execute '#{cmd}' ..."
  raise (RuntimeError, cmd) unless system(cmd)
  $stderr.puts "execute '#{cmd}' done"
end

# avoid `ID' and `T_DATA' confict headers between Cocoa and Ruby.
def create_modified_ruby_headers(dst_header_dir)
  ruby_h = "#{Config::CONFIG['archdir']}/ruby.h"
  intern_h = "#{Config::CONFIG['archdir']}/intern.h"
  [ ruby_h, intern_h ].each do |src_path|
    dst_fname = "cocoa_#{File.basename(src_path)}"
    dst_fname = File.join(dst_header_dir, dst_fname)
    $stderr.puts "create #{File.expand_path(dst_fname)} ..."
    File.open(dst_fname, 'w') do |dstfile|
      IO.foreach(src_path) do |line|
	line = line.gsub (/\bID\b/, 'RB_ID')
	line = line.gsub (/\bT_DATA\b/, 'RB_T_DATA')
	line = line.gsub (/\bintern.h\b/, 'cocoa_intern.h')
	dstfile.puts line
      end
    end
  end
end

BASEDIR = "#{FRAMEWORK_NAME}.framework"
LIBRUBY_PATH = File.join(Config::CONFIG['libdir'], Config::CONFIG['LIBRUBY'])
HEADER_PATH  = Config::CONFIG['archdir']
CURR_VERSION = Config::CONFIG['ruby_version']

TARGETDIR = (ARGV.size == 0) ? FRAMEWORKS_DIR : ARGV[0]

mkdir TARGETDIR ; chdir TARGETDIR
command "rm -rf #{BASEDIR}"

mkdir BASEDIR ; chdir BASEDIR	        # BASEDIR
mkdir 'Versions' ; chdir 'Versions'     # BASEDIR/Versions
mkdir CURR_VERSION ; chdir CURR_VERSION	# BASEDIR/Versions/CURVERS
mkdir "Headers"
copy  "#{HEADER_PATH}/*.h", "Headers/"
create_modified_ruby_headers "Headers"
symlink LIBRUBY_PATH, FRAMEWORK_NAME
chdir '..'			        # BASEDIR/Versions
symlink CURR_VERSION, 'Current'
chdir '..'			        # BASEDIR
symlink 'Versions/Current/Headers', 'Headers'
symlink "Versions/Current/#{FRAMEWORK_NAME}", FRAMEWORK_NAME

