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
  /ld.*Undefined\s+symbols/ =~ `cc -framework LibRuby`
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

