#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
#
#  This program is free software.
#  You can distribute/modify this program under the terms of
#  the GNU Lesser General Public License version 2.
#

CONF_FILE_NAME = "config.framework"

def libruby_installed?
  /ld.*Undefined\s+symbols/ =~ `cc -framework LibRuby`
end

# save framework dir
opt_frameworks = "/Library/Frameworks"
@options['config-opt'].each do |i|
  next until i =~ /^--frameworks=/
  opt_frameworks = i[2..-1]
  break
end
File.open (CONF_FILE_NAME, "w") {|f| f.puts (opt_frameworks) }

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

