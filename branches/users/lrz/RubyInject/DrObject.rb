#
#  DrObject.rb
#  RubyInject
#
#  Created by Laurent Sansonetti on 10/3/07.
#  Copyright (c) 2007 Laurent Sansonetti. All rights reserved.
#

class DrObject
  def evaluate(str)
    eval(str, TOPLEVEL_BINDING).inspect
  end
end

require 'drb'
require 'drb/acl'

DRb.install_acl(ACL.new(%w{deny all allow localhost}))
DRb.start_service(nil, DrObject.new)

require 'syslog'
Syslog.open
Syslog.log(Syslog::LOG_NOTICE, "DRb server started at `#{DRb.uri}'")

begin
  require 'rubygems'
  require 'dnssd'
  record = DNSSD::TextRecord.new
  record['uri'] = DRb.uri
  record['app'] = $0
  record['pid'] = Process.pid.to_s
  port = DRb.uri.scan(/:(\d+)/).to_s.to_i
  DNSSD.register("druby-inject", '_http._tcp', 'local', port, record) do
    Syslog.log(Syslog::LOG_NOTICE, 'Successfully advertised on Bonjour')
  end
rescue LoadError
end

Syslog.close

DRb.thread.join