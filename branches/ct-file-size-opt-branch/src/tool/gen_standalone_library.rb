# 
# gen_standalone_library.rb
#
# Author: Chris Thomas -- ruby@cjack.com
#
# This script allows you to create RubyCocoa applications that
# you can distribute to users who have neither RubyCocoa
# nor Ruby installed.
#
# It generates a static archive library (currently "libeverything_cocoa.a")
# that you can link with a RubyCocoa project instead of linking against
# the RubyCocoa and LibRuby frameworks.
#
# To use:
#	1. add the resulting libeverything_cocoa.a to your RubyCocoa project
#	2. remove RubyCocoa.framework from the project
#	3. remove your main.m file
#	4. make sure your main entrypoint ruby source file is called rb_main.rb
#
# And you should be ready to go.
#
# This is still experimental; be very careful out there.
#

require 'rbconfig'

# assume this file is in the "tool" directory
Dir.chdir("..")

# acquire pathnames for all the sources
def subpaths(basepath)
	Dir.entries( basepath ).collect { |entry| basepath + entry }
end

ruby_lib_path = Config::CONFIG["archdir"] + "/" + Config::CONFIG["LIBRUBY_A"]

print "libruby:" + ruby_lib_path + "\n"

framework_dir		= './framework/'
extension_dir		= './ext/osx_objc/'
extension_cocoa_dir	= "#{extension_dir.to_s}cocoa/"

sources				=	subpaths( framework_dir ) + 
						subpaths( extension_dir ) + 
						subpaths( extension_cocoa_dir )

# get *.m, *.mm, *.c, *.cc, *.cp
sources				= sources.find_all {|name| name =~ /\.m?m$|\.c?[cp]$/}

# create the main source file
main_c_file_text = <<EOT
#include <RBRuntime.h>

// bootstrap RubyCocoa

int main(int argc, char **argv)
{
	return RBApplicationMain( "rb_main.rb", argc, argv );
}
EOT

main_source_file = File.new("ruby_app_generated_temp_main.m", "w+")
sources << main_source_file.path

main_source_file.write( main_c_file_text )
main_source_file.close


# compile it all
begin
	Dir.mkdir( 'gen-standlone-objects' )
rescue
end

#### FIX ME we should do a poor man's make here before compiling everything again
sources.each do |source|
	source =~ /(\w*.[mc][mcp]?)$/
	basename = $1
	command = "cc -c #{source} -o './gen-standlone-objects/#{basename}.o' -FCocoa -Iframework"
	print command + "\n"
	system command
end

# link all the .o files together
objects = Dir.entries('gen-standlone-objects')
Dir.chdir 'gen-standlone-objects'

objects = objects.find_all {|name| name =~ /\.o$/}

command = "libtool -static -framework Cocoa -o '../libeverything_ruby.a' #{objects.join(' ')} '#{ruby_lib_path}'"
print command + "\n"
system command
