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

def frameworks_dir
  opts = File.open(CONF_FILE_NAME) {|f| f.read }
  opts.each do |line|
    a = line.split('=')
    if a[0].strip == 'frameworks' then
      return a[1].strip
    end
  end
end

frmwk_name = 'RubyCocoa.framework'
frmwk_inst_src_dir = 'build'
frmwk_inst_dst_dir = frameworks_dir

frmwk_inst_src_path = "#{frmwk_inst_src_dir}/#{frmwk_name}"
frmwk_inst_dst_path = "#{frmwk_inst_dst_dir}/#{frmwk_name}"

dive_into("framework") do
  mkdir_p frmwk_inst_dst_dir
  dst_path = "#{frmwk_inst_dst_dir}/#{frmwk_name}"
  command "rm -rf #{dst_path}.old"
  command "mv -f #{dst_path} #{dst_path}.old"
  command "cp -R #{frmwk_inst_src_path} #{frmwk_inst_dst_dir}/"
end
