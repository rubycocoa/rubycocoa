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
