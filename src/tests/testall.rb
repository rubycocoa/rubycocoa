require 'test/unit'

`ls tc_*.rb`.each do |testcase|
  require( testcase.chop )
end
