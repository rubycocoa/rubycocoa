# -*-rd-*-
= Getting RubyCocoa

== Binary Distribution

RubyCocoa in a binary distribution have been built for Ruby 1.6.7
attached to Mac OS X 10.2.

Download a
((<RubyCocoa-0.4.0.dmg|URL:http://www.imasy.or.jp/~hisa/mac/rubyosx/files/RubyCocoa-0.4.0.dmg>))
from ((<file list|URL:http://www.imasy.or.jp/~hisa/mac/rubyosx/files/>)).

It include library, samples, templates for Proejct Builder and etc of
both RubyCocoa and RubyAEOSA. All of necessary for
execution/development is included in a '.pkg' package file which is
easy to install.

After installation of the binary package is successful, following
items will appear:

: /Library/Frameworks/RubyCocoa.framework
  RubyCocoa framework (core)

: inside of /usr/lib/ruby/site_ruby/1.6/osx/
  RubyCocoa library (stub)

: /usr/lib/ruby/site_ruby/1.6/powerpc-darwin6.0/rubycocoa.bundle
  RubyCocoa extended library (stub)

: inside of '/Developer/ProjectBuilder Extras/'
  some templates for ProjectBuilder

: /Developer/Documentation/RubyCocoa
  Documents (HTML)

: /Developer/Examples/RubyCocoa
  sample programs

After installation, let's try samples that are written by Ruby. Refer
to ((<'Try RubyCocoa Samples'|URL:trysamples.en.html>)).


== Source Distribution

Download a
((<rubycocoa-0.4.0.tgz|URL:http://www.imasy.or.jp/~hisa/mac/rubyosx/files/rubycocoa-0.4.0.tgz>))
from ((<file list|URL:http://www.imasy.or.jp/~hisa/mac/rubyosx/files/>)).

Let's build and install RubyCocoa. Refer to 
((<"Build and Install RubyCocoa from Source"|URL:build.en.html>)).


== Getting Source of Developing from CVS Server

The latest (or the oldest) source of developing is available from 
((<CVS Sever|URL:http://sourceforge.net/cvs/?group_id=44114>)).

You can
((<view CVS Repository|URL:http://cvs.sourceforge.net/cgi-bin/viewcvs.cgi/rubycocoa/src/>))
for RubyCocoa. On shell command line, Type this:

  $ cvs -d:pserver:anonymous@cvs.rubycocoa.sf.net:/cvsroot/rubycocoa login
  $ cvs -z3 -d:pserver:anonymous@cvs.rubycocoa.sf.net:/cvsroot/rubycocoa \
      co rubycocoa

All of source for RubyCocoa is downloaed in a directory named
'rubycocoa'.

Build may fail because of nature of CVS. Some cvs commands such as
'cvs update' or 'cvs status -v' will be helpful. Use these command
with appropriate options.


== PINEAPPLE RPM Package

RPM format binary (0.2.x) exist on
((<Project PINEAPPLE (Japanese)|URL:http://sacral.c.u-tokyo.ac.jp/~hasimoto/Pineapple/>)).


$Date$
