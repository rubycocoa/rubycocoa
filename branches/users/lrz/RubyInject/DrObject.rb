#
#  DrObject.rb
#  RubyInject
#
#  Created by Laurent Sansonetti on 10/3/07.
#  Copyright (c) 2007 Laurent Sansonetti. All rights reserved.
#

class DrObject
  def evaluate(str)
    eval(str).inspect
  end
end

require 'drb'
require 'drb/acl'

DRb.install_acl(ACL.new(%w{deny all allow localhost}))
DRb.start_service(nil, DrObject.new)

require 'syslog'
Syslog.open#('')
Syslog.log(Syslog::LOG_NOTICE, "DRb server started at `#{DRb.uri}'")
Syslog.close

# TODO: announce the server uri on bonjour

DRb.thread.join