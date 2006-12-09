# -*-rd-*-
= Getting RubyCocoa

== Binary Distribution

=== for Mac OS X 10.4

RubyCocoa's binary distribution has been built for the Ruby 1.8.2 distributed
with Mac OS X 10.4.

Download
((<RubyCocoa-0.5.0-OSX10.4universal.dmg|URL:http://prdownloads.sourceforge.net/rubycocoa/RubyCocoa-0.5.0-OSX10.4universal.dmg?download>))
from ((<file list|URL:http://sourceforge.net/project/showfiles.php?group_id=44114>)).

It includes library, samples, templates for Project Builder, etc. for 
RubyCocoa. Everything necessary for execution and development is
included in an easy-to-install '.pkg' package file.

A successful installation of the binary package will add the following items:

: /Library/Frameworks/RubyCocoa.framework
  RubyCocoa framework (core)

: inside of /usr/lib/ruby/site_ruby/1.8/osx/
  RubyCocoa library (stub)

: /usr/lib/ruby/site_ruby/1.8/[powerpc|i386]-darwin8.0/rubycocoa.bundle
  RubyCocoa extended library (stub)

: inside of '/Library/Application Support/Apple/Developer Tools'
  Some templates for Xcode

: BridgeSupport metadata (xml)
  '/Library/BridgeSupport/'

: /Developer/Documentation/RubyCocoa
  HTML documentation

: /Developer/Examples/RubyCocoa
  Sample programs

After installation, try the samples that are written in Ruby. Refer
to ((<'Try RubyCocoa Samples'|URL:trysamples.en.html>)).

== Source Distribution

Download
((<rubycocoa-0.5.0.1.tgz|URL:http://prdownloads.sourceforge.net/rubycocoa/rubycocoa-0.5.0.1.tgz?download>))
from ((<file list|URL:http://sourceforge.net/project/showfiles.php?group_id=44114>)).

To build and install RubyCocoa, refer to 
((<"Build and Install RubyCocoa from Source"|URL:build.en.html>)).


== Getting Development Source from Subversion Server

The latest (or the oldest) development source is available from the 
((<Subversion Server|URL:http://sourceforge.net/svn/?group_id=44114>)).

You can
((<view the Subversion Repository|URL:http://rubycocoa.svn.sourceforge.net/viewvc/rubycocoa/trunk/src/>))
for RubyCocoa. On the shell command line, type this:

  $ svn co https://rubycocoa.svn.sourceforge.net/svnroot/rubycocoa/trunk/src rubycocoa 

All of the source for RubyCocoa is downloaded into a directory named 'rubycocoa'.

Building may fail because of the nature of versioning. Some svn commands such as
'svn update' or 'svn log' will be helpful. Use these commands with appropriate 
options.


== MacPorts (DarwinPorts)

((<MacPorts|URL:http://http://www.macports.org//>)) has a port 
"rb-cocoa" for RubyCocoa(0.4.3d2). 

The port requires MacPorts version 1.1 or later. You can update your 
MacPorts with following command:

  $ sudo port -d selfupdate

== PINEAPPLE RPM Package

RPM format binary (0.2.x) exist on
((<Project PINEAPPLE (Japanese)|URL:http://sacral.c.u-tokyo.ac.jp/~hasimoto/Pineapple/>)).


$Date$
