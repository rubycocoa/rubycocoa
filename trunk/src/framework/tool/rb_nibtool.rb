#!/usr/bin/env ruby
# Copyright (c) 2006-2007, The RubyCocoa Project.
# Copyright (c) 2007 Chris Mcgrath.
# All Rights Reserved.
#
# RubyCocoa is free software, covered under either the Ruby's license or the 
# LGPL. See the COPYRIGHT file for more information.

require 'osx/cocoa'
include OSX
require 'erb'

def log(*s)
  $stderr.puts s if $DEBUG
end

def die(*s)
  $stderr.puts s
  exit 1
end

class OSX::NSObject
  class << self
    @@collect_child_classes = false
    @@subklasses = {}
    
    def collect_child_classes=(value)
      @@collect_child_classes = value
    end
    
    def collect_child_classes?
      @@collect_child_classes == true
    end
    
    def subklasses
      @@subklasses
    end
    
    def ib_outlets(*args)
      args.each do |arg|
        log "found outlet #{arg} in #{$current_class}"
        ((subklasses[$current_class] ||= {})[:outlets] ||= []) << arg
      end
    end
  
    alias_method :ns_outlet,  :ib_outlets
    alias_method :ib_outlet,  :ib_outlets
    alias_method :ns_outlets, :ib_outlets

    def ib_action(name, &blk)
      log "found action #{name} in #{$current_class}"
      ((subklasses[$current_class] ||= {})[:actions] ||= []) << name
    end
  
    alias_method :_before_classes_nib_inherited, :inherited
    def inherited(subklass)
      if collect_child_classes?
        unless subklass.to_s == ""
          log "current class: #{subklass.to_s}"
          $current_class = subklass.to_s
        end
      end
      _before_classes_nib_inherited(subklass)
    end
  end
end

class ClassesNibPlist
  attr_reader :plist
  
  def initialize(plist_path=nil)
    @plist_path = plist_path
    if plist_path and File.exist?(plist_path)
      plist_data = NSData.alloc.initWithContentsOfFile(plist_path)
      @plist, format, error = NSPropertyListSerialization.propertyListFromData_mutabilityOption_format_errorDescription(plist_data, NSPropertyListMutableContainersAndLeaves)
      die "Can't deserialize property list at path '#{plist_path}' : #{error}" if @plist.nil?
    else
      @plist = NSMutableDictionary.alloc.init
    end
    self
  end
  
  def find_ruby_class(ruby_class)
    log "Looking for #{ruby_class} in plist"
    # be nice if NSDictionary had the same methods as hash
    ruby_class_plist = nil
    classes = @plist['IBClasses']
    if classes
      classes.each do |klass|
        next unless klass['CLASS'].to_s == ruby_class
        ruby_class_plist = klass
      end
    else
      @plist['IBClasses'] = []
    end
    if ruby_class_plist.nil?
      log "Didn't find #{ruby_class} in plist, creating dictionary"
      # didn't find one, create a new one
      ruby_class_plist = NSMutableDictionary.alloc.init
      ruby_class_plist['CLASS'] = ruby_class
      ruby_class_plist['LANGUAGE'] = 'ObjC' # Hopefully one day we can put Ruby here :)
      plist['IBClasses'].addObject(ruby_class_plist)
    end
    ruby_class_plist
  end

  def write_plist_data
    if @plist_path
      log "Writing updated classes.nib plist back to file"
      #@plist.writeToFile_atomically(@plist_path, true)
      File.open(@plist_path, "w+") { |io| io.puts @plist }
    else
      log "Writing updated classes.nib plist back to standard output"
      puts @plist
    end
  end
  
  def each_class(&block)
    plist['IBClasses'].each do |klass|
      next if klass['CLASS'].to_s == 'FirstResponder'
      yield(klass)
    end
  end
end

class ClassesNibUpdater
  def self.update_nib(plist_path, ruby_file)
    plist = ClassesNibPlist.new(plist_path)
    updater = new
    updater.find_classes_outlets_and_actions(ruby_file)
    log "Found #{NSObject.subklasses.size} classes in #{ruby_file}"
    NSObject.subklasses.each do |klass, data|
      ruby_class_plist = plist.find_ruby_class(klass)
      updater.update_superclass(klass, ruby_class_plist)
      updater.add_outlets_and_actions_to_plist(klass, ruby_class_plist)
    end
    plist.write_plist_data
  end
 
  # we've taken over ns_outlets and ns_actions above, so just requiring the
  # class will cause it to be parsed an the methods to be called so we can get
  # at them
  def find_classes_outlets_and_actions(ruby_file)
    log "Getting classes, outlets and actions"
    NSObject.collect_child_classes = true
    require ruby_file
    NSObject.collect_child_classes = false
  end

  def update_superclass(ruby_class, ruby_class_plist)
    klass = ruby_class.split("::").inject(Object) { |par, const| par.const_get(const) }
    superklass = klass.superclass.to_s.sub(/OSX::/, '')
    ruby_class_plist.setObject_forKey(superklass, "SUPERCLASS")
  end
  
  def add_outlets_and_actions_to_plist(klass, ruby_class_plist)
    log "Adding outlets and actions to plist for #{klass}"
    
    updated_outlets = NSMutableDictionary.dictionary
    NSObject.subklasses[klass][:outlets].each do |outlet|
      log "adding outlet #{outlet}"
      updated_outlets.setObject_forKey('id', outlet)
    end unless NSObject.subklasses[klass][:outlets].nil?
    ruby_class_plist['OUTLETS'] = updated_outlets unless updated_outlets.count == 0
    
    updated_actions = NSMutableDictionary.dictionary
    NSObject.subklasses[klass][:actions].each do |action|
      log "adding action #{action}"
      updated_actions.setObject_forKey('id', action)
    end unless NSObject.subklasses[klass][:actions].nil?
    ruby_class_plist['ACTIONS'] = updated_actions unless updated_actions.count == 0
  end
