#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
#
#  This program is free software.
#  You can distribute/modify this program under the terms of
#  the GNU Lesser General Public License version 2.
#

def libruby_installed?
  require 'tempfile'
  f = Tempfile.new ('rubycocoa-post-config')
  f.write "#import <LibRuby/cocoa_ruby.h>\nint main()\n{ ruby_init();\nreturn 0;\n }\n"
  f.flush
  outfile = f.path + '.o'
  ret = `cc -x objective-c -framework LibRuby -c #{f.path} -o #{outfile} 2>&1`
  File.delete (outfile) if FileTest.exist? (outfile)
  return ret.size == 0
end

# libruby alert
unless libruby_installed? then
  print <<MSG_DEFINE
!!! Note !!!
if "LibRuby.framework" is not installed, require install it before
execute setup. type:

  % ruby tool/install-libruby-frmwk.rb  # install to /Library/Frameworks
      or
  % ruby tool/install-libruby-frmwk.rb {anywhere}  # install to anywhere
MSG_DEFINE
end

