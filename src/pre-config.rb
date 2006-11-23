# create a real project.pbxproj file by applying libruby
# configuration.

target_files = %w[
  ext/rubycocoa/extconf.rb
  framework/GeneratedConfig.xcconfig
  framework/src/objc/Version.h
]

target_files.concat Dir.glob('template/ProjectBuilder/Application/**/*.pbxproj.in').collect {|tmpl| tmpl.sub(/\.in\Z/, '')}

config_ary = [
  [ :frameworks,      @config['frameworks'] ],
  [ :ruby_header_dir, @config['ruby-header-dir'] ],
  [ :libruby_path,    @config['libruby-path'] ],
  [ :libruby_path_dirname,  File.dirname(@config['libruby-path']) ],
  [ :libruby_path_basename, File.basename(@config['libruby-path']) ],
  [ :rubycocoa_version,       @config['rubycocoa-version'] ],
  [ :rubycocoa_version_short, @config['rubycocoa-version-short'] ],
  [ :rubycocoa_release_date,  @config['rubycocoa-release-date'] ],
  [ :rubycocoa_svn_revision,  @config['rubycocoa-svn-revision'] ],
  [ :build_universal,         @config['build-universal'] ],
  [ :build_dir, framework_obj_path ],
]

# build options
cflags = '-fno-common -g -fobjc-exceptions'
ldflags = '-flat_namespace'

sdkroot = ''
arch = '$NATIVE_ARCH'
if @config['build-universal'] == 'yes'
  arch = 'ppc i386'
  sdkroot = '/Developer/SDKs/MacOSX10.4u.sdk'

  # validation
  raise "ERROR: SDK \"#{sdkroot}\" does not exist." unless File.exist?(sdkroot)
  #libruby_sdk = File.join(sdkroot, @config['libruby-path'])
  libruby_sdk = @config['libruby-path']
  raise "ERROR: library \"#{libruby_sdk}\" does not exists." unless File.exist?(libruby_sdk)
else
end
config_ary << [ :archs, arch ]
config_ary << [ :sdkroot, sdkroot ]

if File.exists?('/usr/include/libxml2') and File.exists?('/usr/lib/libxml2.dylib')
    cflags << ' -I/usr/include/libxml2 -DHAS_LIBXML2 '
    ldflags << ' -lxml2 '
else
    puts "libxml2 is not available!"
end

config_ary << [ :other_cflags, cflags ]
config_ary << [ :other_ldflags, ldflags ]

if /\.a\Z/ =~ @config['libruby-path'] 
  # libruby-static.a: static library
  config_ary << [ :libruby_ldflags, @config['libruby-path']  ]
  config_ary << [ :generate_master_object_file, 'YES' ]
else
  # libruby.dylib: dynamic library
  config_ary << [ :libruby_ldflags, '-lruby'  ]
  config_ary << [ :generate_master_object_file, 'NO' ]
end

target_files.each do |dst_name|
  src_name = dst_name + '.in'
  data = File.open(src_name) {|f| f.read }
  config_ary.each do |sym, str|
    data.gsub!( "%%%#{sym}%%%", str )
  end
  File.open(dst_name,"w") {|f| f.write(data) }
  $stderr.puts "create #{dst_name}"
end
