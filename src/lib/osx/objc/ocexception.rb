#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
#
#  This program is free software.
#  You can distribute/modify this program under the terms of
#  the GNU Lesser General Public License version 2.
#

require 'osx_objc'

module OSX

  class OCException < RuntimeError

    attr_reader :name, :reason, :userInfo, :nsexception

    def initialize(ocexcp)
      @nsexception = ocexcp
      @name = @nsexception.ocm_send(:name).to_s
      @reason = @nsexception.ocm_send(:reason).to_s
      @user_info = @nsexception.ocm_send(:userInfo)
      super "#{@name}:#{@reason}"
    end

  end

end
