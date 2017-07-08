require "bundler/gem_tasks"
require "rake/testtask"
require "yard"
require "erb"

#### configuration ####

@rubycocoa_config = {}
# collect ruby's -arch flags from RbConfig::CONFIG
# => "x86_64 i386"
@rubycocoa_config[:ARCHS] =
  [RbConfig::CONFIG['CFLAGS'],
   RbConfig::CONFIG['LDFLAGS'],
   RbConfig::CONFIG['ARCH_FLAG']].join(' ').
  scan(/(?:\s?-arch\s+(\w+))/).flatten.uniq.join(' ')
# set current macOS version by default, such as "10.12"
# note: old "xcrun" does not accept --show-sdk-version
@rubycocoa_config[:MACOSX_DEPLOYMENT_TARGET] = "10.#{`uname -r`.to_i - 4}"
@rubycocoa_config[:ruby_api_version] = RbConfig::CONFIG["ruby_version"]

# merge from commandline options "--with-name=value"
ARGV.grep(/\A--with-([\w-]+)=(.+)\z/) do |option|
  case $1
  when 'macosx-deployment-target'
    @rubycocoa_config[:MACOSX_DEPLOYMENT_TARGET] = $2
  when 'sign'
    @rubycocoa_config[:DEVELOPER_SIGN_IDENTIFIER] = $2
  end
end

#### gem "rubycocoa" ####

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

namespace :test do
  sources = FileList["test/objc_bundle/*.m"]
  bundles = sources.ext("bundle")
  CLEAN.include(bundles)
  CLEAN.include(bundles.ext("dSYM"))

  task :pre_build => bundles

  rule ".bundle" => [".m"] do |t|
    cflags = '-fno-common -g -fobjc-exceptions -Wall'
    frameworks = '-framework Foundation -framework AddressBook'
    sh "cc -o #{t.name} #{cflags} -bundle #{frameworks} #{t.source}"
  end
end
task :test => ["test:pre_build"]

require "rake/extensiontask"

task :build => :compile

Rake::ExtensionTask.new("rubycocoa") do |ext|
  ext.lib_dir = "lib/rubycocoa"
end

task :default => [:clobber, :compile, :test]

task :doc => [:yard, "framework:headerdoc"]
YARD::Rake::YardocTask.new do |t|
  # register objective-c sources as yard targes
  YARD::Parser::SourceParser.register_parser_type(:objc, YARD::Parser::C::CParser, %w(m))
  YARD::Handlers::Processor.register_handler_namespace(:objc, YARD::Handlers::C)

  t.files = ["lib/**/*.rb",
             "ext/**/*.m",
             "-",
             "doc/index.md",
             "doc/getting-started.md",
             "doc/try-samples.md",
             "doc/programming.md",
             "doc/resources.md"]
end

#### RubyCocoa.framework ####
# => ./framework/
require "xcjobs"
$LOAD_PATH << "rake"
require "header_doc_task"
require "dmg_task"

@cflags_by_arch = {}
Rake::Task["compile:rubycocoa"].prerequisites.each do |t|
  next unless /\Acompile:rubycocoa:([\w\.-]+)\z/ =~ t
  arch = $1
  arch_cpu = arch.split("-")[0]
  # macOS builtin ruby "universal.x86_64" => "x86_64"
  arch_cpu = arch_cpu.split(".")[-1]
  # => "ext/2.4.0/x86_64-darwin16"
  ext_path = File.join("ext", @rubycocoa_config[:ruby_api_version], arch)
  @cflags_by_arch[arch_cpu] = " -DRUBYCOCOA_DEFAULT_EXT_DIR=#{ext_path}"
end

