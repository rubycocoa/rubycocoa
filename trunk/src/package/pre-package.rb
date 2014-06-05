# $Id$

require 'erb'
require 'fileutils'

work_dir = 'work'
contents_dir = File.join(work_dir, 'files')
resources_dir = File.join(work_dir, 'resources')

def erb(src, dest, bind)
  str = ERB.new(File.new(src).read).result(bind)
  open(dest, 'w') {|f| f.write str}
end

FileUtils.rm_rf work_dir
Dir.mkdir work_dir

# .plist
erb('tmpl/Info.plist', File.join(work_dir, 'Info.plist'), binding)
erb('tmpl/Description.plist', File.join(work_dir, 'Description.plist'), binding)
erb('tmpl/product.plist', File.join(work_dir, 'product.plist'), binding)

# Resources
Dir.mkdir resources_dir
Dir.mkdir File.join(resources_dir, 'English.lproj')
Dir.mkdir File.join(resources_dir, 'Japanese.lproj')

File.link '../COPYING', File.join(resources_dir, 'License.txt')
File.link '../LGPL', File.join(resources_dir, 'LGPL')
File.link 'tmpl/ReadMe.html', 
          File.join(resources_dir, 'English.lproj', 'ReadMe.html')
File.link 'tmpl/ReadMe.ja.html', 
          File.join(resources_dir, 'Japanese.lproj', 'ReadMe.html')

# Contents
Dir.mkdir contents_dir
