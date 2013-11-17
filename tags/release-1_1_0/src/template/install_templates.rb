#!/usr/bin/env ruby
# $Id: $
# install script for Xcode-4 project templates
# usage: ruby install_templates.rb Xcode4.x

require 'optparse'
require 'ostruct'
require 'pathname'
require 'fileutils'

class App

  def run(argv)
    config = parse(argv)
    files = filelist(config)
    install(config, files)
  end

  # parse arguments
  def parse(argv)
    config = OpenStruct.new
    config.futil_opts = {}
    config.verbose = false
    config.force = false
    config.target = '~/Library/Developer/Xcode'
    OptionParser.new(argv) do |opts|
      opts.banner = <<EOS
usage: #{File.basename(__FILE__)} [options] TEMPLATE_DIR
    TEMPLATE_DIR: Xcode4.x or Xcode4.1
EOS
      opts.on('-f', '--force', 'overwrite existing templates') {|v| config.force = v}
      opts.on('-v', '--verbose', 'print verbose message') {|v| config.verbose = v}
      opts.on('--dest=dir', 'specify install destination') {|v| config.target = v}
      opts.parse!
    end
    if argv.length != 1
      $stderr.puts ARGV.options
      exit 1
    end
    config.target = Pathname.new(config.target)
    config.src_dir = Pathname.new(__FILE__).expand_path.parent + argv.shift
    config.futil_opts[:verbose] = true if config.verbose

    return config
  end

  # get temlate files as an array of pathname from 'filelist.txt'
  def filelist(config)
    list_txt = config.src_dir + 'filelist.txt'
    raise "Bad template dir: #{config.src_dir}. \"#{list_txt}\" not found." unless list_txt.exist?
    files = list_txt.each_line.collect {|line| line.chomp}
    return files
  end

  # make symlink of template files
  def install(config, files)
    files.each do |file|
      dest = config.target.expand_path + file
      unless dest.parent.exist?
	FileUtils.mkdir_p(dest.parent, config.futil_opts)
      end
      if dest.symlink? or dest.exist?
	if config.force
	  FileUtils.rm_rf(dest, config.futil_opts)
	else
	  raise "\"#{dest}\" already exists. use --force to overwrite."
	end
      end
      FileUtils.ln_s(config.src_dir + file, dest, config.futil_opts)
    end
  end
end

if $0 == __FILE__ then
  App.new.run(ARGV)
end
