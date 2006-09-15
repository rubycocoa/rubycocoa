#!/usr/bin/env ruby
# Created by Laurent Sansonetti, 2006/08/31
# Copyright (c) 2006 Apple Computer Inc.
# Copyright (c) 2005-2006 FUJIMOTO Hisakuni

require 'rexml/document'
require 'dl/import'
require 'dl/struct'
require 'fileutils'

class OCHeaderAnalyzer
  attr_reader :path, :cpp_result, :framework, :externname

  CPP = ['/usr/bin/cpp-4.0', '/usr/bin/cpp-3.3', '/usr/bin/cpp3'].find { |x| File.exists?(x) }
  raise "cpp not found" if CPP.nil?
  CPPFLAGS = "-x objective-c -D__APPLE_CPP__"
  CPPFLAGS << "-D__GNUC__" unless /\Acpp-4/.match(File.basename(CPP))

  def initialize(path)
    @path = path
    @cpp_result = OCHeaderAnalyzer.do_cpp(path)
    @externname = "extern"
    if ma = /\b(\w+)\.framework\b/.match(path)
      @framework = ma[1]
    end
  end

  def filename
    File.basename(@path)
  end

  def enum_types
    if @enum_types.nil?
      re = /\btypedef\s+enum\s*\w*\s*\{[^\}]*\}\s*(\w+)\s*;/m
      @enum_types = @cpp_result.scan(re).flatten
    end
    return @enum_types
  end

  def typedefs
    if @typedefs.nil?
      @typedefs = {} 
      re = /\btypedef\s+([\w\s]+)\s*;/m
      @cpp_result.scan(re).each do |line|
        t = line.first.split(/\s/)
        # new type -> type 
        @typedefs[t[-1]] = t[0..-2].join(' ')
      end
    end
    return @typedefs
  end

  def enums
    if @enums.nil?
      re = /\benum\b.*\{([^}]*)\}/
      @enums = @cpp_result.scan(re).map {|m|
        m[0].split(',').map {|i|
          i.split('=')[0].strip
        }.delete_if {|i| i == "" }
      }.flatten.uniq
      if filename == 'NSWindow.h' # window level support
        File.open(path) do |f|
          re = /^#define\s+(NS\w+Level)\s+k[[:upper:]]\w+$/
          @enums += f.read.scan(re)
        end 
      end
    end
    @enums
  end

  def externs
    if @externs.nil?
      re = /^#{@externname}\s+\b(.*);.*$/
      @externs = @cpp_result.scan(re).map {|m| m[0].strip }
    end
    @externs
  end

  def constants
    if @constants.nil?
      @constants = externs.map{ |i|
        constant?(i)
      }.compact
    end
    @constants
  end

  def functions
    if @functions.nil?
      @functions = externs.map{ |i|
        function?(i)
      }.compact
    end
    @functions
  end

  def informal_protocols
    re = /^\s*(@interface\s+(\w+)\s*\(\s*(\w+)\s*\))\s*$([^@]*)^\s*@end\s*$/m
    re_type = /(-|\+)\s*\(\s*([^)]*)\s*\)/
    @cpp_result.scan(re).map! { |m|
      porig = m[0].strip
      pbase = m[1]
      pname = m[2]
      entries = m[3].strip.split(';').map{|i| i.strip }
      entries.map! {|i|
        i.strip!
        mm = re_type.match(i)
        return_type = mm ? mm[2].strip : 'id'
        selector = i.split(':').map do |ii|
          /(\b\w+|\.{3})$/.match(ii.strip)[0]
        end
        selector = if selector.size <= 1
          selector[0]
        else
          selector[0...-1].join(':')
        end
        InformalProtocolEntry.new(i, return_type, selector)
      }
      InformalProtocol.new(porig, pbase, pname, entries)
    }
  end

  def ocmethods
    if @ocmethods.nil?
      interface_re = /^@(interface|protocol)\s+(\w+)/
      end_re = /^@end/
      body_re = /^[-+]\s*(\([^)]+\))?\s*([^:\s;]+)/
      args_re = /(\w+)\s*\:\s*(\([^)]+\))?\s*\w+/
      current_interface = nil
      @ocmethods = {} 
      @cpp_result.each_line do |line|
        line.strip!
        if md = interface_re.match(line)
          current_interface = md[2]
        elsif end_re.match(line)
          current_interface = nil
        elsif current_interface and (line[0] == ?+ or line[0] == ?-)
          mtype = line[0]
          body_md = body_re.match(line)
          rettype = body_md[1] ? body_md[1].delete('()') : 'id'
          retval = VarInfo.new(rettype, '', '', enum_types)
          args = []
          selector = ''
          line.scan(args_re).each do |ary|
            argname, argtype = ary
            selector << argname << ':'
            if argtype
              args << VarInfo.new(argtype, argname, '', enum_types)
            end
          end
          selector = body_md[2] if selector.empty? 
          (@ocmethods[current_interface] ||= []) << MethodInfo.new(retval, selector, line[0] == ?+, args, line, enum_types)
        end
      end
    end
    return @ocmethods
  end

  #######
  private
  #######

  def constant?(str)
    str.strip!
    if str == '...'
      VarInfo.new('...', '...', str, enum_types)
    else
      str += "dummy" if str[-1].chr == '*'
      re = /^([^()]*)\b(\w+)\b\s*(\[[^\]]*\])*$/
      m = re.match(str.strip)
      if m
        m = m.to_a[1..-1].compact.map{|i|i.strip}
        m[0] += m[2] if m.size == 3
        m[0] = 'void' if m[1] == 'void'
        VarInfo.new(m[0],m[1],str, enum_types)
      end
    end
  end

  def function?(str)
    str.strip!
    re = /^(.*)\((.*)\)$/
    m = re.match(str.strip)
    if m
      func = constant?(m[1])
      if func
        args = m[2].split(',').map{|i|
          ai = constant?(i)
          ai ? ai : VarInfo.new('unknown', 'unknown', i, enum_types) 
        }
        args = [] if args.size == 1 && args[0].rettype == 'void'
        FuncInfo.new(func, args, str, enum_types)
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
    when 'NSRange' then :_PRIV_C_NSRANGE
    when 'NSWindowDepth' then :_C_INT
    when 'NSComparisonResult' then :_C_INT
    when /^unsigned\s+char$/ then :_C_UCHR
    when 'char' then '_C_CHR'
    when /^unsigned\s+short(\s+int)?$/ then :_C_USHT
    when /^short(\s+int)?$/ then :_C_SHT
    when /^unsigned\s+int$/ then :_C_UINT
    when /^unsigned$/ then :_C_UINT
    when 'int' then :_C_INT
    when /^unsigned\s+long(\s+int)?$/ then :_C_ULNG
    when /^unsigned\s+long\s+long(\s+int)?$/ then :_C_ULLNG
    when /^long\s+long(\s+int)?$/ then :_C_LLNG
    when 'float' then :_C_FLT
    when 'double' then :_C_DBL
    when /char\s*\*$/ then :_C_CHARPTR
    when /\*$/ then :_PRIV_C_PTR
    else :UNKNOWN
    end
  end

  def OCHeaderAnalyzer.do_cpp(path)
    f_on = false
    result = `#{CPP} #{CPPFLAGS} #{path}`.map {|s|
      s.sub( /\/\/.*$/, "" )
    }.select { |s|
      next if /^\s*$/ =~ s
      m = %r{^#\s*\d+\s+".*/(\w+\.h)"}.match(s)
      f_on = (m[1] == File.basename(path)) if m
      f_on
    }.join
    if $?.to_i != 0
      raise "#{CPP} returned #{$?.to_int/256} exit status"
    end
    return result
  end

  class VarInfo
    attr_reader :rettype, :stripped_rettype, :name, :orig
    attr_accessor :octype

    def initialize(type, name, orig, enum_types)
      @rettype = type
      @name = name
      @orig = orig
      @rettype.gsub!( /\[[^\]]*\]/, '*' )
      t = type.gsub(/\b(__)?const\b/,'').strip
      t.gsub!( /<[^>]*>/, '' )
      t.gsub!( /\bconst\b/, '' )
      t.strip!
      t = "int" if enum_types.include?(t)
      @octype = OCHeaderAnalyzer.octype_of(t)
      @stripped_rettype = t
   end

    def to_s
      @orig
    end
  end

  class FuncInfo < VarInfo
    attr_reader :args, :argc

    def initialize(func, args, orig, enum_types)
      super(func.rettype, func.name, orig, enum_types)
      @args = args
      @argc = @args.size
      if @args[-1] && @args[-1].rettype == '...'
        @argc -= 1 
        @variadic = true
        @args.pop
      end
      self
    end

    def to_s
      @orig
    end

    def variadic?
      @variadic
    end

    def predicate?
      octype == :_PRIV_C_BOOL
    end
  end

  class MethodInfo < FuncInfo
    attr_reader :selector

    def initialize(method, selector, is_class, args, orig, enum_types)
      super(method, args, orig, enum_types)
      @selector, @is_class = selector, is_class
      self
    end

    def class_method?
      @is_class
    end
  end

  class InformalProtocolEntry
    attr_reader :orig, :rettype, :selector

    def initialize(orig, rettype, selector)
      @rettype = rettype
      @selector = selector
      @orig = orig
    end

    def to_s
      @orig
    end
  end

  class InformalProtocol
    attr_reader :orig, :base, :name, :entries

    def initialize(orig, base, name, entries)
      @orig = orig
      @base = base
      @name = name
      @entries = entries
    end

    def to_s
      @title
    end
  end
