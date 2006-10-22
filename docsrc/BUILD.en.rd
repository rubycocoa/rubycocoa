# -*-rd-*-
= Building and Installing RubyCocoa from Source

This document describes building and installing RubyCocoa 0.4.2 from
source. Skip this if you are going to install the binary distribution.

Building and installation are done from a shell, using the Terminal
application or another program that provides a shell prompt, such as GLterm.
This document assumes the use of the (({bash})) shell in shell command input
examples. Please adjust the instructions accordingly when another shell (e.g.
(({tcsh}))) is used.


== Build and Installation Procedure

The following steps perform the build and installation.

* ((<Build and Installation of Ruby>))
* ((<Build of RubyCocoa>))
* ((<Unit Test for RubyCocoa>))
* ((<Installation of RubyCocoa>))

Extract RubyCocoa source from the '.tgz' file into a directory somewhere.

  $ cd {somewhere}
  $ tar zxf rubycocoa-0.4.2.tar.gz

((*Caution!*)) Using StuffIt, building RubyCocoa will fail because of a file
name length problem.


== Build and Installation of Ruby

To build RubyCocoa, some C language header files and Ruby's libruby library are
required. Here, the build procedure of Ruby which serves as a base of RubyCocoa
in the case shown below at an example is explained.

  * Ruby 1.8.5 installed from source
  * Ruby included in Mac OS X
    * Ruby 1.8.2(Mac OS X 10.4)

RubyCocoa 0.4.2 binary distribution has been built with the 2nd way.
When Ruby has been installed with a package utility such as
((<Fink|URL:http://fink.sf.net/>)), adapt these instructions accordingly.

=== Check that the necessary Mac OS X packages are installed

The required packages (BSD.pkg and BSDSDK.pkg) may not have been installed,
depending on the options selected when Mac OS X was installed. Please
first check whether packages is installed, and if required, install it from 
the Mac OS X installer.

  $ ls -dF /Library/Receipts/BSD*.pkg
  /Library/Receipts/BSD.pkg/   /Library/Receipts/BSDSDK.pkg/


=== Ruby 1.8.5 installed from source

It moves to the source directory of Ruby 1.8.5, and builds and installs
as follows. Please change an option if needed.
((- RubyCocoa.framework cannot be linked without specifying the
'-fno-common' option for CFLAGS. -))

  $ CFLAGS='-g -O2 -fno-common' ./configure --enable-shared
  $ make
  $ make test
  $ sudo make install
  $ sudo ranlib /usr/local/lib/libruby-static.a


=== Ruby 1.8.2 included in Mac OS X 10.4

Ruby 1.8.2 included in Mac OS X 10.4 works fine.
There is no action to do.


== Build of RubyCocoa

Type as follows to build RubyCocoa:

  $ ruby install.rb --help   # print all options
  $ ruby install.rb config
  $ ruby install.rb setup

'ruby install.rb config' command have some options for RubyCocoa. If
required, specify option at the time of a config phase.

== Unit Test for RubyCocoa

  $ ruby install.rb test

((<"Test::Unit"|URL:http://raa.ruby-lang.org/list.rhtml?name=testunit>)) 
is required for unit tests.  This process is optional.
(Test::Unit is not available on RAA. We uploaded a copy 
((<testunit-0.1.8.tar.gz|URL:http://rubycocoa.sourceforge.net/files/testunit-0.1.8.tar.gz>)).)

Ruby 1.8 includes Test::UNIT.


== Installation of RubyCocoa

  $ sudo ruby install.rb install

Installation is completed above. The following were installed:
old procedure.
(case with Ruby 1.8.2 included in Mac OS X 10.4)

: /Library/Frameworks/RubyCocoa.framework
  RubyCocoa framework (real)

: inside of /usr/lib/ruby/site_ruby/1.8/osx/
  RubyCocoa library (stub)
  - addressbook.rb, appkit.rb, cocoa.rb, foundation.rb

: /usr/lib/ruby/site_ruby/1.8/[powerpc|i386]-darwin8.0/rubycocoa.bundle
  RubyCocoa extended library (stub)

: inside of '/Library/Application Support/Apple/Developer Tools/'
  Some templates for Xcode
  * 'File Templates/Ruby'
  * 'Project Templates/Application/Cocoa-Ruby Document-based Application'
  * 'Project Templates/Application/Cocoa-Ruby Application'

: /Library/BridgeSupport
  xml files about metadata of AppKit and Foundation.

: /Developer/Documentation/RubyCocoa
  HTML Documentation

: /Developer/Examples/RubyCocoa
  Sample programs

After installation, let's try samples that are written by Ruby. Refer
to ((<'Try RubyCocoa Samples'|URL:trysamples.en.html>)).


== [FYI] Useful Installer Options for Binary Package Maintainers

For a maintainer of a binary package, there are some useful options for the
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

  /tmp/build/usr/lib/ruby/site_ruby/1.8/osx/addressbook.rb
  /tmp/build/usr/lib/ruby/site_ruby/1.8/osx/appkit.rb
  /tmp/build/usr/lib/ruby/site_ruby/1.8/osx/cocoa.rb
  /tmp/build/usr/lib/ruby/site_ruby/1.8/osx/foundation.rb
  /tmp/build/usr/lib/ruby/site_ruby/1.8/powerpc-darwin8.0/rubycocoa.bundle
  /tmp/build/Library/Frameworks/RubyCocoa.framework
  /tmp/build/Developer/ProjectBuilder Extras/File Templates/Ruby
  /tmp/build/Developer/ProjectBuilder Extras/Project Templates/ \
          Application/Cocoa-Ruby Application
  /tmp/build/Developer/ProjectBuilder Extras/Project Templates/ \
          Application/Cocoa-Ruby Document-based Application
  /tmp/build/Developer/Examples/RubyCocoa
  /tmp/build/Developer/Documentation/RubyCocoa


== Development and testing environment

* PowerBook G4/1.67/1GB
* Mac OS X 10.4.8 (ppc)
  * XcodeTools 2.4
  * ruby-1.8.2 (pre-installed in Mac OS X 10.4)
  * ruby-1.8.5


== Have fun!

Feel free to send comments, bug reports and patches for RubyCocoa.


$Date$
