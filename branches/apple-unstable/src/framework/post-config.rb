# create osx_ruby.h and osx_intern.h
# avoid `ID' and `T_DATA' confict headers between Cocoa and Ruby.
new_filename_prefix = 'osx_'
ruby_h = File.join(@config['ruby-header-dir'], 'ruby.h')
intern_h = File.join(@config['ruby-header-dir'], 'intern.h')
[ ruby_h, intern_h ].each do |src_path|
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
end

# generate bridge support metadata files for Cocoa & its dependencies. 
command('mkdir -p bridge-support')
[['Foundation', '/System/Library/Frameworks/Foundation.framework'],
 ['AppKit', '/System/Library/Frameworks/AppKit.framework'],
# FIXME: CoreGraphics does not process yet
# ['CoreGraphics', '/System/Library/Frameworks/ApplicationServices.framework/Frameworks/CoreGraphics.framework']
].each do |framework, path|
  out = "bridge-support/#{framework}.xml"
  generator = '/usr/bin/gen_bridge_metadata'
  generator = 'ruby tool/gen_bridge_metadata.rb' unless File.exists?(generator)
  unless File.exists?(out)  
    $stderr.puts "create #{out} ..."
    command("#{generator} -f #{path} > #{out}") 
  end
end
