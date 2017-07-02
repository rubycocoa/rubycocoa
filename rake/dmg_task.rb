require 'rake'
require 'rake/tasklib'
require 'erb'
require 'rexml/document'
require 'rexml/formatters/pretty'

class DmgTask < Rake::TaskLib

  attr_accessor :name
  attr_accessor :package_name, :version, :identifier
  attr_accessor :sign_identity
  attr_accessor :target_macos_version, :product_plist
  attr_accessor :pkgbuild_cmd, :productbuild_cmd
  
  attr_reader :pkg_files_dir, :pkg_resouces_dir, :dmg_files_dir
  def initialize(name = :dmg)
    @name = name
    @version = nil
    @pkgbuild_cmd = `xcrun -f pkgbuild`.chomp
    @productbuild_cmd = `xcrun -f productbuild`.chomp

    @target_macos_version = `xcrun --show-sdk-version`.chomp
    @product_plist = 'product.plist'

    rm_rf "tmp/dmg"
    @pkg_files_dir = Pathname('tmp/dmg/pkg_files')
    @pkg_resouces_dir = Pathname('tmp/dmg/pkg_resources')
    @pkg_dist_dir = Pathname('tmp/dmg/pkg_dist')
    @dmg_files_dir = Pathname('tmp/dmg/dmg_files')
    [@pkg_resouces_dir, @pkg_resouces_dir,
     @pkg_dist_dir, @dmg_files_dir].each do |dir|
      mkdir_p dir
    end

    yield self if block_given?

    raise RuntimeError '"package_name" is required' unless @package_name
    raise RuntimeError '"version" is required' unless @version
    raise RuntimeError '"identifier" is required' unless @identifier

    define
  end

  protected

  def define
    desc "Generate installer .dmg" unless Rake.application.last_description
    task(self.name) do
      package_path = @pkg_dist_dir + "#{@package_name}.pkg"
      dist_base_xml = @pkg_dist_dir.join('dist_base.xml')

      rm_f "#{@package_name}.dmg"
      # collect files into .pkg
      sh(@pkgbuild_cmd,
          '--root', @pkg_files_dir.to_s, '--ownership', 'recommended',
          '--identifier', @identifier, '--version', @version,
          package_path.to_s)
      # generate dist.xml
      sh(@productbuild_cmd,
          '--synthesize', '--product', @product_plist.to_s,
          '--package', package_path.to_s, dist_base_xml.to_s)

      xml = REXML::Document.new(dist_base_xml.read)
      el_title = REXML::Element.new('title', xml.root)
      el_title.text = 'RubyCocoa'
      el_license = REXML::Element.new('license', xml.root)
      el_license.add_attributes('file' => 'License.txt')
      el_license = REXML::Element.new('readme', xml.root)
      el_license.add_attributes('file' => 'ReadMe.html')
      el_allowed_versions = REXML::Element.new('allowed-os-versions', xml.root)
      el_os_version = REXML::Element.new('os-version', el_allowed_versions)
      major, minor, _ = @target_macos_version.split('.')
      curr_os = [major, minor].join('.')
      next_os = [major, (minor.to_i + 1).to_s].join('.') # 10.9 => 10.10
      el_os_version.add_attributes('min' => curr_os, 'before' => next_os)
      @pkg_dist_dir.join('dist.xml').open('w') do |f|
        pf = REXML::Formatters::Pretty.new
        pf.write(xml, f)
      end
      # complete .pkg
      cmd = [@productbuild_cmd,
          '--distribution', (@pkg_dist_dir + 'dist.xml').to_s,
          '--resources', @pkg_resouces_dir.to_s,
          '--package-path', @pkg_dist_dir.to_s,
          (@dmg_files_dir + "#{@package_name}.pkg").to_s]
      if @sign_identity
        cmd.insert(1, ['--sign', @sign_identity]).flatten!
      end
      sh(*cmd)
      # generate dmg
      sh('/usr/bin/hdiutil', 'create',
          '-srcfolder', @dmg_files_dir.to_s,
          '-format', 'UDZO', '-tgtimagekey', 'zlib-level=9',
          '-fs', 'HFS+', '-volname', @package_name,
          "#{@package_name}.dmg")
    end
  end
end
