begin
  # use gems test-unit2 if enable
  require 'rubygems'
  gem('test-unit')
rescue LoadError
end
require 'test/unit'

`ls tc_*.rb`.each do |testcase|
  testcase.chop!
  $stderr.puts testcase if $VERBOSE
  require( testcase )
end
