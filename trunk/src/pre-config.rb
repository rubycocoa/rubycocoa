# create a real project.pbxproj file by applying libruby
# configuration.

target_files = %w[
  ext/rubycocoa/extconf.rb
  ext/rubycocoa/rubycocoa.m
  framework/RubyCocoa.pbproj/project.pbxproj
  framework/src/objc/RBObject.h
  framework/src/objc/RBSlaveObject.h
  framework/src/objc/RubyCocoa.h
  framework/src/objc/Version.h
]

config_ary = [
  [ :frameworks,      @config['frameworks'] ],
  [ :framework_name,  @config['framework-name'] ],
  [ :ruby_header_dir, @config['ruby-header-dir'] ],
  [ :libruby_path,    @config['libruby-path'] ],
  [ :libruby_path_dirname,  File.dirname(@config['libruby-path']) ],
  [ :libruby_path_basename, File.basename(@config['libruby-path']) ],
  [ :rubycocoa_version,      @config['rubycocoa-version'] ],
  [ :rubycocoa_release_date, @config['rubycocoa-release-date'] ],
  [ :build_dir, framework_obj_path ],
]

# build options from environment
def ENV.merge(key, *value)
  self[key] = [self[key], value].join(' ')
end

if ENV.has_key? 'SDKROOT' 
  if /-isyslibroot/ =~ ENV['LDFLAGS'].to_s
    $deferr.print 'warning: ignore $SDKROOT, $LDFLAGS contains "-isyslibroot"'
  else
    ENV.merge('CFLAGS', '-sysroot', ENV['SDKROOT'])
    ENV.merge('LDFLAGS', '-syslibroot', ENV['SDKROOT'])
  end
end

config_ary << [ :other_cflags, '-fno-common ' + ENV['CFLAGS'].to_s ]
config_ary << [ :other_ldflags, '-undefined suppress -flat_namespace ' + ENV['LDFLAGS'].to_s ]

target_files.each do |dst_name|
  src_name = dst_name + '.in'
  data = File.open(src_name) {|f| f.read }
  config_ary.each do |sym, str|
    data.gsub!( "%%%#{sym}%%%", str )
  end
  File.open(dst_name,"w") {|f| f.write(data) }
  $stderr.puts "create #{dst_name}"
end
