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

  attr_reader :path, :cpp_result, :framework, :externname

  def initialize(path)
    @path = path
    @cpp_result = OCHeaderAnalyzer.do_cpp(path)
    if /AppKit/ =~ path then
      @externname = "APPKIT_EXTERN"
      @framework = "AppKit"
    elsif /Foundation/ =~ path then
      @externname = "FOUNDATION_EXPORT"
      @framework = "Foundation"
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
    if str == '...' then
      VarInfo.new('...', '...', str)
    else
      str += "dummy" if str[-1].chr == '*'
      re = /^([^()]*)\b(\w+)\b(\[\])*$/
      m = re.match(str.strip)
      if m then
	m = m.to_a[1..-1].compact.map{|i|i.strip}
	m[0] += m[2] if m.size == 3
	m[0] = 'void' if m[1] == 'void'
	VarInfo.new(m[0],m[1],str)
      end
    end
  end

  def OCHeaderAnalyzer.function?(str)
    re = /^(.*)\((.*)\)$/
    m = re.match(str.strip)
    if m then
      func = constant?(m[1])
      if func then
	args = m[2].split(',').map{|i|
	  ai = constant?(i)
	  ai = VarInfo.new('unknown', 'unknown', i) if ai.nil?
	  ai
	}
	args = [] if args.size == 1 && args[0].type == 'void'
	FuncInfo.new(func, args, str)
      end
    end
  end

  def OCHeaderAnalyzer.octype_of(str)
    case str.strip
    when 'id' then :_C_ID
    when 'Class' then :_C_ID
    when 'void' then :_C_VOID
    when 'SEL'  then :_C_SEL
    when 'BOOL' then :_PRIV_C_BOOL
    when 'NSRect' then :_PRIV_C_NSRECT
    when 'NSPoint' then :_PRIV_C_NSPOINT
    when 'NSSize' then :_PRIV_C_NSSIZE
    when /^unsigned\s+char$/ then :_C_UCHR
    when 'char' then '_C_CHR'
    when /^unsigned\s+short(\s+int)?$/ then :_C_USHT
    when /^short(\s+int)?$/ then :_C_SHT
    when /^unsigned\s+int$/ then :_C_UINT
    when 'int' then :_C_INT
    when /^unsigned\s+long(\s+int)?$/ then :_C_ULNG
    when /^long(\s+int)?$/ then :_C_LNG
    when 'float' then :_C_FLT
    when 'double' then :_C_DBL
    when /char\s*\*$/ then :_C_CHARPTR
    when /\*$/ then :_C_PTR
    else :UNKNOWN
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
    attr_accessor :octype

    def initialize(type, name, orig)
      @type = type
      @name = name
      @orig = orig
      @octype = OCHeaderAnalyzer.octype_of(type)
    end

    def to_s
      @orig
    end

  end

  class FuncInfo < VarInfo

    attr_reader :args, :argc

    def initialize(func, args, orig)
      super(func.type, func.name, orig)
      @args = args
      @argc = @args.size
      if @args[-1].type == '...' then
	@argc = -1
	@args.pop
      end
      self
    end

    def to_s
      @orig
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
