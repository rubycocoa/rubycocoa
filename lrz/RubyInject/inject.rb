#
#  inject.rb
#  RubyInject
#
#  Created by Laurent Sansonetti on 10/3/07.
#  Copyright 2007 Laurent Sansonetti. Some rights reserved. 
#  <http://creativecommons.org/licenses/by/2.0/>
#

require 'osx/foundation'
begin require 'rubygems'; rescue LoadError; end
require 'dnssd'
require 'drb'

OSX.require_framework 'RubyInject'

if ARGV.size < 1 or ARGV.size > 2 
  $stderr.puts "Usage: #{__FILE__} <pid> <ruby-script>"
  exit 1
end

def log(s)
  puts s if $VERBOSE
end

pid = ARGV[0].to_i
if pid == 0
  system("open -a TextEdit")
  sleep 1
  pid = `ps auxwww | grep "TextEdit" | grep -v grep | awk {'print $2'}`.to_i
end

script = ARGV[1]

log "Injecting to pid #{pid}"
OSX::RubyInject.injectProcess(pid)

uri = nil
loop do
  log "Trying to resolve the Bonjour record..."
  s = DNSSD.resolve('druby-inject', '_http._tcp', 'local') do |r| 
    h = r.text_record
    uri = h['uri'] if h['pid'].to_i == pid
  end
  s.stop
  break if uri
end

log "Found corresponding Bonjour record, druby uri is #{uri}"

host = `hostname`.strip
uri.sub!(/#{host}/, 'localhost')

DRb.start_service
$ro = DRbObject.new(nil, uri)

if script
  log "Evaluating `#{script}'"
  $ro.evaluate(File.read(script))
else
  require 'irb'

  class IRB::WorkSpace
    def evaluate(context, statements, file = nil, line = nil)
      $ro.evaluate(statements)
    end
  end

  class IRB::Context
    def set_last_value(value)
      @last_value = value
    end
  end

  log "Connected - starting IRB"

  ARGV.clear
  IRB.start
end
