# -*- mode:ruby; indent-tabs-mode:nil; coding:utf-8 -*-
#
#  load_cocoa_repl.rb
#  CocoaRepl
#
#  Created by Fujimoto Hisa on 07/03/01.
#  Copyright (c) 2007 FUJIMOTO Hisa, FOBJ SYSTEMS. All rights reserved.
#
$KCODE = 'utf-8'
require 'osx/cocoa'

# $DEBUG = true
# $VERBOSE = true

INSPECT_MAX = 80

class Object
  def self.def_truncated_inspect(prefix_len, suffix)
    if defined? inspect and not defined? original_inspect then
      alias_method  :original_inspect, :inspect
      define_method :inspect do
        ret = original_inspect
        if ret.size > INSPECT_MAX
        then  "#{ret[0, INSPECT_MAX - prefix_len - suffix.size]}#{suffix}"
        else  ret  end
      end
    end
  end
end

class Object; def_truncated_inspect 2, "...>" end
class Array;  def_truncated_inspect 1, "...]" end
class Hash;   def_truncated_inspect 1, "...}" end
class String; def_truncated_inspect 1, '..."' end

def load_decorator
  require 'decorator'
  (ARGV.size > 0 && Decorator.require_decorator(ARGV.shift.to_sym)) ||
    %w( syntax ripper simple ).find { |i| Decorator.require_decorator(i.to_sym) }
end

def create_window(opts = {})
  frame = opts[:frame] || [10,10,640,480]
  title = opts[:title]
  win = OSX::NSWindow.alloc.
    objc_send( :initWithContentRect, frame,
               :styleMask, OSX::NSTitledWindowMask + OSX::NSResizableWindowMask,
               :backing, OSX::NSBackingStoreBuffered,
               :defer, false )
  win.setTitle(title) if title
  win.makeKeyAndOrderFront(nil)
  win
end

ARGV.delete_if {|i| /-psn/ =~ i }

OSX.init_for_bundle do |bdl,prm,lgr|
  load_decorator
  require 'RubyProgramTextView'
  require 'ReplController'
end
