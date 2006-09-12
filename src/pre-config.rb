# create a real project.pbxproj file by applying libruby
# configuration.

target_files = %w[
  ext/rubycocoa/extconf.rb
  framework/GeneratedConfig.xcconfig
  framework/src/objc/Version.h
  template/ProjectBuilder/Application/Cocoa-Ruby\ Application/CocoaApp.pbproj/project.pbxproj
  template/ProjectBuilder/Application/Cocoa-Ruby\ Core\ Data\ Application/CocoaApp.xcode/project.pbxproj
  template/ProjectBuilder/Application/Cocoa-Ruby\ Core\ Data\ Document-based\ Application/CocoaDocApp.xcode/project.pbxproj
  template/ProjectBuilder/Application/Cocoa-Ruby\ Document-based\ Application/CocoaDocApp.pbproj/project.pbxproj
]

config_ary = [
  [ :frameworks,      @config['frameworks'] ],
  [ :ruby_header_dir, @config['ruby-header-dir'] ],
  [ :libruby_path,    @config['libruby-path'] ],
  [ :libruby_path_dirname,  File.dirname(@config['libruby-path']) ],
  [ :libruby_path_basename, File.basename(@config['libruby-path']) ],
  [ :rubycocoa_version,      @config['rubycocoa-version'] ],
  [ :rubycocoa_release_date, @config['rubycocoa-release-date'] ],
  [ :build_dir, framework_obj_path ],
]

# build options
cflags = '-fno-common -g -fobjc-exceptions'
ldflags = '-undefined suppress -flat_namespace'
sdkroot = ''

if @config['build-universal'] == 'yes'
  cflags << ' -arch ppc -arch i386'
  ldflags << ' -arch ppc -arch i386'

  sdkroot = '/Developer/SDKs/MacOSX10.4u.sdk'
  cflags << ' -isysroot ' << sdkroot
  ldflags << ' -Wl,-syslibroot,' << sdkroot

  # validation
  raise "ERROR: SDK \"#{sdkroot}\" does not exist." unless File.exist?(sdkroot)
  #libruby_sdk = File.join(sdkroot, @config['libruby-path'])
  libruby_sdk = @config['libruby-path']
  raise "ERROR: library \"#{libruby_sdk}\" does not exists." unless File.exist?(libruby_sdk)
end

if File.exists?('/usr/include/libxml2') and File.exists?('/usr/lib/libxml2.dylib')
  cflags << ' -I/usr/include/libxml2 -DHAS_LIBXML2 '
  ldflags << ' -lxml2 '
else
  puts "libxml2 is not available!"
end

# Add the libffi library to the build process.
unless File.exists?('/usr/lib/libffi.a')
  if File.exists?('/usr/local/lib/libffi.a') and File.exists?('/usr/local/include/libffi')
    cflags << ' -I/usr/local/include/libffi '
    ldflags << ' -L/usr/local/lib '
  else
    cflags << ' -I../../misc/libffi/include -I../misc/libffi/include ' 
    ldflags << ' -L../../misc/libffi -L../misc/libffi '
  end
end
cflags << ' -DMACOSX '
ldflags << ' -lffi '

config_ary << [ :other_cflags, cflags ]
config_ary << [ :other_ldflags, ldflags ]

target_files.each do |dst_name|
  src_name = dst_name + '.in'
  data = File.open(src_name) {|f| f.read }
  config_ary.each do |sym, str|
    data.gsub!( "%%%#{sym}%%%", str )
  end
  File.open(dst_name,"w") {|f| f.write(data) }
  $stderr.puts "create #{dst_name}"
end
