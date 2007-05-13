class Mailbox < ActiveRecord::Base
  has_many :emails
  
  validates_presence_of :title
end

class MailboxProxy < ActiveRecordProxy
end
