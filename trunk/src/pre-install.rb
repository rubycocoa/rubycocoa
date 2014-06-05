install_root = @config['install-root']

# Fix Xcode projects to point to the right location of RubyCocoa.framework 
DEFAULT_FRAMEWORK_PATH = '/Library/Frameworks/RubyCocoa.framework'
TARGET_FRAMEWORK_PATH = File.join(File.expand_path("#{install_root}#{@config['frameworks']}"), 'RubyCocoa.framework')
TARGET_FRAMEWORK_PATH.sub!(/^#{ENV['DSTROOT']}/, '') if ENV['DSTROOT']
def fix_xcode_projects_in_dir(dstdir)
  return if @packaging
  Dir.glob("#{dstdir}/**/*.pbxproj") do |proj|
    txt = File.read(proj)
    if txt.gsub!(/#{DEFAULT_FRAMEWORK_PATH}/, TARGET_FRAMEWORK_PATH)
      File.open(proj, 'w') { |io| io.write(txt) }
    end
  end
end

# If required, backup files create here.
backup_dir = '/tmp/rubycocoa_backup'

xcodeextras_dir = 
  @config['xcode-extras'] ? @config['xcode-extras'].split(',').map {|path|
    File.expand_path("#{install_root}#{path}")} : nil
if @config['macosx-deployment-target'].split('.')[1].to_i >= 7 # 10.7
  # Xcode 4.x requires templates to be installed under
  # each user's ~/Library/Developer/Xcode/Templates
  pbtmpldir = nil
else
  pbtmpldir = "template/Xcode3.x/ProjectBuilder" # for Xcode 3.x
end

[xcodeextras_dir].flatten.compact.each do |extras_dir|
  break unless pbtmpldir # do not install templates into 10.7 or later
  [
    [ "#{pbtmpldir}/File",
      "#{extras_dir}/File Templates/Ruby" ],

    [ "#{pbtmpldir}/Target",
      "#{extras_dir}/Target Templates/Ruby" ],

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
    command "find '#{dstdir}' -name '*.in' -print0 | /usr/bin/xargs -0 rm"
  
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
  # install template and script for xcode 4
  if srcdir == 'doc' && @config['macosx-deployment-target'].split('.')[1].to_i >= 7 # 10.7
    command "mkdir -p '#{dstdir}/RubyCocoa/Templates'"
    ['install_templates.rb', 'Xcode4.1', 'Xcode4.x'].each do |fname|
      command "cp -R 'template/#{fname}' '#{dstdir}/RubyCocoa/Templates'"
    end
  end
  command "chmod -R #{chmod} '#{dstdir}/RubyCocoa'" if chmod

  fix_xcode_projects_in_dir(dstdir) if fix_xcode_projects
end
