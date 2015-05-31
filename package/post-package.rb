# $Id$

require 'rexml/document'
require 'rexml/formatters/pretty'

work_dir = File.expand_path('work')
contents_dir = File.join(work_dir, 'files')
resources_dir = File.join(work_dir, 'resources')

system "find '#{contents_dir}' -name .svn -exec rm -rf {} \\; >& /dev/null"

package_name = @config['package-name']
package_name ||= "RubyCocoa-#{@config['rubycocoa-version']}-OSX#{@config['macosx-deployment-target']}"

dmg_dir = File.join(work_dir, package_name)
Dir.mkdir dmg_dir

# set permissions
['/Developer', '/Developer/Documentation', '/Developer/Examples',
 '/Library/Application Support'].each do |dir|
  target_dir = File.join(contents_dir, dir)
  File.chmod(0775, target_dir) if File.exist?(target_dir)
end

pkgbuild = `which pkgbuild`.chomp
productbuild = `which productbuild`.chomp

unless productbuild.length > 0 && File.exist?(productbuild)
  raise "command 'productbuild' not found"
end

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
el_allowed_versions = REXML::Element.new('allowed-os-versions', xml.root)
el_os_version = REXML::Element.new('os-version', el_allowed_versions)
major, minor = @config['macosx-deployment-target'].split('.', 2)
next_os = [major, (minor.to_i + 1).to_s].join('.') # 10.9 => 10.10
el_os_version.add_attributes('min' => @config['macosx-deployment-target'], 'before' => next_os)
File.open(File.join(dist_dir, 'dist.xml'), 'w') do |f|
  pf = REXML::Formatters::Pretty.new
  pf.write(xml, f)
end
# complete .pkg
if opt_sign = @options['sign-identity']
  opt_sign = '--sign "' + opt_sign + '" '
end
str = %Q!"#{productbuild}" ! + opt_sign.to_s +
      %Q!--distribution "#{File.join(dist_dir, 'dist.xml')}" ! +
      %Q!--resources "#{resources_dir}" ! +
      %Q!--package-path "#{dist_dir}" ! +
      %Q!"#{File.join(dmg_dir, package_name)}.pkg" !
command str

%w(License.txt LGPL
    ../../tmpl/ReadMe.html ../../tmpl/ReadMe.ja.html).each do |f|
  File.link(File.join(resources_dir, f), File.join(dmg_dir, File.basename(f)))
end

command %Q!/usr/bin/hdiutil create ! +
	%Q!-srcfolder "#{dmg_dir}" ! +
	%Q!-format UDZO -tgtimagekey zlib-level=9 ! +
	%Q!-fs HFS+ -volname "#{package_name}" ! +
	%Q!"#{File.join(work_dir, package_name)}.dmg" !

