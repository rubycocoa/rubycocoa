require 'gen_bridge_metadata'
require 'pathname'
require 'fileutils'

include FileUtils

SLF = '/System/Library/Frameworks'
SLPF = '/System/Library/PrivateFrameworks'

frameworks = {}
%w{
  CoreFoundation
  Foundation
  AppKit
  CoreData
  WebKit
  AddressBook
  InstantMessage
  QuartzCore
  SyncServices
  OpenGL
  QTKit
}.each { |n| frameworks[n] = "#{SLF}/#{n}.framework" }

frameworks['CoreGraphics'] = "#{SLF}/ApplicationServices.framework/Frameworks/CoreGraphics.framework"
frameworks['ImageIO'] = "#{SLF}/ApplicationServices.framework/Frameworks/ImageIO.framework"
frameworks['PDFKit'] = "#{SLF}/Quartz.framework/Frameworks/PDFKit.framework"
frameworks['QuartzComposer'] = "#{SLF}/Quartz.framework/Frameworks/QuartzComposer.framework"

special_flags_32 = {
}

special_flags = {
  'AppKit' => '-include /System/Library/Frameworks/QuickTime.framework/Headers/Movies.h',

  'CoreGraphics' => '-framework ApplicationServices -F/System/Library/Frameworks/ApplicationServices.framework/Frameworks -include /System/Library/Frameworks/OpenGL.framework/Headers/CGLTypes.h',

  'ImageIO' => '-framework ApplicationServices -F/System/Library/Frameworks/ApplicationServices.framework/Frameworks',

  'QuartzCore' => '-framework QuartzCore -include /System/Library/Frameworks/OpenGL.framework/Headers/CGLTypes.h'
}

frameworks.delete_if { |fname, path| !ARGV.include?(fname) } unless ARGV.empty?

def measure(something)
  elapsed = Time.now
  yield
  $stderr.puts "    #{something} (#{Time.now - elapsed} seconds)"
end

dstroot = (ENV['DSTROOT'] or '')
dir = '/Library/BridgeSupport'

frameworks.sort.each do |fname, path|
  file = "#{dir}/#{fname}.bridgesupport"

  # Check if the bridge support file isn't already in the DSTROOT. 
  out_dir = File.join(dstroot, dir)
  out_file = File.join(dstroot, file)
  next if File.exist?(out_file) and File.size(out_file) > 0

  # We have work!
  $stderr.puts "Generating BridgeSupport metadata for: #{fname} ..."
  elapsed = Time.now
  
  # Create a new generator object, configure it accordingly for a first 32-bit pass.
  gen = BridgeSupportGenerator.new
  gen.frameworks << path

  exceptions = "exceptions/#{fname}.xml"
  if File.exist?(exceptions)
    gen.exception_paths << exceptions
  end

  if flags = (special_flags_32[fname] or special_flags[fname])
    gen.compiler_flags = flags 
  end

  # Collect 32-bit metadata.
  measure('Collect metadata') { gen.collect }

  # Merge both metadata in the first generator object, and write it.
  measure('Write final metadata') do
    mkdir_p(out_dir)
    gen.out_file = out_file
    gen.write
  end

  # Validate.
  measure('Validate XML') do
    unless system("xmllint --dtdvalid ./BridgeSupport.dtd --nowarning --noout \"#{out_file}\"")
      $stderr.puts "Error: `#{out_file}' doesn't validate against BridgeSupport.dtd"
      exit 1
    end
  end

  # Generate inline dynamic library if required.
  if gen.has_inline_functions?
    measure('Generate dylib file') do
      gen.generate_format = BridgeSupportGenerator::FORMAT_DYLIB
      gen.out_file = "#{out_dir}/#{fname}.dylib"
      gen.write
    end
  end
  gen.cleanup

  $stderr.puts "Done (#{Time.now - elapsed} seconds)."
end
