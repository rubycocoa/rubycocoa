# vim:sw=4:ts=8
require 'fileutils'

# Ruby documents by "yard"
yardoc = `which yardoc`.chomp
if yardoc.length > 0 && File.exist?(yardoc)
    #FileUtils.rm_r('../doc/rubycocoa.github.io/', :force => true)
    cmd = %W(#{yardoc} -o ../doc/rubycocoa.github.io --markup markdown
             --load ./tool/yard_objc_register.rb
	     --title "RubyCocoa\ Documentation"
    )
    # defined in Ruby
    cmd += Dir.glob("src/ruby/**/*.rb")
    cmd -= %w(src/ruby/osx/objc/cocoa.rb
	      src/ruby/osx/foundation.rb
	      src/ruby/osx/appkit.rb
	      src/ruby/osx/coredate.rb
	      src/ruby/osx/qtkit.rb
	      src/ruby/osx/addressbook.rb
	      src/ruby/osx/webkit.rb
	      src/ruby/osx/objc/foundation.rb
	      src/ruby/osx/objc/oc_attachments.rb
	      src/ruby/osx/objc/oc_all.rb)
    # defined in Objective-C
    cmd += %w(src/objc/cls_objcid.m
	      src/objc/cls_objcptr.m
	      src/objc/mdl_bundle_support.m
	      src/objc/mdl_objwrapper.m
	      src/objc/mdl_osxobjc.m
	      src/objc/BridgeSupport.m)
    # additional documents
    cmd += %w(--readme
	      ../doc/index.md)
    cmd += %w(--files)
    cmd.push %w(../doc/getting-started.md,
	      ../doc/try-samples.md,
	      ../doc/programming.md,
	      ../doc/resources.md).join
    command(cmd.join(' '))
end

# Objective-C documents by "headerdoc"
hd2html = `xcrun -f headerdoc2html`.chomp
gatherhd = `xcrun -f gatherheaderdoc`.chomp
if hd2html.length > 0 && File.exist?(hd2html)
    FileUtils.rm_r('../doc/rubycocoa.github.io/objc/', :force => true)
    cmd = %W(#{hd2html} -o ../doc/rubycocoa.github.io/objc)
    cmd += %w(src/objc/RubyCocoa.h src/objc/RBRuntime.h src/objc/RBObject.h)
    command(cmd.join(' '))
    cmd = %W(#{gatherhd} ../doc/rubycocoa.github.io/objc RubyCocoa.html)
    command(cmd.join(' '))
end

