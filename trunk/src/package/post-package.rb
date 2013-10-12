# $Id$

require 'rexml/document'
require 'rexml/formatters/pretty'

work_dir = File.expand_path('work')
contents_dir = File.join(work_dir, 'files')
resources_dir = File.join(work_dir, 'resources')

system "find '#{contents_dir}' -name .svn -exec rm -rf {} \\; >& /dev/null"

package_name = "RubyCocoa-#{@config['rubycocoa-version']}-OSX#{@config['macosx-deployment-target']}"
dmg_dir = File.join(work_dir, package_name)
Dir.mkdir dmg_dir

# set permissions
['/Developer', '/Developer/Documentation', '/Developer/Examples',
 '/Library/Application Support'].each do |dir|
  target_dir = File.join(contents_dir, dir)
  File.chmod(0775, target_dir) if File.exist?(target_dir)
end

pkgmaker = '/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker'
pkgbuild = `which pkgbuild`.chomp
productbuild = `which productbuild`.chomp

if productbuild.length > 0 && File.exist?(productbuild)
  # generate .pkg with pkgbuild and productbuild
  dist_dir = File.join(work_dir, 'dist')
  Dir.mkdir dist_dir

  # collect files into .pkg
  str = %Q!"#{pkgbuild}" ! +
	%Q!--root "#{contents_dir}" ! +
	%Q!--ownership recommended ! +
	%Q!--identifier "com.fobj.rubycocoa" ! +
	%Q!--version "#{@config['rubycocoa-version']}" ! +
	%Q!"#{File.join(dist_dir, package_name)}.pkg" !
  command str
  # generate dist.xml
  str = %Q!"#{productbuild}" ! +
	%Q!--synthesize ! +
	%Q!--product "#{File.join(work_dir, 'product.plist')}" ! +
	%Q!--package "#{File.join(dist_dir, package_name)}.pkg" ! +
	%Q!"#{File.join(dist_dir, 'dist_base.xml')}" !
  command str
  xml = REXML::Document.new(File.read(File.join(dist_dir, 'dist_base.xml')))
  el_title = REXML::Element.new('title', xml.root)
  el_title.text = 'RubyCocoa'
  el_license = REXML::Element.new('license', xml.root)
  el_license.add_attributes('file' => 'License.txt')
  el_license = REXML::Element.new('readme', xml.root)
  el_license.add_attributes('file' => 'ReadMe.html')
  File.open(File.join(dist_dir, 'dist.xml'), 'w') do |f|
    pf = REXML::Formatters::Pretty.new
    pf.write(xml, f)
  end
  # complete .pkg
  str = %Q!"#{productbuild}" ! +
	%Q!--distribution "#{File.join(dist_dir, 'dist.xml')}" ! +
	%Q!--resources "#{resources_dir}" ! +
	%Q!--package-path "#{dist_dir}" ! +
	%Q!"#{File.join(dmg_dir, package_name)}.pkg" !
  command str
else
  begin
    command "sudo chown -R root:admin \"#{contents_dir}\""
    if @config['macosx-deployment-target'].to_f >= 10.7
      command "sudo chgrp wheel \"#{File.join(contents_dir, '/Library')}\""
      command "sudo chgrp -R wheel " +
	      "\"#{File.join(contents_dir, '/Library/Ruby')}\" " +
	      "\"#{File.join(contents_dir, '/Library/Frameworks')}\""
    end

    # generate .pkg with PackageMaker.app
    str = %Q!"#{pkgmaker}" -build ! +
	  %Q!-p "#{File.join(dmg_dir, package_name)}.pkg" ! +
	  %Q!-f "#{contents_dir}" -r "#{resources_dir}" ! +
	  %Q!-i "#{File.join(work_dir, 'Info.plist')}" ! +
	  %Q!-d "#{File.join(work_dir, 'Description.plist')}" !
    system str
    stat = $?.to_i / 256
    if stat != 0 and stat != 1 # PackageMaker of 10.4 returns 1 (bug)
      raise RuntimeError, "'system #{str}' failed(#{stat})"
    end
  ensure
    # revert owner
    command "sudo chown -R `/usr/bin/id -un` \"#{contents_dir}\""
  end
end

%w(License.txt ../../../ReadMe.html ../../../ReadMe.ja.html
  ../../../LGPL).each do |f|
  File.link(File.join(resources_dir, f), File.join(dmg_dir, File.basename(f)))
end

command %Q!/usr/bin/hdiutil create ! +
	%Q!-srcfolder "#{dmg_dir}" ! +
	%Q!-format UDZO -tgtimagekey zlib-level=9 ! +
	%Q!-fs HFS+ -volname "#{package_name}" ! +
	%Q!"#{File.join(work_dir, package_name)}.dmg" !

