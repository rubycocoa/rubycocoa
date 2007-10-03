system("open -a textedit")
sleep 1
pid = `ps auxwww | grep TextEdit | grep -v grep | awk {'print $2'}`.to_i
require 'osx/foundation'
OSX.require_framework 'RubyInject'
OSX::RubyInject.injectProcess(pid)
