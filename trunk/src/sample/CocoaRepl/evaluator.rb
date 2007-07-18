# -*- mode:ruby; indent-tabs-mode:nil; coding:utf-8 -*-
#
#  Evaluator.rb
#  CocoaRepl
#
#  Created by Fujimoto Hisa on 07/03/01.
#  Copyright (c) 2007 Fujimoto Hisa. All rights reserved.
#
require 'observable'

class Evaluator
  include ReplObservable
  attr_reader :history

  @@instance = nil

  def self.create(max=nil)
    self.new(max)
  end

  def self.instance
    @@instance
  end

  def initialize(max=nil)
    if @@instance then
      raise "Can't create multiple instance. use `#{self.class}.instance'"
    end
    @max = nil
    @history = []
  end

  def evaluate!(source, fname=nil, lineno=nil)
    @history.shift if @max and @history.size >= @max
    result = Result.evaluate(source, fname, lineno)
    @history << result
    notify_to_observers(:evaluate!, result)
    result
  end

  class Result
    attr_reader :source, :retval, :error, :fname, :lineno
    attr_reader :start_time, :stop_time

    def self.evaluate(source, fname=nil, lineno=nil)
      self.new(source, fname, lineno).evaluate!
    end

    def initialize(source, fname=nil, lineno=nil)
      @source = source
      @fname  = fname  || "(program)"
      @lineno = lineno || 1
      @binding = nil
      @retval = @error = nil
      @start_time = @stop_time = nil
      @done = false
    end

    def done?; @done end

    def seconds
      @start_time && @stop_time &&
        (@stop_time - @start_time)
    end

    def evaluate!(binding = nil)
      return self if @done
      begin
        @binding = binding || TOPLEVEL_BINDING
        @start_time = Time.now
        @retval = eval(@source, @binding, @fname, @lineno)
        self
      rescue => err
        @error = err
        self
      rescue Exception => err
        info = "#{err.class}: #{err.message}\n"
        err.backtrace.each { |i| info << "  #{i}\n" }
        $stderr.puts(info)
        @error = err
        self
      ensure
        @stop_time = Time.now
        @done = true
        self
      end
    end
  end
end
