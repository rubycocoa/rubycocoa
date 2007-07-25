require "rubygems"
require 'osx/cocoa'
require 'osx/initializer'

include OSX

# We have to copy this directory over first if we are building for Release.
# If we are just launching an application (DYLD_LIBRARY_PATH doesn't exist), skip this step
if RUBYCOCOA_ENV == 'release' && ENV['DYLD_LIBRARY_PATH']
  `cp -R #{Pathname.new(ENV['DYLD_LIBRARY_PATH'] + "../../../").cleanpath}/config #{OSX::NSBundle.mainBundle.bundlePath.fileSystemRepresentation}/config`
end

def rb_main_init
  path = OSX::NSBundle.mainBundle.resourcePath.fileSystemRepresentation
  require 'config/boot'
  rbfiles = Dir.entries(path).select {|x| /\.rb\z/ =~ x}
  rbfiles -= [ File.basename(__FILE__) ]
  rbfiles.each do |path|
    require( File.basename(path) )
  end
end

if $0 == __FILE__ then
  rb_main_init
  OSX.NSApplicationMain(0, nil)
end
