#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
#
#  This program is free software.
#  You can distribute/modify this program under the terms of
#  the GNU Lesser General Public License version 2.
#

require 'osx/objc/foundation'

module OSX

  class RubyThreadSwitcher < OSX::NSObject

    @@instance = nil

    class << self

      def start (interval = 0.1)
	unless @@instance then
	  @@instance = self.alloc.initWithInterval(interval)
	end
      end

    end				# class << self

    def sched(timer)
      Thread.pass unless Thread.critical
    end

    def initWithInterval (interval)
      OSX::NSTimer.scheduledTimerWithTimeInterval (interval,
        :target, self, :selector, :sched_, :userInfo, nil, :repeats, true)
      init
    end

  end

end
