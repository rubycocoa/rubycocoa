require 'fileutils'
include FileUtils

def die(*x)
  STDERR.puts x
  exit 1
end

if ARGV.size != 1
  die "Usage: #{__FILE__} <output-directory>"
end

out_dir = ARGV.first
if !File.exist?(out_dir) or !File.directory?(out_dir)
  die "Given #{out_dir} doesn't exist or is not a directory"
end

tmp_dir = '/tmp/rubycocoa_samples'
rm_rf tmp_dir
mkdir_p tmp_dir

succeeded, failed = [], []
sdkroot = if `uname -r`.to_f >= 12.0
	    `xcrun --sdk macosx --show-sdk-path`.chomp
	  else
	    ''
	  end
Dir.glob('*/**/*.xcodeproj').each do |sampleDir|
  name = File.dirname(sampleDir)
  Dir.chdir name do
    ary = system("xcodebuild SYMROOT=#{tmp_dir} SDKROOT=\"#{sdkroot}\" >& /dev/null") ? succeeded : failed
    ary << name
  end
end

Dir.glob(File.join(tmp_dir, '**/*.app')).each do |app|
  cp_r app, out_dir
end

[succeeded, failed].each { |a| a << 'None' if a.empty? }

puts "Successfully built samples: #{succeeded.join(', ')}"
puts "Failed built samples: #{failed.join(', ')}"
