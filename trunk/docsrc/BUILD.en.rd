# -*-rd-*-
= Build and Installation RubyCocoa from Source

This document describes build and installation of RubyCocoa 0.4 from
source. Skip this if you are going to install the binary distribution.

Build/Installation would be done on shell command with Terminal
application or etc. In this document, it's assumed to use 'bash' in
shell command input example. When other shell (e.g. tcsh) is used,
please read suitably.


== Procedure of Build and Installation

The following procedures perform build and installation.

* ((<Build and Installation of Ruby>))
* ((<Build of RubyCocoa>))
* ((<Unit Test for RubyCocoa>))
* ((<Installation of RubyCocoa>))

On somewhere directory, extract RubyCocoa source from the '.tgz' file.

  $ cd {somewhere}
  $ tar zxf rubycocoa-0.4.0.tar.gz

((*Caution!*)) Using StuffIt, building RubyCocoa will fail
because of a file name length problem. 


== Build and Installation of Ruby

To build RubyCocoa, Some C language header files and libruby of Ruby
is required. Here, the build procedure of Ruby which serves as a base
of RubyCocoa in the case shown below at an example is explained.

  * Ruby 1.8 installed from source
  * Ruby 1.6.7 included in Mac OS X 10.2

RubyCocoa 0.4 binary distribution has been built with the latter.
When Ruby has been installed with some packages (such as
((<Fink|URL:http://fink.sf.net/>))), read and change accordingly.


=== Ruby 1.8 installed from source

It moves to the sauce directory of Ruby 1.8, and builds and installs
as follows. Please change an option if needed.
((- RubyCocoa.framework cannot be linked without specify the
'-fno-common' option for CFLAGS. -))

  $ CFLAGS='-g -O2 -fno-common' ./configure
  $ make
  $ make test
  $ sudo make install
  $ sudo ranlib /usr/local/lib/libruby-static.a


=== Ruby 1.6.7 included in Mac OS X 10.2

==== The check of the Mac OS X package installed already

The required package (BSD.pkg and BSDSDK.pkg) may not be installed
according to the option setup when installing Mac OS X 10.2. Please
check whether first of all, Ruby is installed, and if required,
install.

  $ ls -dF /Library/Receipts/BSD*.pkg
  /Library/Receipts/BSD.pkg/   /Library/Receipts/BSDSDK.pkg/

Although Ruby is contained in Mac OS X 10.2, what reason or libruby is
not contained. Therefore, to build RubyCocoa, it is necessary to make
libruby from the sauce of Ruby 1.6.7.


==== apply patch to Ruby 1.6.7 source

Extract source from Ruby 1.6.7 '.tgz' file, and apply the patch which
is contained in RubyCocoa to Ruby 1.6.7.

  $ cd {somewhere}
  $ tar zxf ruby-1.6.7.tar.gz
  $ cd ruby-1.6.7
  $ patch -p1 < {RubyCocoa source}/ruby-1.6.7-osx10.2.patch


==== build/installation of libruby

Ruby 1.6.7 is built so that the environment of the Mac OS X attachment
Ruby may be suited.
((- RubyCocoa.framework cannot be linked without specify the
'-fno-common' option for CFLAGS. -))

  $ rbhost=`ruby -r rbconfig -e "print Config::CONFIG['host']"`
  $ CFLAGS='-g -O2 -fno-common' ./configure --prefix=/usr --host=$rbhost
  $ make
  $ make test

install only libruby.a.

  $ ranlib libruby.a
  $ rubyarchdir=`ruby -r rbconfig -e 'print Config::CONFIG["archdir"]'`
  $ sudo install -m 0644 libruby.a $rubyarchdir


== Build of RubyCocoa

Type as follows for build RubyCocoa:

  $ ruby install.rb --help   # print all options
  $ ruby install.rb config
  $ ruby install.rb setup

'ruby install.rb config' command have some options for RubyCocoa. If
required, specify option at the time of a config phase.

((*Caution!*)) If you got an error Segmentation Fault in config phase,
please check "((<Notice for build of RubyCocoa 0.4.0 to Ruby 1.6.8>))".

== Unit Test for RubyCocoa

  $ cd {source}/tests
  $ DYLD_FRAMEWORK_PATH={source}/framework/build ruby -I../lib testall.rb

Test::Unit is required for unit test.
This process is optional.


== Installation of RubyCocoa

  $ sudo ruby install.rb install

Installation is completion above. The following were installed:
old procedure.

: /Library/Frameworks/RubyCocoa.framework
  RubyCocoa framework (real)

: inside of /usr/lib/ruby/site_ruby/1.6/osx/
  RubyCocoa library (stub)
  - addressbook.rb, appkit.rb, cocoa.rb, foundation.rb

: /usr/lib/ruby/site_ruby/1.6/powerpc-darwin6.0/rubycocoa.bundle
  RubyCocoa extended library (stub)

: inside of '/Developer/ProjectBuilder Extras/'
  some templates for ProjectBuilder
  'File Templates/Ruby'
  'Project Templates/Application/Cocoa-Ruby Document-based Application'
  'Project Templates/Application/Cocoa-Ruby Application'

: /Developer/Documentation/RubyCocoa
  Documents (HTML)

: /Developer/Examples/RubyCocoa
  sample programs

After installation, let's try samples that are written by Ruby. Refer
to ((<'Try RubyCocoa Samples'|URL:trysamples.en.html>)).


== [FYI] Useful Installer's Options for a Binary Packaging

For a maintainer of a binary package, there're useful options in
config phase.

  * --install-prefix  : effect to extended library and library
  * --install-root    : effect to framework, templates, documents and examples

=== e.g.

  $ ruby -r rbconfig -e 'p Config::CONFIG["prefix"]'
  "/usr"
  $ ruby install.rb config \
      --install-prefix=/tmp/build/usr --install-root=/tmp/build
  $ ruby install.rb setup
  $ sudo ruby install.rb install

As a result, these will be installed temporarily.

  /tmp/build/usr/lib/ruby/site_ruby/1.6/osx/addressbook.rb
  /tmp/build/usr/lib/ruby/site_ruby/1.6/osx/appkit.rb
  /tmp/build/usr/lib/ruby/site_ruby/1.6/osx/cocoa.rb
  /tmp/build/usr/lib/ruby/site_ruby/1.6/osx/foundation.rb
  /tmp/build/usr/lib/ruby/site_ruby/1.6/powerpc-darwin6.0/rubycocoa.bundle
  /tmp/build/Library/Frameworks/RubyCocoa.framework
  /tmp/build/Developer/ProjectBuilder Extras/File Templates/Ruby
  /tmp/build/Developer/ProjectBuilder Extras/Project Templates/ \
          Application/Cocoa-Ruby Application
  /tmp/build/Developer/ProjectBuilder Extras/Project Templates/ \
          Application/Cocoa-Ruby Document-based Application
  /tmp/build/Developer/Examples/RubyCocoa
  /tmp/build/Developer/Documentation/RubyCocoa


== Notice for build of RubyCocoa 0.4.0 to Ruby 1.6.8

In build of RubyCocoa 0.4.0 to ((*Ruby 1.6.8*)), you may see a error
message Segmentation Fault in config phase:

  ruby install.rb config

For fix this, apply
((<a patch|URL:http://www.imasy.or.jp/%7ehisa/mac/rubyosx/files/ruco0.4.0-fw-post-config.patch>))
as follows after extracting rubycocoa-0.4.0.tgz.

  $ cd {rubycocoa-0.4.0}
  $ patch -p0 < ruco0.4.0-fw-post-config.patch

The patch is:

  diff -u -b -u -r1.4 post-config.rb
  --- framework/post-config.rb	19 Dec 2002 08:41:50 -0000	1.4
  +++ framework/post-config.rb	11 Jan 2003 14:02:17 -0000
  @@ -12,10 +12,9 @@
     $stderr.puts "create #{File.expand_path(dst_fname)} ..."
     File.open(dst_fname, 'w') do |dstfile|
       IO.foreach(src_path) do |line|
  -      line = line.gsub( /\bID\b/, 'RB_ID' )
  -      line = line.gsub( /\bT_DATA\b/, 'RB_T_DATA' )
  -      line = line.gsub( /\bintern.h\b/, "#{new_filename_prefix}intern.h" )
  -      dstfile.puts line
  +      line.gsub!( /\b(ID|T_DATA)\b/, 'RB_\1' )
  +      line.gsub!( /\bintern\.h\b/, "#{new_filename_prefix}intern.h" )
  +      dstfile.puts( line )
       end
     end
   end


== Development and testing environment 

* PowerMacintosh G4/400/384MB or iBook G3/600/384MB
* Mac OS X 10.2.3
* DevTools 10.2
* ruby-1.6.7 (pre-installed in Mac OS X 10.2)
* ruby-1.8 (preview 1 from cvs server)


== Have a fun

Feel free to send comments, bug reports and patches for RubyCocoa.


$Date$
