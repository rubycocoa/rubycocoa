# -*- mode:ruby; indent-tabs-mode:nil; coding:utf-8 -*-

require 'rake'

module FileUtils
  XCODEBUILD = "xcodebuild"

  def xcodebuild(*args, &block)
    options = (Hash === args.last) ? args.pop : {}
    if args.length > 1 then
      sh(*([XCODEBUILD] + args + [options]), &block)
    else
      sh("#{XCODEBUILD} #{args}", options, &block)
    end
  end
end

# setup constants for build
def const_setup(key, default = nil)
  keystr = key.to_s.upcase
  value = ENV[keystr] || BUILD_CONF[key] || default
  BUILD_CONF[key] = value
end

load "build.conf" if FileTest.file?("build.conf")

const_setup :sdk_root,     '/Developer/SDKs/MacOSX10.4u.sdk'
const_setup :ruby_program, '/usr/bin/ruby'

BUILD_CONF.each do |key, val|
  self.class.const_set(key.to_s.upcase, val)
end
