# vim:sw=4:ts=8
require 'fileutils'

# Objective-C documents by "headerdoc"
hd2html = `xcrun -f headerdoc2html`.chomp
gatherhd = `xcrun -f gatherheaderdoc`.chomp
if hd2html.length > 0 && File.exist?(hd2html)
    FileUtils.rm_r('../doc/objc/', :force => true)
    cmd = %W(#{hd2html} -o ../doc/objc)
    cmd += %w(src/objc/RubyCocoa.h src/objc/RBRuntime.h src/objc/RBObject.h)
    command(cmd.join(' '))
    cmd = %W(#{gatherhd} ../doc/objc RubyCocoa.html)
    command(cmd.join(' '))
end

# TODO: Ruby documents by "yard"
yardoc = `which yardoc`.chomp
if yardoc.length > 0 && File.exist?(yardoc)
    FileUtils.rm_r('../doc/ruby/', :force => true)
    cmd = %W(#{yardoc} -o ../doc/ruby --markup markdown
             --load ./tool/yard_objc_register.rb
	     --title "RubyCocoa\ Documentation"
    )
    # defined in Ruby
#    cmd += Dir.glob("src/ruby/**/*.rb")
#    cmd -= %w(src/ruby/osx/objc/cocoa.rb
#	      src/ruby/osx/objc/oc_all.rb
#	      src/ruby/osx/objc/foundation.rb)
    # defined in Objective-C
    cmd += %w(src/objc/cls_objcid.m
	      src/objc/cls_objcptr.m
	      src/objc/mdl_bundle_support.m
	      src/objc/mdl_objwrapper.m
	      src/objc/mdl_osxobjc.m
	      src/objc/BridgeSupport.m)
    command(cmd.join(' '))
end
