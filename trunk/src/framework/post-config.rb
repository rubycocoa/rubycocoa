# create osx_ruby.h and osx_intern.h
# avoid `ID' and `T_DATA' confict headers between Cocoa and Ruby.
new_filename_prefix = 'osx_'
build_universal = (@config['build-universal'] == 'yes')
%w{ruby intern node}.map { |n|
  File.join(@config['ruby-header-dir'], n + '.h')
}.each { |src_path|
  dst_fname = new_filename_prefix + File.basename(src_path)
  dst_fname = "src/objc/" + dst_fname
  $stderr.puts "create #{File.expand_path(dst_fname)} ..."
  File.open(dst_fname, 'w') do |dstfile|
    IO.foreach(src_path) do |line|
      line.gsub!( /\b(ID|T_DATA)\b/, 'RB_\1' )
      line.gsub!( /\bintern\.h\b/, "#{new_filename_prefix}intern.h" )
      dstfile.puts( line )
    end
  end
}

if @config['gen-bridge-support'] != 'no'
  # generate bridge support metadata files
  out_dir = File.join(Dir.pwd, 'bridge-support')
  cflags = build_universal ? '-arch ppc -arch i386 -isysroot /Developer/SDKs/MacOSX10.4u.sdk' : ''
  Dir.chdir('../misc/bridgesupport') do
    command("BSROOT=\"#{out_dir}\" CFLAGS=\"#{cflags}\" #{@config['ruby-prog']} build.rb")
  end
end
