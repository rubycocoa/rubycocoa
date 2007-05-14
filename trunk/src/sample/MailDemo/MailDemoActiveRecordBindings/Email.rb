#
#  Copyright (c) 2007 Eloy Duran <e.duran@superalloy.nl>
#

class Email < ActiveRecord::Base
  belongs_to :mailbox
  
  validates_presence_of :address
  validates_format_of :address,
                      :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
                      :message => 'is not a valid email address'
  
  validates_presence_of :subject
end

class EmailProxy < ActiveRecordProxy
  def rbValueForKey(key)
    if key.to_s == 'body'
      # The NSTextField expects a NSAttributedString
      str = original_record[key.to_s]
      if str.nil?
        return OSX::NSAttributedString.alloc.init
      else
        return OSX::NSAttributedString.alloc.initWithString(str)
      end
    else
      # For any other keys simply call super.
      # Note that we don't use super_rbValueForKey
      # because rbValueForKey is a method defined on the ruby side of the bridge.
      return super
    end
  end
end
