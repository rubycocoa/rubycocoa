#
#  Copyright (c) 2007 Eloy Duran <e.duran@superalloy.nl>
#

class MyController < NSObject
  
  kvc_accessor :mailboxes
  
  def init
    if super_init
      if database_needs_migration?
        ActiveRecord::Migrator.migrate(File.join(RUBYCOCOA_ROOT, 'db', 'migrate'))
      else
        @mailboxes = Mailbox.find(:all).to_activerecord_proxies
      end
      return self
    end
  end

end
