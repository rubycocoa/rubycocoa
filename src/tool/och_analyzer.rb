#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
#
#  This program is free software.
#  You can distribute/modify this program under the terms of
#  the GNU Lesser General Public License version 2.
#

ARCH = `arch`.chop
CPP_TARGET_CPU = "TARGET_CPU_#{ARCH.upcase}"
CPP_ARCH = "__#{ARCH.downcase}__"
CPP_ENDIAN = "__BIG_ENDIAN__"

class OCHeaderAnalyzer

  attr_reader :path, :cpp_result

  def initialize(path)
    @path = path
    @cpp_result = OCHeaderAnalyzer.do_cpp(path)
    @externname = 
      if /AppKit/ =~ path then
	"APPKIT_EXTERN"
      elsif /Foundation/ =~ path then
	"FOUNDATION_EXPORT"
      end
  end

  def setExternName(str)
    @externname = str
  end

  def filename
    File.basename(@path)
  end

  def enums
    if @enums.nil? then
      re = /\benum\b.*{([^}]*)}/
      @enums = @cpp_result.scan(re).map {|m|
	m[0].split(',').map {|i|
	  i.split('=')[0].strip
	}.delete_if {|i| i == "" }
      }.flatten.uniq
    end
    @enums
  end

  def externs
    if @externs.nil? then
      re = /^#{@externname}\s+\b(.*);.*$/
      @externs = @cpp_result.scan(re).map {|m| m[0].strip }
    end
    @externs
  end

  def constants
    if @constants.nil? then
      @constants = externs.map{ |i|
	OCHeaderAnalyzer.constant?(i)
      }.compact
    end
    @constants
  end

  def functions
    if @functions.nil? then
      @functions = externs.map{ |i|
	OCHeaderAnalyzer.function?(i)
      }.compact
    end
    @functions
  end

  private

  def OCHeaderAnalyzer.constant?(str)
    re = /^([^()]*)\b(\w+)\b(\[\])*$/
    m = re.match(str.strip)
    if m then
      m = m.to_a[1..-1].compact.map{|i|i.strip}
      m[0] += m[2] if m.size == 3
      VarInfo.new(m[0],m[1],str)
    end
  end

  def OCHeaderAnalyzer.function?(str)
    re = /^(.*)\((.*)\)$/
    m = re.match(str.strip)
    if m then
      func = constant?(m[1])
      if func then
	args = m[2].split(',').map{|i| constant?(i)}.compact
	FuncInfo.new(func, args, str)
      end
    end
  end

  def OCHeaderAnalyzer.do_cpp(path)
    f_on = false
    cppflags = [ CPP_TARGET_CPU, CPP_ARCH, CPP_ENDIAN ].map {|i|
      "-D#{i}"
    }.join(' ')
    `cpp #{cppflags} -lang-objc #{path}`.select { |s|
      next if /^\s*$/ =~ s
      m = %r{^#\s*\d+\s+".*/(\w+\.h)"}.match(s)
      f_on = (m[1] == File.basename(path)) if m
      f_on
    }.join
  end

  class VarInfo

    attr_reader :type, :name, :orig

    def initialize(type, name, orig)
      @type = type
      @name = name
      @orig = orig
    end

    def to_s
      @orig
    end

    def inspect
      "<name=#{@name} type=#{@type}>"
    end

  end

  class FuncInfo < VarInfo

    attr_reader :args

    def initialize(func, args, orig)
      super(func.type, func.name, orig)
      @args = args
    end

    def to_s
      @orig
    end

    def inspect
      "#{super} [ #{args.map{|i|i.inspect}.join(', ')} ]"
    end

  end

end

if __FILE__ == $0 then
  est = cst = fst = 0
  ARGV.each do |path|
    ar = OCHeaderAnalyzer.new(path)
    es, cs, fs = ar.enums.size, ar.constants.size, ar.functions.size
    printf "%s enums=%d constants=%d funcs=%d\n",
      ar.filename.ljust(30), es, cs, fs
    est, cst, fst = est + es, cst + cs, fst + fs
  end
  puts "enums     total: #{est}"
  puts "constants total: #{cst}"
  puts "functions total: #{fst}"
end
