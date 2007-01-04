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
TIGER_OR_LOWER = `uname -r`.strip.to_f < 9.0
if @config['gen-bridge-support'] != 'no'
  command('mkdir -p bridge-support')
  [['/System/Library/Frameworks/CoreFoundation.framework', nil],
   ['/System/Library/Frameworks/Foundation.framework', nil],
   ['/System/Library/Frameworks/AppKit.framework', nil],
   ['/System/Library/Frameworks/WebKit.framework', nil],
   ['/System/Library/Frameworks/ApplicationServices.framework/Frameworks/CoreGraphics.framework', '-c "-framework ApplicationServices" -c -F/System/Library/Frameworks/ApplicationServices.framework/Frameworks'],
   ['/System/Library/Frameworks/Quartz.framework/Frameworks/PDFKit.framework', nil],
   ['/System/Library/Frameworks/QuartzCore.framework', nil],
   ['/System/Library/Frameworks/OpenGL.framework', nil],
   ['/System/Library/Frameworks/QTKit.framework', TIGER_OR_LOWER ? '' : '-c -DQT_BUILDING_ON_LEOPARD_OR_LATER -c "-framework QTKit"'],
   ['/System/Library/Frameworks/AddressBook.framework', nil],
   ['/System/Library/Frameworks/InstantMessage.framework', nil],
  ].each do |path, special_flags|
    framework = File.basename(path, '.framework')
    out = "bridge-support/#{framework}.xml"
    if !File.exists?(out) or File.size(out) == 0 or File.mtime('tool/gen_bridge_metadata.rb') > File.mtime(out)
      generator = "#{@config['ruby-prog']} tool/gen_bridge_metadata.rb"
      generator << " #{special_flags}" if special_flags
      generator << " -f #{path}"
      exceptions = "bridge-support-exceptions/#{framework}.xml"
      generator << " -e #{exceptions}" if File.exists?(exceptions)
      generator << " -o #{out}"
      $stderr.puts "create #{out} ..."
      command(generator) 
    end
    # Uncomment this to launch the verification tool on each metadata file.
    # Warning: this can take some time, and there are several false positives.
    #$stderr.puts "verify #{out} ..."
    #system("#{@config['ruby-prog']} tool/verify_bridge_metadata.rb #{out} #{File.join(path, 'Headers')}")
  end
end
