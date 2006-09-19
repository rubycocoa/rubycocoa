install_root = @config['install-root']

# Fix Xcode projects to point to the right location of RubyCocoa.framework 
default_framework_path = '/Library/Frameworks/RubyCocoa.framework'
target_framework_path = File.join(File.expand_path("#{install_root}#{@config['frameworks']}"), 'RubyCocoa.framework')
target_framework_path.sub!(/^#{ENV['DSTROOT']}/, '') if ENV['DSTROOT']
def fix_xcode_projects_in_dir(dstdir)
  Dir.glob("#{dstdir}/RubyCocoa/**/*.pbxproj") do |proj|
    txt = File.read(proj)
    if txt.gsub!(/#{default_framework_path}/, target_framework_path)
      File.open(proj, 'w') { |io| io.write(txt) }
    end
  end
end

# If required, backup files create here.
backup_dir = '/tmp/rubycocoa_backup'

# Install ProjectBuilder Templates 
pbextras_dir = 
  @config['projectbuilder-extras'] ?
    File.expand_path("#{install_root}#{@config['projectbuilder-extras']}") : nil
xcodeextras_dir = 
  @config['xcode-extras'] ?
    File.expand_path("#{install_root}#{@config['xcode-extras']}") : nil
pbtmpldir = "template/ProjectBuilder"

[pbextras_dir, xcodeextras_dir].compact.each do |extras_dir|
  [
    [ "#{pbtmpldir}/File",
      "#{extras_dir}/File Templates/Ruby" ],

    [ "#{pbtmpldir}/Application/Cocoa-Ruby Application",
      "#{extras_dir}/Project Templates/Application/Cocoa-Ruby Application" ],

    [ "#{pbtmpldir}/Application/Cocoa-Ruby Document-based Application",
      "#{extras_dir}/Project Templates/Application/Cocoa-Ruby Document-based Application" ],

    [ "#{pbtmpldir}/Application/Cocoa-Ruby Core Data Application",
      "#{extras_dir}/Project Templates/Application/Cocoa-Ruby Core Data Application" ],

    [ "#{pbtmpldir}/Application/Cocoa-Ruby Core Data Document-based Application",
      "#{extras_dir}/Project Templates/Application/Cocoa-Ruby Core Data Document-based Application" ],

  ].each do |srcdir, dstdir|
    if FileTest.exist?( dstdir ) then
      backupname = File.basename( dstdir )
      command "rm -rf '#{backup_dir}/#{backupname}'"
      command "mkdir -p '#{backup_dir}'"
      command "mv '#{dstdir}' '#{backup_dir}/'"
    end
    command "mkdir -p '#{File.dirname(dstdir)}'"
    command "cp -R '#{srcdir}' '#{dstdir}'"
    command "find '#{dstdir}' -name '*.in' -print0 | xargs -0 rm"
  
    fix_xcode_projects_in_dir(dstdir) 
  end
end

# Install Examples & Document
[
  [ 'sample', "#{install_root}#{@config['examples']}", 'g+w', true ],
  [ 'doc',    "#{install_root}#{@config['documentation']}", nil, false ],

].each do |srcdir, dstdir, chmod, fix_xcode_projects|
  if File.exist?( "#{dstdir}/RubyCocoa" ) then
    command "rm -rf '#{backup_dir}/#{srcdir}'"
    command "mkdir -p '#{backup_dir}'"
    command "mv '#{dstdir}/RubyCocoa' '#{backup_dir}/#{srcdir}'"
  end
  command "mkdir -p '#{dstdir}'"
  command "cp -R '#{srcdir}' '#{dstdir}/RubyCocoa'"
  command "chmod -R #{chmod} '#{dstdir}/RubyCocoa'" if chmod

  fix_xcode_projects_in_dir(dstdir) if fix_xcode_projects
end
