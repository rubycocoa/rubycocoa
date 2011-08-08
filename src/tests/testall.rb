begin
  # use gems test-unit2 and redgreen if enable
  require 'rubygems'
rescue LoadError
end
begin
  require 'redgreen'
rescue LoadError
end
require 'test/unit'

`ls tc_*.rb`.each do |testcase|
  testcase.chop!
  $stderr.puts testcase if $VERBOSE
  require( testcase )
end
