require 'test/unit'

class TC_RubyCocoaCommand < Test::Unit::TestCase

  def setup
    @dir = "#{File.dirname(__FILE__)}/../framework/tool/rubycocoa"
  end

  def test_rubycocoa_command
    success = Dir.chdir(@dir) { system "ruby setup.rb test" }
    assert_equal true, success
  end
end
