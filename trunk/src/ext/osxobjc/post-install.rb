#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
#
#  This program is free software.
#  You can distribute/modify this program under the terms of
#  the GNU Lesser General Public License version 2.
#

frmwkdir = "/Library/Frameworks"
path = File.join(curr_srcdir, 'framework/build/RubyCocoa.framework')

command "mkdir -p #{frmwkdir}"
command "rm -rf #{frmwkdir}/RubyCocoa.framework"
command "cp -R #{path} #{frmwkdir}"
