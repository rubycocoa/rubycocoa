begin
  # use gems test-unit2 if enable
  require 'rubygems'
  gem('test-unit')
rescue LoadError
end
require 'test/unit'

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.configure do
    root '../'
    add_group 'Framework', 'framework'
    add_group 'Tests', 'tests'
  end
  SimpleCov.start
end

`ls tc_*.rb`.each_line do |testcase|
  testcase.chop!
  $stderr.puts testcase if $VERBOSE
  require(File.join('.', testcase ))
end

Test::Unit::AutoRunner.run
