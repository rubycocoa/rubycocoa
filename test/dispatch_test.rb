require 'test/unit'
require 'osx/cocoa'

system 'make -s' || raise(RuntimeError, "'make' failed")
require './objc_test.bundle'

class DispatchReceiver
  def optional_arg(arg, optional_arg = nil)
    [arg, optional_arg]
  end
end

class TC_Dispatch < Test::Unit::TestCase
  def test_optional_arg
    receiver = DispatchReceiver.new
    result = OSX::CallerClass.callOnReceiver_arg_optionalArg(receiver, 'arg', 'optional_arg')
    assert_equal ['arg', 'optional_arg'], result
  end
end
