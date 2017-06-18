require 'test/unit'
require 'osx/cocoa'

system 'make -s' || raise(RuntimeError, "'make' failed")
require './objc_test.bundle'
OSX.ns_import :HybridClass if RUBY_VERSION >= '2.0'

class OSX::HybridClass
  def imethod
    42
  end
  objc_method :imethod

  def self.cmethod
    42
  end
  objc_class_method :cmethod
end

class TC_Hybrid < Test::Unit::TestCase
  def test_hybrid
    OSX::HybridClass.startTests
  end
end
