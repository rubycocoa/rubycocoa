#
#  $Id: oc_exception.rb 1616 2007-03-02 07:56:39Z hisa $
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni
#

module OSX

  def self._verbose?
    ($VERBOSE || $RUBYCOCOA_VERBOSE) ? true : false
  end

  class OCException < RuntimeError

    attr_reader :name, :reason, :userInfo, :nsexception

    def initialize(ocexcp, msg = nil)
      @nsexception = ocexcp
      @name = @nsexception.ocm_send(:name).to_s
      @reason = @nsexception.ocm_send(:reason).to_s
      @userInfo = @nsexception.ocm_send(:userInfo)
      msg = "#{@name} - #{@reason}" if msg.nil?
      super(msg)
    end

  end

  class OCDataConvException < RuntimeError
  end

  class OCMessageSendException < RuntimeError
  end

end
