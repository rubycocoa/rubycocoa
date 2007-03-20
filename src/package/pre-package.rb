# $Id$

require 'erb'

work_dir = 'work'
contents_dir = File.join(work_dir, 'files')
resources_dir = File.join(work_dir, 'resources')

def erb(src, dest, bind)
  str = ERB.new(File.new(src).read).result(bind)
  open(dest, 'w') {|f| f.write str}
end

`rm -rf "#{work_dir}"` if File.exist? work_dir
Dir.mkdir work_dir

# .plist
erb('tmpl/Info.plist', File.join(work_dir, 'Info.plist'), binding)
erb('tmpl/Description.plist', File.join(work_dir, 'Description.plist'), binding)

# Resources
Dir.mkdir resources_dir
Dir.mkdir File.join(resources_dir, 'English.lproj')
Dir.mkdir File.join(resources_dir, 'Japanese.lproj')

File.link '../COPYING', File.join(resources_dir, 'License.txt')
File.link '../ReadMe.ascii.html', 
  File.join(resources_dir, 'English.lproj', 'ReadMe.html')
File.link '../ReadMe.sjis.html', 
  File.join(resources_dir, 'Japanese.lproj', 'ReadMe.html')

if @config['build-universal'] == 'yes'
  postflight = File.join(resources_dir, 'postflight')
  erb('tmpl/postflight-universal.rb', postflight, binding)
  File.chmod(0755, postflight)
end

# contents
Dir.mkdir contents_dir
