require 'osx/foundation'
begin require 'rubygems'; rescue LoadError; end
require 'dnssd'
require 'drb'
require 'irb'

OSX.require_framework 'RubyInject'

if ARGV.size != 1
  $stderr.puts "Usage: #{__FILE__} <pid>"
  exit 1
end

def log(s)
  puts s if $VERBOSE
end

pid = ARGV.first.to_i
if pid == 0
  system("open -a TextEdit")
  sleep 1
  pid = `ps auxwww | grep "TextEdit" | grep -v grep | awk {'print $2'}`.to_i
end

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

ARGV.clear
IRB.start