namespace :framework do
  desc "Compile RubyCocoa.framework"
  XCJobs::Build.new "compile" do |t|
    t.project = "framework/RubyCocoa.xcodeproj"
    t.configuration = "Default"
  end
  task "compile" => ["framework/GeneratedConfig.xcconfig",
                     "framework/Info.plist"]
  CLEAN.include("framework/build")

  Rake::Task["framework:compile"].enhance do
    Rake::Task["framework:copy:rubylibs"].invoke
  end

  # RubyCocoa.framework/Resources/
  #     ruby/{rubycocoa,osx}: .rb
  #     ext/2.4.0/x86_64-darwin16/: .bundle
  task "copy:rubylibs" => ["compile:rubycocoa"] do
    resource_dir = Pathname("framework/build/Default/RubyCocoa.framework/Resources")
    # lib
    lib_dir = resource_dir.join("ruby")
    cp_r "lib", lib_dir, {:remove_destination => true}
    # ext
    bundles = FileList["tmp/*/stage/**/*.bundle"]
    ruby_api_version = @rubycocoa_config[:ruby_api_version]
    bundles.each do |f|
      arch = f.to_s.split("/")[1] # => "x86_64-darwin16"
      ext_dir = resource_dir.join("ext", ruby_api_version, arch)
      mkdir_p ext_dir
      cp_r f, ext_dir.join(File.basename(f)), {:remove_destination => true}
    end
  end

  desc "Install RubyCocoa.framework into /Library/Frameworks"
  task :install => [:compile] do |t|
    framework_dir = Pathname("/Library/Frameworks")
    src = Pathname("framework/build/Default/RubyCocoa.framework")
    dst = framework_dir.join("RubyCocoa.framework")
    if dst.exist?
      sh(%Q(sudo rm -rf "#{dst.to_s}"))
    end
    sh(%Q(sudo cp -R "#{src.to_s}" "#{dst.to_s}"))
  end

  HeaderDoc::HeaderDocTask.new do |t|
    t.files = FileList["framework/src/objc/*.h"]
    t.output_dir = "doc/objc"
    t.toppage = "RubyCocoa.html"
  end

  desc "Build framework installer, RubyCocoa-#{RubyCocoa::VERSION}-macOS#{@rubycocoa_config[:MACOSX_DEPLOYMENT_TARGET]}.dmg"
  @dmgtask = DmgTask.new do |t|
    # RubyCocoa-2.0.0-macOS10.12
    t.package_name = "RubyCocoa-#{RubyCocoa::VERSION}-macOS#{@rubycocoa_config[:MACOSX_DEPLOYMENT_TARGET]}"
    t.version = RubyCocoa::VERSION
    t.identifier = "com.fobj.rubycocoa"
    t.sign_identity = @rubycocoa_config[:DEVELOPER_SIGN_IDENTIFIER]
    t.target_macos_version = @rubycocoa_config[:MACOSX_DEPLOYMENT_TARGET]
    t.product_plist = "package/tmpl/product.plist"
  end
  task "dmg" => ["framework:compile",
                 "package/tmpl/product.plist"]

  Rake::Task["framework:pre_dmg"].enhance() do
    Rake::Task["framework:dmg:content"].invoke
  end

  task "dmg:content" => ["compile", "build"] do
    t = @dmgtask
    # prepare install content
    framework_dir = t.pkg_files_dir + "Library/Frameworks"
    lproj_dir_en = t.pkg_resouces_dir + "English.lproj"
    lproj_dir_ja = t.pkg_resouces_dir + "Japanese.lproj"
    [framework_dir, lproj_dir_en, lproj_dir_ja].each do |dir|
      mkdir_p dir
    end
    cp_r "framework/build/Default/RubyCocoa.framework", framework_dir

    cp "COPYING", (t.pkg_resouces_dir + "License.txt")
    cp "LGPL", (t.pkg_resouces_dir + "LGPL")
    cp "package/tmpl/ReadMe.html", (lproj_dir_en + "ReadMe.html")
    cp "package/tmpl/ReadMe.ja.html", (lproj_dir_ja + "ReadMe.html")
    cp "COPYING", (t.pkg_resouces_dir + "License.txt")

    cp "COPYING", (t.dmg_files_dir + "License.txt")
    cp "LGPL", (t.dmg_files_dir + "LGPL")
    cp "package/tmpl/ReadMe.html", (t.dmg_files_dir + "ReadMe.html")
    cp "package/tmpl/ReadMe.ja.html", (t.dmg_files_dir + "ReadMe.ja.html")

    # install gem
    gemfile = "pkg/rubycocoa-#{RubyCocoa::VERSION}.gem"
    gem_home_org =
      case t.target_macos_version
      when "10.13"
        "/Library/Ruby/Gems/2.3.0"
      when "10.12"
        "/Library/Ruby/Gems/2.0.0"
      when "10.11"
        "/Library/Ruby/Gems/2.0.0"
      else
        nil
      end
    if gem_home_org
      gem_home_dst = t.pkg_files_dir.to_s + gem_home_org
      mkdir_p gem_home_dst
      installer = Gem::Installer.new(gemfile, :install_dir => gem_home_dst)
      installer.install
    end
  end
end

file "framework/GeneratedConfig.xcconfig" =>
    ["framework/GeneratedConfig.xcconfig.erb",
     "lib/rubycocoa/version.rb"] do
  process_erb("framework/GeneratedConfig.xcconfig.erb")
end
CLEAN.include("framework/GeneratedConfig.xcconfig")

file "framework/Info.plist" =>
    ["framework/Info.plist.erb",
     "lib/rubycocoa/version.rb"] do
  process_erb("framework/Info.plist.erb")
end
CLEAN.include("framework/Info.plist")

file "package/tmpl/product.plist" =>
    ["package/tmpl/product.plist.erb"] do
  process_erb("package/tmpl/product.plist.erb")
end
CLEAN.include("package/tmpl/product.plist")

def process_erb(*erbfiles)
  erbfiles.each do |infile|
    outfile  = infile.ext("") # foo.ext.erb => foo.ext
    result = ERB.new(File.read(infile)).result
    File.open(outfile, "w") do |f|
      f.write(result)
    end
  end
end

