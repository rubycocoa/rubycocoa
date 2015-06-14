begin
  # use gems test-unit2 if enable
  require 'rubygems'
  gem('test-unit')
rescue LoadError
end
require 'test/unit'

base_dir = File.expand_path(File.join(File.dirname(__FILE__), ".."))
test_dir = File.join(base_dir, "test")

if ENV['COVERAGE']
  # coverage for ruby
  require 'simplecov'
  SimpleCov.configure do
    project_name 'RubyCocoa'
    root base_dir
    coverage_dir 'coverage/ruby'
    add_group 'Framework', 'framework'
    add_group 'Tests', 'test'
    add_group 'Lib', 'lib'
  end
  SimpleCov.start
end

exit Test::Unit::AutoRunner.run(true, test_dir)
