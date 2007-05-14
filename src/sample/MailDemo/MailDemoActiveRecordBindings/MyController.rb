#
#  Copyright (c) 2007 Eloy Duran <e.duran@superalloy.nl>
#

class MyController < NSObject
  
  kvc_accessor :mailboxes
  
  def init
    if super_init
      @mailboxes = Mailbox.find(:all).to_activerecord_proxies
      return self
    end
  end

end
