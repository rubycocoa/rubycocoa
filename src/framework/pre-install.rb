# Install RubyCocoa.framework to FRAMEWORKS directory. If it already
# exist, it will be backupped to a file named with suffix '.backup'.
frameworks_dir = @config['frameworks']
framework_name = 'RubyCocoa.framework'
framework_path = "#{frameworks_dir}/#{framework_name}"
if FileTest.exist?(framework_path) then
  command "rm -rf #{framework_path}.backup"
  command "mv #{framework_path} #{framework_path}.backup"
end
command "cp -R build/#{framework_name} #{framework_path}"
