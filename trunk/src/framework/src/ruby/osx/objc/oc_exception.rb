# Copyright (c) 2006-2008, The RubyCocoa Project.
# Copyright (c) 2001-2006, FUJIMOTO Hisakuni.
# All Rights Reserved.
#
# RubyCocoa is free software, covered under either the Ruby's license or the 
# LGPL. See the COPYRIGHT file for more information.

module OSX

  # Whether prints debug information or not.
  def self._debug?
    ($DEBUG || $RUBYCOCOA_DEBUG)
  end

  # Represents NSException in Ruby world.
  # @example
  #     ary = OSX::NSMutableArray.alloc.init
  #     ary.addObject(nil)
  #     => OSX::OCException: NSInvalidArgumentException - ***
  #         -[__NSArrayM insertObject:atIndex:]: object cannot be nil
  class OCException < RuntimeError

    attr_reader :name, :reason, :userInfo, :nsexception

    # @param ocexcp [OSX::NSException]
    # @param msg [String]
    def initialize(ocexcp, msg = nil)
      @nsexception = ocexcp
      @name = @nsexception.objc_send(:name).to_s
      @reason = @nsexception.objc_send(:reason).to_s
      @userInfo = @nsexception.objc_send(:userInfo)
      msg = "#{@name} - #{@reason}" if msg.nil?
      super(msg)
    end

  end

  # Raised when object conversion fails between Ruby and Objective-C.
  class OCDataConvException < RuntimeError
  end

  # Raised when message sending fails to Objective-C from Ruby.
  # @example
  #     str = OSX::NSString.stringWithString('abc')
  #     str.foo_bar_baz_
  #     => OSX::OCMessageSendException: Can't get Objective-C
  #        method signature for selector 'foo:bar:baz:' of
  #        receiver #<NSMutableString "abc">
  class OCMessageSendException < RuntimeError
  end

end
