=begin

= gen_standalone_library.rb

0.2

Author: Chris Thomas -- ruby@cjack.com

== Introduction

This script allows you to create RubyCocoa applications that you can
distribute to users who have neither RubyCocoa nor Ruby installed.

It generates a static archive library (currently
"libeverything_cocoa.a") that you can link with a RubyCocoa project
instead of linking against the RubyCocoa and LibRuby frameworks.

== Usage

To use:
	(1) run this script inside the tools directory: ruby ./gen_standlone_library.rb
	(2) add the resulting libeverything_cocoa.a to your RubyCocoa project
	(3) remove RubyCocoa.framework from the project
	(4) remove your main.m file	
	(5) make sure your main entrypoint ruby source file is called rb_main.rb	

And you should be ready to go.

== Revision History

=== 0.2

* use RD comments
* check modification times of files ("poor man's make") before recompiling/relinking
* use File.exist?

=== Future Directions

* My next task is to take a RubyCocoa application as input, and produce
a standalone RubyCocoa app as output. This should be very simple.

This is still experimental; be very careful out there.

=end

require 'rbconfig'

# assume this file is in the "tool" directory
Dir.chdir("..")

# acquire pathnames for all the sources
def subpaths(basepath)
	Dir.entries( basepath ).collect { |entry| basepath + entry }
end

ruby_lib_path = Config::CONFIG["archdir"] + "/" + Config::CONFIG["LIBRUBY_A"]

print "# Building RubyCocoa standalone for Ruby version: " + Config::RUBY_VERSION + "\n"

framework_dir		= './framework/'
extension_dir		= './ext/osx_objc/'
extension_cocoa_dir	= "#{extension_dir.to_s}cocoa/"

sources				=	subpaths( framework_dir ) + 
						subpaths( extension_dir ) + 
						subpaths( extension_cocoa_dir )

# get *.m, *.mm, *.c, *.cc, *.cp
sources				= sources.find_all {|name| name =~ /\.m?m$|\.c?[cp]$/}

# create the main source file
if not File.exist?("ruby_app_generated_temp_main.m")
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
end

# compile it all
if not File.exist?('gen-standlone-objects')
	Dir.mkdir( 'gen-standlone-objects' )
end

def compile_one_file(source_name, object_name)
	command = "cc -c #{source_name} -o #{object_name} -FCocoa -Iframework"
	print command + "\n"
	system command
end

# return a list of the files in deps that are newer than output_name
# this is the core of a possible replacement for 'make'
def check_file_dependencies( deps, output_name )
	need_rebuild = Array.new
	
	if File.exist? (output_name)
		# file exists, see if any of the files used to build it
		# have been modified since it was built.
		output_time = File.stat(output_name).mtime

		deps.each do |dep_name|
	
			# check times
			dep_time = File.stat(dep_name).mtime
			
			if dep_time > output_time
				need_rebuild << dep_name
			end
		end
		
	else
		# file doesn't exist, we need to build it
		need_rebuild = deps
	end
	
	if need_rebuild.length > 0 then
		print "# '#{output_name}' needs to be rebuilt\n"
	end
	
	need_rebuild = nil if need_rebuild.length == 0
	return need_rebuild
end

# compile each source file
sources.each do |source_name|

	base_name = source_name[/(\w*.[mc][mcp]?)$/]
	object_name = "./gen-standlone-objects/#{base_name}.o"
	
	if check_file_dependencies( [source_name], object_name ) != nil then
		compile_one_file(source_name, object_name)
	end
	
end

=begin
	
	print "# File '" + object_name + "' "
	if File.exist?(object_name)
		print "exists "
	
		# check times
		source_time = File.stat(source_name).mtime
		object_time = File.stat(object_name).mtime
		
		if source_time <= object_time then
			print "and is up to date\n"
		else
			print "but is not up to date...\n"			
			compile_one_file(source_name, object_name)
		end
	else
		print "does not exist...\n"
		compile_one_file(source_name, object_name)
	end

=end

# link all the .o files together
objects = Dir.entries('gen-standlone-objects')
Dir.chdir 'gen-standlone-objects'

objects = objects.find_all {|name| name =~ /\.o$/}

if check_file_dependencies( objects, '../libeverything_ruby.a' ) != nil then

	command = "libtool -static -framework Cocoa -o '../libeverything_ruby.a' #{objects.join(' ')} '#{ruby_lib_path}'"
	print command + "\n"
	system command
else
	print "# Everything seems to be up to date.\n"
end
