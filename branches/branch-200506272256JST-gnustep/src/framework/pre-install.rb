
# strip symbols for diet of the object file.
if @config['libtype'] == 'gnustep' then
   command "make install"
else
  install_root = @config['install-root']
  fwname = @config['framework-name']
  curdir = Dir.pwd
  build_dir = File.exists?("build/Default") ? "build/Default/" : "build/"
  Dir.chdir "#{build_dir}#{fwname}.framework/Versions/Current"
  command "strip -x #{fwname}"
  Dir.chdir curdir

  # If required, backup files create here.
  backup_dir = '/tmp/rubycocoa_backup'

  # Install RubyCocoa.framework
  frameworks_dir = File.expand_path("#{install_root}#{@config['frameworks']}")
  framework_name = "#{@config['framework-name']}.framework"
  framework_path = "#{frameworks_dir}/#{framework_name}"

  if FileTest.exist?( framework_path ) then
    command "rm -rf '#{backup_dir}/#{framework_name}'"
    command "mkdir -p '#{backup_dir}'"
    command "mv '#{framework_path}' '#{backup_dir}/'"
  end
  command "mkdir -p '#{frameworks_dir}'"
  command "cp -R '#{build_dir}#{framework_name}' '#{framework_path}'"
end
