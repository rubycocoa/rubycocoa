raise unless ARGV.size == 1
require 'osx/foundation'
OSX.require_framework 'RubyInject'
OSX::RubyInject.injectProcess(ARGV.first)
