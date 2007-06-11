#!ruby
# vim:ts=2:sw=2:expandtab:
require 'test/unit'
require 'fileutils'
require 'pp'
require 'pathname'
require 'iconv'
ENV["RUBYLIB"] = "#{(Pathname.new(File.dirname(__FILE__))+"../lib").realpath}:#{ENV["RUBYLIB"]}"
ENV["PATH"]    = "#{(Pathname.new(File.dirname(__FILE__))+"../bin").realpath}:#{ENV["PATH"]}"
include FileUtils

class RubyCocoaCommandTest < Test::Unit::TestCase
  def setup
    @testdir   = Pathname.new(File.dirname(__FILE__)).realpath
    @rubycocoa = @testdir + '../bin/rubycocoa'
  end

  def teardown
    rm_rf 'Test Ruby Cocoa'
  end

  def test_load
    assert true
  end

  def test_create
    create
    cd 'Test Ruby Cocoa' do
      files = Dir['**/*']
      assert files.include?("Test Ruby Cocoa.xcodeproj"), "Check .xcodeproj"
      assert files.include?("Test Ruby Cocoa.xcodeproj/project.pbxproj"), "Check .pbxproj"
      assert_no_match /«PROJECTNAMEASXML»/, File.read("Info.plist")
      assert_no_match /PROJECTNAME/, Iconv.conv("ISO-8859-1", "UTF-16", File.read("English.lproj/InfoPlist.strings"))
      assert_no_match /PROJECTNAME/, File.read("rb_main.rb")
      assert_no_match /PROJECTNAME/, File.read("main.m")
    end
  end

  def test_convertnib
    create
    cd 'Test Ruby Cocoa' do
      cp_r @testdir + 'Main.nib', '.'
      system(@rubycocoa, "convert", "Main.nib")
      res = Pathname.new 'AppController.rb'
      assert res.exist?, 'Create Converted .rb'

      time = res.mtime
      system(@rubycocoa, "convert", "Main.nib")
      assert_equal time, res.mtime, 'No overwrite existed .rb'

      assert File.exist?("ConfigController.rb")
    end
  end

  def test_convertheader
    create
    cd 'Test Ruby Cocoa' do
      cp_r @testdir + 'AppController.h', '.'
      system(@rubycocoa, "convert", "AppController.h")
      res = Pathname.new 'AppController.rb'
      assert res.exist?, 'Create Converted .rb'
    end
  end

  def test_updatenib
    create
    cd 'Test Ruby Cocoa' do
      cp_r @testdir + 'BulletsController.rb', '.'
      system(@rubycocoa, "update", "-a", "English.lproj/MainMenu.nib", "BulletsController.rb")
    end
  end

  def test_add
    create
    cd 'Test Ruby Cocoa' do
      cp_r @testdir + 'BulletsController.rb', '.'
      system(@rubycocoa, "add", "BulletsController.rb", "Test Ruby Cocoa.xcodeproj")
      system("xcodebuild")
      assert File.exist?("build/Release/Test Ruby Cocoa.app/Contents/Resources/BulletsController.rb")
    end
  end

  def test_package
    create
    cd "Test Ruby Cocoa" do
      system("rake", "package")
      assert File.exists?("pkg/Test Ruby Cocoa.#{Time.now.strftime("%Y-%m-%d")}.dmg")
    end
  end

  def create(num=0)
    template = @testdir + "../../../../template/ProjectBuilder/Application/Cocoa-Ruby Application"
    IO.popen("#{@rubycocoa} new --template '#{template}' 'Test Ruby Cocoa'", "r+") do |f|
      f.puts num
      puts f.read
    end
  end
end