end

class ClassesNibCreator
  def self.create_from_nib(plist_path, output_dir)
    creator = new
    plist = ClassesNibPlist.new(plist_path)
    plist.each_class { |klass| creator.create_class(output_dir, klass) }
  end
  
  def initialize
    @class_template = ERB.new(DATA.read, 0, "-")
  end
  
  def create_class(output_dir, klass)
    @class_name = klass['CLASS']
    output_file = File.join(output_dir, "#{@class_name}.rb")
    if File.exists?(output_file)
      log "#{output_file} exists, skipping"
      return
    end
    @superclass = klass['SUPERCLASS']
    if klass['OUTLETS'].nil?
      @outlets = []
    else
      @outlets = klass['OUTLETS'].allKeys.to_a
    end
    if klass['ACTIONS'].nil?
      @actions = []
    else
      @actions = klass['ACTIONS'].allKeys.to_a
    end
    log "Writing #{@class_name} to #{output_file}"
    File.open(output_file, "w+") do |file|
      file.write(@class_template.result(binding))
    end 
  end
end

require 'optparse'
class Options
  def self.parse(args)
    options = {}
    options[:update] = false
    options[:create] = false
    options[:plist] = false
    opts = OptionParser.new do |opts|
      opts.banner = "Usage: #{__FILE__} [options]"
      opts.on("-u", "--update", "Update the classes.nib file from a Ruby class",
                                "requires -f and -n options") do |update|
        options[:update] = true
      end
      opts.on("-c", "--create", "Create new Ruby classes from a nib",
                                "requires -d and -n options") do |create|
        options[:create] = true
      end
      opts.on("-p", "--plist", "Dump on standard output a property list of the Ruby class IB metadata",
                               "requires -f option") do |plist|
        options[:plist] = true
      end
      opts.on("-d", "--directory PATH", "Path to directory to create Ruby classes", "(for --create)") do |dir|
        options[:dir] = dir == "" ? nil : dir
      end
      opts.on("-f", "--file PATH", "Path to file containing Ruby class(es)", "(for --update and --plist)") do |file|
        options[:file] = file == "" ? nil : file
      end
      opts.on("-n", "--nib PATH", "Path to .nib to update") do |nib|
        options[:nib] = nib == "" ? nil : nib
      end
      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end  
    end
    opts.parse!(args)
    unless options[:update] || options[:create] || options[:plist]
      puts "Must supply --update or --create or --plist"
      exit_with_opts(opts)
    end
    if [:update, :create, :plist].map { |x| (options[x] or nil) }.compact.size > 1
      puts "Can only specify one of --update or --create or --plist"
      exit_with_opts(opts)
    end
    if options[:update]
      if options[:file].nil? || options[:nib].nil?
        puts "Must supply the ruby file and the nib paths"
        exit_with_opts(opts)
      end
    end
    if options[:create]
      if options[:dir].nil? || options[:nib].nil?
        puts "Must supply the output directory and the nib paths"
        exit_with_opts(opts)
      end
    end
    if options[:plist]
      if options[:file].nil?
        puts "Must supply the ruby file"
        exit_with_opts(opts)
      end
    end
    options
  end
  
  def self.exit_with_opts(opts)
    puts opts
    exit
  end
end

options = Options.parse(ARGV)
nib_plist = 
  if options[:nib]
    "#{options[:nib]}/classes.nib"
  else
    nil 
  end
if options[:update] || options[:plist]
  ClassesNibUpdater.update_nib(nib_plist, options[:file])
elsif options[:create]
  ClassesNibCreator.create_from_nib(nib_plist, options[:dir])
else
  puts "Unknown options"
end

# wierd indentation here seems to be needed to produce nice output
__END__
require 'osx/cocoa'
include OSX

class <%= @class_name %> < <%= @superclass %>
  <% unless @outlets.size == 0 -%>
  ib_outlets <%= @outlets.map { |o| ":#{o}" }.join(", ") -%>
  <% end -%>
  <% @actions.each do |action| %>
  ib_action :<%= action %> do |sender|
    NSLog("Need to implement <%= @class_name%>.<%= action %>")
  end
  <% end %>
end
