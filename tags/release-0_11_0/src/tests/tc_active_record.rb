#
#  Copyright (c) 2007 Eloy Duran <e.duran@superalloy.nl>
#

require 'test/unit'
begin
  begin
    require 'rubygems'
  rescue LoadError
  end
  require 'osx/active_record'
  require 'sqlite3'
  
  dbfile = '/tmp/maildemo.sqlite'
  File.delete(dbfile) if File.exist?(dbfile)
  system("sqlite3 #{dbfile} < #{ File.join(File.dirname( File.expand_path(__FILE__) ), 'maildemo.sql') }")

  ActiveRecord::Base.establish_connection({
    :adapter => 'sqlite3',
    :dbfile => dbfile
  })

  class Mailbox < ActiveRecord::Base
    has_many :emails
  
    validates_presence_of :title
  end

  class MailboxProxy < OSX::ActiveRecordProxy
  end

  class Email < ActiveRecord::Base
    belongs_to :mailbox
  end

  class EmailProxy < OSX::ActiveRecordProxy
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

  class FakePointer
    attr_reader :value
    def initialize; @value = nil; end
    def assign(value); @value = value; end
  end

  class TC_ActiveRecord < Test::Unit::TestCase
  
    def setup
      # when we need more complex tests here should probably go some code that flushes the db
    end
  
    def test_activerecord_to_proxy
      mailbox = Mailbox.new({'title' => 'foo'})
      mailbox.save
    
      proxy = mailbox.to_activerecord_proxy
      assert proxy.is_a?(MailboxProxy)
      assert_equal mailbox, proxy.to_activerecord
    
      assert Mailbox.find(:all).to_activerecord_proxies.first.is_a?(MailboxProxy)
    end
  
    def test_proxy_initialization
      before = Mailbox.count
      proxy1 = MailboxProxy.alloc.init({'title' => 'foo'})
      assert Mailbox.count == (before + 1)
      assert proxy1.title == 'foo'
    
      before = Mailbox.count
      proxy2 = MailboxProxy.alloc.init(proxy1.to_activerecord)
      assert Mailbox.count == before
      assert_equal proxy1.to_activerecord, proxy2.to_activerecord
    end
  
    def test_proxy_record_class
      assert Mailbox.find(:first).to_activerecord_proxy.record_class == Mailbox
    end
  
    def test_proxy_is_association?
      proxy = Mailbox.find(:first).to_activerecord_proxy
      assert proxy.is_association?('emails')
      assert !proxy.is_association?('title')
    end
  
    def test_proxy_method_forwarding
      mailbox = Mailbox.find(:first).to_activerecord_proxy
      assert Mailbox.find(:first).title == mailbox.title
    end
  
    def test_proxy_set_and_get_value_for_key
      mailbox = MailboxProxy.alloc.init({'title' => 'bla'})
      mailbox.setValue_forKey( [EmailProxy.alloc.init({'subject' => 'whatever', 'body' => 'foobar'})], 'emails' )
  
      assert mailbox.valueForKey('title').to_s == 'bla'
      assert mailbox.valueForKey('emails')[0].valueForKey('subject').to_s == 'whatever'
    
      # check the ability to override the valueForKey method in a subclass
      assert mailbox.valueForKey('emails')[0].valueForKey('body').is_a?(OSX::NSAttributedString)
    end
  
    def test_proxy_validate_value_for_key_with_error
      mailbox = Mailbox.find(:first).to_activerecord_proxy
      before = mailbox.title
      pointer = FakePointer.new
      result = mailbox.validateValue_forKeyPath_error([''], 'title', pointer)
    
      assert result == false
      assert mailbox.title == before
      assert pointer.value.is_a?(OSX::NSError)
      assert pointer.value.userInfo[OSX::NSLocalizedDescriptionKey].to_s == "Mailbox title can't be blank\n"
    end
  
  end

rescue LoadError
  $stderr.puts 'Skipping osx/active_record tests, you need to have active_record and sqlite3'
end
