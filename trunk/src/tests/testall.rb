begin
  # use gems test-unit2 if enable
  require 'rubygems'
  gem('test-unit')
rescue LoadError
end
require 'test/unit'

if ENV['COVERAGE']
  # coverage for ruby
  require 'simplecov'
  SimpleCov.configure do
    project_name 'RubyCocoa'
    root '../'
    coverage_dir 'coverage/ruby'
    add_group 'Framework', 'framework'
    add_group 'Tests', 'tests'
    add_group 'Lib', 'lib'
  end
  SimpleCov.start
end

`ls tc_*.rb`.each_line do |testcase|
  testcase.chop!
  $stderr.puts testcase if $VERBOSE
  require(File.join('.', testcase ))
end

Test::Unit::AutoRunner.run
