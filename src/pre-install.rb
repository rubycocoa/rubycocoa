install_root = @config['install-root']

# If required, backup files create here.
backup_dir = '/tmp/rubycocoa_backup'

# Install ProjectBuilder Templates 
pbextras_dir = File.expand_path("#{install_root}#{@config['projectbuilder-extras']}")
pbtmpldir = "template/ProjectBuilder"
[
  [ "#{pbtmpldir}/File",
    "#{pbextras_dir}/File Templates/Ruby" ],

  [ "#{pbtmpldir}/Application/Cocoa-Ruby Application",
    "#{pbextras_dir}/Project Templates/Application/Cocoa-Ruby Application" ],

  [ "#{pbtmpldir}/Application/Cocoa-Ruby Document-based Application",
    "#{pbextras_dir}/Project Templates/Application/Cocoa-Ruby Document-based Application" ],

].each do |srcdir, dstdir|
  if FileTest.exist?( dstdir ) then
    backupname = File.basename( dstdir )
    command "rm -rf '#{backup_dir}/#{backupname}'"
    command "mkdir -p '#{backup_dir}'"
    command "mv '#{dstdir}' '#{backup_dir}/'"
  end
  command "mkdir -p '#{File.dirname(dstdir)}'"
  command "cp -R '#{srcdir}' '#{dstdir}'"
end

# Install Examples & Document
[
  [ 'sample', "#{install_root}#{@config['examples']}" ],
  [ 'doc',    "#{install_root}#{@config['documentation']}" ],

].each do |srcdir, dstdir|
  if File.exist?( "#{dstdir}/RubyCocoa" ) then
    command "rm -rf '#{backup_dir}/#{srcdir}'"
    command "mkdir -p '#{backup_dir}'"
    command "mv '#{dstdir}/RubyCocoa' '#{backup_dir}/#{srcdir}'"
  end
  command "mkdir -p '#{dstdir}'"
  command "cp -R '#{srcdir}' '#{dstdir}/RubyCocoa'"
end
