install_root = @config['install-root']

# If required, backup files create here.
backup_dir = '/tmp/rubycocoa_backup'

# Install RubyCocoa.framework
frameworks_dir = File.expand_path("#{install_root}#{@config['frameworks']}")
framework_name = "#{@config['framework-name']}.framework"
framework_path = "#{frameworks_dir}/#{framework_name}"
obj_path = 'build'
if File.basename(buildcommand) == 'xcodebuild'
  if /DevToolsCore-(\d+)/.match(`#{buildcommand} -version`)
    xcode_version = $1.to_i
  else
    xcode_version = 0 # unknown(< Xcode 2.0)
  end
  obj_path = "#{obj_path}/Default" if xcode_version >= 620
end

if FileTest.exist?( framework_path ) then
  command "rm -rf '#{backup_dir}/#{framework_name}'"
  command "mkdir -p '#{backup_dir}'"
  command "mv '#{framework_path}' '#{backup_dir}/'"
end
command "mkdir -p '#{frameworks_dir}'"
command "cp -R '#{obj_path}/#{framework_name}' '#{framework_path}'"