end

class BridgeSupportGenerator
    def initialize(args)
        @headers = []
        @objc = false
        @out_io = STDOUT
        parse_args(args)
        scan_headers
        collect_enums
        generate_xml
    end

    #######
    private
    #######

    # We can't really use RubyCocoa at this point to call the ObjC
    # runtime, because foundation methods like NSClassFromString are
    # not available yet because Foundation's bridge support file has
    # not been generated yet. So let's directly load the objc library
    # and call objc_getClass by ourself. 
    module OBJC
        extend DL::Importable

        dlload "libobjc.dylib"
        extern "void * objc_getClass(char *)"

        def self.is_objc_class?(name)
            objc_getClass(name) != nil
        end
    end

    def octype_of(varinfo)
        # detect ObjC classes
        if @objc 
            ary = varinfo.stripped_rettype.split(/\s/)
            if ary.length == 2 and ary.last == '*' and OBJC.is_objc_class?(ary.first)
                return :_C_ID
            end
        end

=begin
        real_type = resolve_typedef(varinfo.stripped_rettype)

        # resolve typedefs
        hash = @typedefs
        type = varinfo.stripped_rettype
        loop do
            new_type = hash[type]
        end

        # detect boxed types -> TODO
=end
        return varinfo.octype
    end

    ENUMS_BIN = '/tmp/enums'
    ENUMS_SRC = ENUMS_BIN + '.m'
    def collect_enums
        if @import_directive.nil? or @compiler_flags.nil?
            STDERR.puts "Can't generate enums for non-frameworks (yet)"
            return
        end
        lines = @enums.map { |x| "printf(\"%s: %p\\n\", \"#{x}\", #{x});" }
        file = <<EOF
