#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
#

frmwk_name = 'RubyCocoa.framework'
frmwk_inst_src_dir 'build'
frmwk_inst_dst_dir = '/Library/Frameworks'

frmwk_inst_src_path = "#{frmwk_inst_src_dir}/#{frmwk_name}"
frmwk_inst_dst_path = "#{frmwk_inst_dst_dir}/#{frmwk_name}"

dive_into("framework") do
  mkdir_p frmwk_inst_dst_dir
  rm_rf   frmwk_inst_dst_path
  command "cp -R #{frmwk_inst_src_path} #{frmwk_inst_dst_dir}/"
end

