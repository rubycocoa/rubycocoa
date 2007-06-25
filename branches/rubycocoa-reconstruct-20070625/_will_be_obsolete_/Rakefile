# -*- mode:ruby -*-
require 'rake'

task :default => :build

module RakeFileUtils
  SVN_REPOS_URL = "https://rubycocoa.svn.sourceforge.net/svnroot/rubycocoa/trunk/src"
  SVN = "/usr/bin/env svn"

  def svn(*args)
    sh "#{SVN} #{args.join(' ')}"
  end

  def svnversion
    vers = `svnversion`.strip.split(':').first
    fail "Command Failed: svnversion" if not $?.success?
    vers
  end
end

desc "build RubyCocoa.framework"
task :build do
  ruby "install.rb", "config", "--build-universal=yes"
  ruby "install.rb", "setup"
  ruby "install.rb", "test"
end

desc "unit test RubyCocoa.framework"
task :test do
  ruby "install.rb", "test"
end

desc "clean RubyCocoa.framework"
task :clean do
  ruby "install.rb", "clean"
end


desc "clean binary files RubyCocoa.framework"
task :minclean do
  chdir("framework") { rm_rf "build" }
  chdir("ext/rubycocoa") do
    %w( rubycocoa.o rubycocoa.bundle extconf.rb Makefile Makefile.bak ).each do |i|
      rm_rf i
    end
  end
end

desc "install RubyCocoa.framework"
task :install do
  ruby "install.rb", "install"
end

desc "packaging RubyCocoa"
task :package do
  rev = svnversion
  dstdir = "/tmp/rubycocoa-#{Time.now.strftime("%Y%m%d_%H%M%S")}"
  rm_rf dstdir
  svn "export", "-r", rev, SVN_REPOS_URL, dstdir
  chdir(dstdir) do
    ruby "install.rb", "config", "--build-universal=yes"
    ruby "install.rb", "setup"
    ruby "install.rb", "test"
    ruby "install.rb", "package"
  end
end

desc "build rdoc/ri document for Cocoa"
task :doc do
  ruby "install.rb", "doc"
end

desc "install rdoc/ri document for Cocoa"
task :install_doc do
  raise NotImplementedError
end
