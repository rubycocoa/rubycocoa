#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
#
#  This program is free software.
#  You can distribute/modify this program under the terms of
#  the GNU Lesser General Public License version 2.
#

frmwk_name = 'RubyCocoa.framework'
frmwk_inst_src_dir = 'build'
frmwk_inst_dst_dir = @config['frameworks']

frmwk_inst_src_path = "#{frmwk_inst_src_dir}/#{frmwk_name}"
frmwk_inst_dst_path = "#{frmwk_inst_dst_dir}/#{frmwk_name}"

dive_into("framework") do
  mkdir_p frmwk_inst_dst_dir
  dst_path = "#{frmwk_inst_dst_dir}/#{frmwk_name}"
  command "rm -rf #{dst_path}.old"
  command "mv -f #{dst_path} #{dst_path}.old" if File.exist? (dst_path)
  command "cp -R #{frmwk_inst_src_path} #{frmwk_inst_dst_dir}/"
end
