# -*-rd-*-
= Getting RubyCocoa

== Binary Distribution

RubyCocoa's binary distribution has been built for the Ruby 1.6.7 distributed
with Mac OS X 10.2.

Download
((<RubyCocoa-0.4.0.dmg|URL:http://rubycocoa.sourceforge.net/files/RubyCocoa-0.4.0.dmg>))
from ((<file list|URL:http://rubycocoa.sourceforge.net/files/>)).

It includes library, samples, templates for Project Builder, etc. for both
RubyCocoa and RubyAEOSA. Everything necessary for execution and development is
included in an easy-to-install '.pkg' package file.

A successful installation of the binary package will add the following items:

: /Library/Frameworks/RubyCocoa.framework
  RubyCocoa framework (core)

: inside of /usr/lib/ruby/site_ruby/1.6/osx/
  RubyCocoa library (stub)

: /usr/lib/ruby/site_ruby/1.6/powerpc-darwin6.0/rubycocoa.bundle
  RubyCocoa extended library (stub)

: inside of '/Developer/ProjectBuilder Extras/'
  Some templates for ProjectBuilder

: /Developer/Documentation/RubyCocoa
  HTML documentation

: /Developer/Examples/RubyCocoa
  Sample programs

After installation, try the samples that are written in Ruby. Refer
to ((<'Try RubyCocoa Samples'|URL:trysamples.en.html>)).


== Source Distribution

Download
((<rubycocoa-0.4.0.tgz|URL:http://rubycocoa.sourceforge.net/files/rubycocoa-0.4.0.tgz>))
from ((<file list|URL:http://rubycocoa.sourceforge.net/files/>)).

To build and install RubyCocoa, refer to 
((<"Build and Install RubyCocoa from Source"|URL:build.en.html>)).


== Getting Development Source from CVS Server

The latest (or the oldest) development source is available from the 
((<CVS Server|URL:http://sourceforge.net/cvs/?group_id=44114>)).

You can
((<view the CVS Repository|URL:http://cvs.sourceforge.net/cgi-bin/viewcvs.cgi/rubycocoa/>))
for RubyCocoa. On the shell command line, type this:

  $ cvs -d:pserver:anonymous@cvs.sf.net:/cvsroot/rubycocoa login
  $ cvs -z3 -d:pserver:anonymous@cvs.sf.net:/cvsroot/rubycocoa co \
        -P -d rubycocoa src
  $ cd rubycocoa
  $ cvs update -d -P

The latest source supports panther. branch-devel-panther was merged into main trunk.

All of the source for RubyCocoa is downloaded into a directory named 'rubycocoa'.

Building may fail because of the nature of CVS. Some cvs commands such as
'cvs update' or 'cvs status -v' will be helpful. Use these commands
with appropriate options.


== PINEAPPLE RPM Package

RPM format binary (0.2.x) exist on
((<Project PINEAPPLE (Japanese)|URL:http://sacral.c.u-tokyo.ac.jp/~hasimoto/Pineapple/>)).


$Date$
