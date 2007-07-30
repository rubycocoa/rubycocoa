# -*- mode:ruby; indent-tabs-mode:nil; coding:utf-8 -*-


build_root = File.dirname(File.expand_path(__FILE__))

cflags       = "-arch ppc -arch i386 -isysroot #{SDK_ROOT}"
bsroot       = "BridgeSupport"


desc "build externals (libffi and BridgeSupport)"
task :build => ['libffi:build', 'bs:build']

desc "clean externals (libffi and BridgeSupport)"
task :clean => ['libffi:clean', 'bs:clean']

namespace :libffi do

  desc "build libffi.a"
  task :build do
    chdir File.join(build_root, "libffi") do
      sh 'make -f Makefile.rubycocoa'
    end
  end

  desc "clean libffi"
  task :clean do
    chdir File.join(build_root, "libffi") do
      sh 'make -f Makefile.rubycocoa clean'
    end
  end
end

desc "BridgeSupport tasks"
namespace :bs do

  desc "build BridgeSupport files"
  task :build do
    chdir File.join(build_root, "bridgesupport") do
      sh "BSROOT='#{bsroot}' CFLAGS='#{cflags}' #{RUBY} build.rb"
    end
  end

  desc "clean bridgesupport"
  task :clean do
    chdir File.join(build_root, "bridgesupport") do
      rm_rf bsroot
    end
  end
end
