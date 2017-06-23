require "bundler/gem_tasks"
require "rake/testtask"
require "erb"

@rubycocoa_config = {}
# collect ruby's -arch flags from RbConfig::CONFIG
# => "x86_64 i386"
@rubycocoa_config[:ARCHS] =
  [RbConfig::CONFIG['CFLAGS'],
   RbConfig::CONFIG['LDFLAGS'],
   RbConfig::CONFIG['ARCH_FLAG']].join(' ').
  scan(/(?:\s?-arch\s+(\w+))/).flatten.uniq.join(' ')

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

#### RubyCocoa.framework ####
# => ./framework/
require "xcjobs"

desc "Compile RubyCocoa.framework"
XCJobs::Build.new "compile:framework" do |t|
  t.project = "framework/RubyCocoa.xcodeproj"
  t.configuration = "Default"
end
task "compile:framework" => ["framework/GeneratedConfig.xcconfig"]

file "framework/GeneratedConfig.xcconfig" =>
    ["framework/GeneratedConfig.xcconfig.erb",
     "lib/rubycocoa/version.rb"] do
  process_erb("framework/GeneratedConfig.xcconfig.erb")
end

def process_erb(*erb_files)
  erb_files.each do |src|
    target = src.ext("") # foo.ext.erb => foo.ext
    result = ERB.new(File.read(src)).result
    File.open(target, "w") do |f|
      f.write(result)
    end
  end
end