#{@import_directive}

int main (void) 
{
    #{lines.join("\n    ")}
    return 0;
}
EOF

        FileUtils.rm_f([ENUMS_BIN, ENUMS_SRC])

        File.open(ENUMS_SRC, 'w') { |io| io.write(file) }
        unless system("gcc #{ENUMS_SRC} -o #{ENUMS_BIN} #{@compiler_flags}")
            raise "Can't compile the enums file... aborting"
        end
       
        @resolved_enums = {} 
        `#{ENUMS_BIN}`.split("\n").each do |line|
            name, value = line.split(':')
            @resolved_enums[name.strip] = value.strip
        end
    end

    def generate_xml
        document = REXML::Document.new
        document << REXML::XMLDecl.new
        root = document.add_element('signatures')
        @constants.each do |constant| 
            element = root.add_element('constant')
            element.add_attribute('name', constant.name)
            element.add_attribute('type', octype_of(constant))
        end
        @resolved_enums.each do |enum, value| 
            element = root.add_element('enum')
            element.add_attribute('name', enum) 
            element.add_attribute('value', value) 
        end
        @functions.each do |function|
            element = root.add_element('function')
            element.add_attribute('name', function.name)
            element.add_attribute('argc', function.argc)
            element.add_attribute('variadic', true) if function.variadic?
            function.args.each do |arg|
                element.add_element('arg').add_attribute('type', octype_of(arg))
            end
            element.add_element('return').add_attribute('type', octype_of(function))
        end
        @ocmethods.each do |class_name, methods|
            # Describe predicate methods only (the rest is useless).
            predicates = methods.select { |m| m.predicate? }
            next if predicates.empty?
            class_element = root.add_element('class')
            class_element.add_attribute('name', class_name)           
            predicates.each do |method| 
                element = class_element.add_element('method')
                element.add_attribute('selector', method.selector)
                element.add_attribute('class_method', method.class_method?)
                element.add_attribute('predicate', true)
            end
        end
        document.write(@out_io, 0)
    end

    def scan_headers
        @functions, @constants, @enums = [], [], []
        @typedefs, @ocmethods = {}, {}
        @headers.each do |path|
            analyzer = OCHeaderAnalyzer.new(path)
            @functions.concat(analyzer.functions)
            @typedefs.merge!(analyzer.typedefs) do |key, old, new|
                STDERR.puts "typedef '#{key}' already defined -- skipping..."
                old
            end
            @constants.concat(analyzer.constants)
            @enums.concat(analyzer.enums)
            @ocmethods.merge!(analyzer.ocmethods) do |key, old, new|
                old.concat(new)
            end
        end
        @resolved_typedefs = {}
    end
 
    def parse_args(args)
        usage if args.empty?
        case args.first
        when '-f'
            usage if args.length != 2
            handle_framework(args[1])
            @objc = true 
        when '-h'
            usage if args.length < 2
            @headers.concat(args[1..-1])
        else
            usage 
        end
    end
   
    def handle_framework(val)
        path = framework_path(val)                
        die "Can't find framework '#{val}'" if path.nil?
        parent_path, name = path.scan(/^(.+)\/(\w+)\.framework$/)[0]
        headers = File.join(path, 'Headers')
        die "Can't locate framework headers at '#{headers}'" unless File.exists?(headers)
        @headers.concat(Dir.glob(File.join(headers, '**', '*.h')))
        libpath = File.join(path, name)
        die "Can't locate framework library at '#{libpath}'" unless File.exists?(libpath)
        OBJC.dlload(libpath)
        @import_directive = "#import <#{name}/#{name}.h>"
        @compiler_flags = "-F#{parent_path} -framework #{name}"
    end
 
    def framework_path(val)
        return val if File.exists?(val)
        val += '.framework' unless /\.framework$/.match(val)
        ['/System/Library/Frameworks',
         '/Library/Frameworks',
         File.join(ENV['USER']), 'Library', 'Frameworks'].each do |dir|
            path = File.join(dir, val)
            return path if File.exists?(path)
        end
        return nil
    end

    def usage
        die "Usage: #{__FILE__} [-f <framework> | -h <headers...]>"
    end

    def die(msg)
        STDERR.puts msg
        exit 1
    end
end

BridgeSupportGenerator.new(ARGV)
