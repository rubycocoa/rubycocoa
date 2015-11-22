# create a real project.pbxproj file by applying libruby
# configuration.

require 'rbconfig'

target_files = %w[
  ext/rubycocoa/extconf.rb
  framework/GeneratedConfig.xcconfig
  framework/src/objc/Version.h
  test/Makefile
]

install_path = @config['build-as-embeddable'] == 'yes' \
  ? "@executable_path/../Frameworks" \
  : @config['frameworks'].sub((ENV['DSTROOT'] or ''), '')

config_ary = [
  [ :frameworks,      @config['frameworks'] ],
  [ :ruby_header_paths, [@config['ruby-header-dir'], @config['ruby-archheader-dir']].uniq.join(' ') ],
  [ :rubycocoa_version,      @config['rubycocoa-version'] ],
  [ :rubycocoa_version_short,   @config['rubycocoa-version-short'] ],
  [ :rubycocoa_release_date, @config['rubycocoa-release-date'] ],
  [ :rubycocoa_svn_revision,  @config['rubycocoa-svn-revision'] ],
  [ :rubycocoa_framework_version,  @config['rubycocoa-framework-version'] ],
  [ :macosx_deployment_target, @config['macosx-deployment-target'] ],
  [ :build_dir, framework_obj_path ],
  [ :install_path, install_path ]
]

# build options
cflags = '-fno-common -g -fobjc-exceptions -Wall'
ldflags = '-undefined suppress -flat_namespace'
sdkroot = @config['sdkroot']
archs = @config['target-archs']
other_header_search_paths = []

# do not link statib ruby into the framework
if RbConfig::CONFIG["ENABLE_SHARED"] == 'yes'
  config_ary << [ :libruby_path, @config['libruby-path'] ]
  config_ary << [ :libruby_path_dirname, File.dirname(@config['libruby-path']) ]
else
  config_ary << [ :libruby_path, '' ]
  config_ary << [ :libruby_path_dirname, '' ]
end

# add archs if given
arch_flags = archs.gsub(/\A|\s+/, ' -arch ')

if sdkroot.size > 0
  cflags << ' -isysroot ' << sdkroot
  ldflags << ' -Wl,-syslibroot,' << sdkroot
end

cflags << ' -DRB_ID=ID'

def lib_exist?(path, sdkroot=@config['sdkroot'])
  File.exist?(File.join(sdkroot, path))
end

if lib_exist?('/usr/include/libxml2') and
    (lib_exist?('/usr/lib/libxml2.dylib') || lib_exist?('/usr/lib/libxml2.tbd'))
  cflags << ' -DHAS_LIBXML2 '
  other_header_search_paths << '/usr/include/libxml2'
  ldflags << ' -lxml2 '
else
  raise "ERROR: libxml2 not found!"
end

# Add the libffi library to the build process.
if !lib_exist?('/usr/lib/libffi.a') and
    !lib_exist?('/usr/lib/libffi.dylib') and !lib_exist?('/usr/lib/libffi.tbd')
  if lib_exist?('/usr/local/lib/libffi.a') and lib_exist?('/usr/local/include/ffi')
    cflags << ' -I/usr/local/include/ffi '
    ldflags << ' -L/usr/local/lib '
  else
    raise "ERROR: libffi not found!"
  end
else
  other_header_search_paths << '/usr/include/ffi'
end
cflags << ' -DMACOSX '
ldflags << ' -lffi '

config_ary << [ :other_cflags, cflags ]
config_ary << [ :other_ldflags, ldflags ]
config_ary << [ :other_header_search_paths, other_header_search_paths.join(' ') ]
config_ary << [ :target_archs, archs.size > 0 ? archs : '$NATIVE_ARCH' ]
config_ary << [ :arch_flags, archs.size > 0 ? arch_flags : '' ]
config_ary << [ :build_ruby_version, RUBY_VERSION ]

target_files.each do |dst_name|
  src_name = dst_name + '.in'
  data = File.open(src_name) {|f| f.read }
  config_ary.each do |sym, str|
    data.gsub!( "%%%#{sym}%%%", str )
  end
  File.open(dst_name,"w") {|f| f.write(data) }
  $stderr.puts "create #{dst_name}"
end
