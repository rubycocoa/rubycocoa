#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
#
#  This program is free software.
#  You can distribute/modify this program under the terms of
#  the GNU Lesser General Public License version 2.
#

savedir = Dir.pwd

Dir.chdir File.join(curr_srcdir, "framework")
system "pbxbuild"

Dir.chdir savedir
