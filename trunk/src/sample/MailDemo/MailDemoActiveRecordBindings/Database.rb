#
#  Copyright (c) 2007 Eloy Duran <e.duran@superalloy.nl>
#

# Connect to the database
ActiveRecord::Base.establish_connection({
  :adapter => 'sqlite3',
  :dbfile => "#{ File.dirname(File.expand_path(__FILE__)) }/maildemo.sqlite"
})
