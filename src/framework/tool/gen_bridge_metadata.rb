#!/usr/bin/env ruby
# Created by Laurent Sansonetti, 2006/08/31
# Copyright (c) 2006-2007 Apple Inc.
# Copyright (c) 2005-2006 FUJIMOTO Hisakuni

require 'rexml/document'
require 'dl/import'
require 'fileutils'
require 'optparse'
require 'tmpdir'

module OBJC
  extend DL::Importable

  dlload "libobjc.dylib"
  extern "void * objc_getClass(char *)"

  def self.is_objc_class?(name)
    objc_getClass(name) != nil
  end
end

class OCHeaderAnalyzer
  attr_reader :path, :cpp_result

  CPP = ['/usr/bin/cpp-4.0', '/usr/bin/cpp-3.3', '/usr/bin/cpp3'].find { |x| File.exist?(x) }
  raise "cpp not found" if CPP.nil?
  CPPFLAGS = "-D__APPLE_CPP__"
  CPPFLAGS << "-D__GNUC__" unless /\Acpp-4/.match(File.basename(CPP))

  def initialize(path, fails_on_error=true)
    @path = path
    @cpp_result = OCHeaderAnalyzer.do_cpp(path, fails_on_error)
    @externname = "extern"
  end

  def enums
    re = /\benum\b\s*(\w+\s+)?\{([^}]*)\}/
    if @enums.nil?
      @enums = {}
      @cpp_result.scan(re).each do |m|
        m[1].split(',').map do |i|
          name, val = i.split('=', 2).map { |x| x.strip }
          @enums[name] = val unless name.empty? or name[0] == ?#
        end
      end
    end
    @enums
  end

  def defines
    re = /#define\s+([^\s]+)\s+(\([^)]+\)|[^\s]+)\s*$/
    @defines ||= File.read(@path).scan(re).select { |m| !m[0].include?('(') and m[1] != '\\' }
  end

  def struct_names
    re = /typedef\s+struct\s*\w*\s*((\w+)|\{([^{}]*(\{[^}]+\})?)*\}\s*([^\s]+))\s*(__attribute__\(.+\))?\s*;/ # Ouch... 
    @struct_names ||= @cpp_result.scan(re).map { |m| 
      a = m.compact
      a.pop if /^__attribute__/.match(a.last)
      a.last
    }.flatten
  end

  def cftype_names
    re = /typedef\s+(const\s+)?struct\s*\w+\s*\*\s*([^\s]+Ref)\s*;/
    @cftype_names ||= @cpp_result.scan(re).map { |m| m.compact[-1] }.flatten
  end

  def function_pointer_types
    unless @func_ptr_types
      @func_ptr_types = {}
      re = /typedef\s+([\w\s]+)\s*\(\s*\*\s*(\w+)\s*\)\s*\(([^)]*)\)\s*;/
      data = @cpp_result.scan(re)
      re = /typedef\s+([\w\s]+)\s*\(([^)]+)\)\s*;/
      data |= @cpp_result.scan(re).map do |m|
        ary = m[0].split(/(\w+)$/)
        ary[1] << ' *'
        ary << m[1]
        ary
      end
      data.each do |m|
        name = m[1]
        args = m[2].split(',').map do |x| 
          if x.include?(' ')
            ptr = x.sub!(/\[\]\s*$/, '')
            x = x.sub(/\w+\s*$/, '').strip
            ptr ? x + '*' : x
          else
            x.strip
          end
        end 
        type = "#{m[0]}(*)(#{args.join(', ')})"
        @func_ptr_types[name] = type
      end
    end
    @func_ptr_types
  end

  def externs
    re = /^\s*#{@externname}\s+\b(.*)\s*;.*$/
    @externs ||= @cpp_result.scan(re).map { |m| m[0].strip }
  end

  def constants
    @constants ||= externs.map { |i| constant?(i, true) }.flatten.compact
  end

  def functions(inline=false)
    if inline
      return @inline_functions if @inline_functions
      inline_func_re = /__inline__\s+((__attribute__\(\([^)]*\)\)\s+)?([\w\s\*<>]+)\s*\(([^)]*)\)\s*)\{/
      res = @cpp_result.scan(inline_func_re)
      res.each { |x| x.delete_at(1) }
    else
      return @functions if @functions
      skip_inline_re = /(static)?\s__inline__[^{;]+(;|\{([^{}]*(\{[^}]+\})?)*\})\s*/
      func_re = /(^([\w\s\*<>]+)\s*\(([^)]*)\)\s*);/
      res = @cpp_result.gsub(skip_inline_re, '').scan(func_re)
    end
    funcs = res.map do |m|
      orig, base, args = m
      base.sub!(/^.*extern\s+/, '')
      func = constant?(base)
      if func
        args = args.strip.split(',').map { |i| constant?(i) }
        next if args.any? { |x| x.nil? }
        args = [] if args.size == 1 and args[0].rettype == 'void'
        FuncInfo.new(func, args, orig, inline)
      end
    end.compact
    if inline
      @inline_functions = funcs
    else
      @functions = funcs
    end
    funcs
  end

  def informal_protocols
    self.ocmethods # to generate @inf_protocols
    @inf_protocols
  end

  def ocmethods
    if @ocmethods.nil?
      @inf_protocols ||= {}
      interface_re = /^@(interface|protocol)\s+(\w+)\s*(\([^)]+\))?/
      end_re = /^@end/
      body_re = /^[-+]\s*(\([^)]+\))?\s*([^:\s;]+)/
      args_re = /\w+\s*:/
      current_interface = current_category = nil
      @ocmethods = {}
      i = 0
      @cpp_result.each_line do |line|
        size = line.size
        line.strip!
        if md = interface_re.match(line)
          current_interface = md[1] == 'protocol' ? 'NSObject' : md[2]
          current_category = md[3].delete('()').strip if md[3]
        elsif end_re.match(line)
          current_interface = current_category = nil
        elsif current_interface and (line[0] == ?+ or line[0] == ?-)
          mtype = line[0]
          data = @cpp_result[i..-1]
          body_md = body_re.match(data)
          next if body_md.nil?
          rettype = body_md[1] ? body_md[1].delete('()') : 'id'
          retval = VarInfo.new(rettype, '', '')
          args = []
          selector = ''
          data = data[0..data.index(';')]
          args_data = []
          data.scan(args_re) { |x| args_data << [$`, x, $'] }
          args_data.each_with_index do |ary, n|
            before, argname, argtype = ary
            arg_nameless = (n > 0 and /\)\s*$/.match(before))
            argname = ':' if arg_nameless
            if n < args_data.length - 1
              argtype.sub!(args_data[n + 1][2], '')
              if arg_nameless
                argtype.sub!(/\w+\s*:\s*$/, '')
              else
                argtype.sub!(/\w+\s+\w+:\s*$/, '')
              end
            else
              argtype.sub!(/\s+__attribute__\(\(.+\)\)/, '')
              argtype.sub!(/\w+\s*;$/, '')
            end
            selector << argname
            args << VarInfo.new(argtype, argname, '') unless argtype.empty?
          end
          selector = body_md[2] if selector.empty?
          method = MethodInfo.new(retval, selector, line[0] == ?+, args, data)
          if current_category and current_interface == 'NSObject'
            (@inf_protocols[current_category] ||= []) << method
          end
          (@ocmethods[current_interface] ||= []) << method
        end
        i += size
      end
    end
    return @ocmethods
  end

  #######
  private
  #######

  def constant?(str, multi=false)
    str.strip!
    return nil if str.empty?
    if str == '...'
      VarInfo.new('...', '...', str)
    else
      str << " dummy" if str[-1].chr == '*' or str.index(/\s/).nil?
      tokens = multi ? str.split(',') : [str]
      part = tokens.first
      re = /^([^()]*)\b(\w+)\b\s*(\[[^\]]*\])*$/
      m = re.match(part)
      if m
        return nil if m[1].split(/\s+/).any? { |x| ['end', 'typedef'].include?(x) }
        m = m.to_a[1..-1].compact.map { |i| i.strip }
        m[0] += m[2] if m.size == 3
        m[0] = 'void' if m[1] == 'void'
        var = VarInfo.new(m[0], m[1], part)
        if tokens.size > 1
          [var, *tokens[1..-1].map { |x| constant?(m[0] + x.strip.sub(/^\*+/, '')) }]
        else
          var
        end
      end
    end
  end

  def self.do_cpp(path, fails_on_error=true)
    f_on = false
    err_file = '/tmp/.cpp.err'
    result = `#{CPP} #{CPPFLAGS} \"#{path}\" 2>#{err_file}`.select { |s|
      # First pass to only grab non-empty lines and the pre-processed lines
      # only from the target header (and not the entire pre-processing result).
      next if s.strip.empty? 
      m = %r{^#\s*\d+\s+".*/(\w+\.h)"}.match(s)
      f_on = (m[1] == File.basename(path)) if m
      f_on
    }.select { |s|
      # Second pass to ignore all pro-processor comments that were left.
      /^#/.match(s) == nil
    }.join
    if $?.to_i != 0 and fails_on_error 
      STDERR.puts File.read(err_file)
      raise "#{CPP} returned #{$?.to_int/256} exit status"
    end
    return result
  end

  class VarInfo
    attr_reader :rettype, :stripped_rettype, :name, :orig
    attr_accessor :octype

    def initialize(type, name, orig)
      @rettype = type
      @name = name
      @orig = orig
      @rettype.gsub!( /\[[^\]]*\]/, '*' )
      t = type.gsub(/\b(__)?const\b/,'')
      t.gsub!(/<[^>]*>/, '')
      t.gsub!(/\b(in|out|inout|oneway|const)\b/, '')
      t.gsub!(/\b__private_extern__\b/, '')
      t.gsub!(/^\s*\(?\s*/, '')
      t.gsub!(/\s*\)?\s*$/, '')
      raise "empty type (was '#{type}')" if t.empty?
      @stripped_rettype = t
    end

    def pointer?
      @pointer ||= __pointer__?
    end

    def function_pointer?(func_ptr_types)
      type = (func_ptr_types[@stripped_rettype] or @stripped_rettype)
      @function_pointer ||= FuncPointerInfo.new_from_type(type)
    end

    def <=>(x)
      self.name <=> x.name
    end

    def hash
      @name.hash
    end

    def eql?(o)
      @name == o.name
    end

    private

    def __pointer__?
      @objc_lookup_cache ||= {}
      @skip_objc_lookup_types ||= ['Protocol']
      cached = @objc_lookup_cache[rettype]
      return cached unless cached.nil?
      rettype = @stripped_rettype.delete(' ')
      retval = if md = /^(.+)Array$/.match(rettype)
        # XXX this should be improved
        !OBJC.is_objc_class?(md[1])
      elsif md = /^([^*]+)(\*+)$/.match(rettype)
        type, refkind = md[1], md[2]
        return false if (type.nil? or refkind.nil?)
        refkind == ((@skip_objc_lookup_types.include?(type) or !OBJC.is_objc_class?(type)) ? '*' : '**')
      else
        false
      end
      @objc_lookup_cache[rettype] = retval
      return retval
    end
  end

  class FuncInfo < VarInfo
    attr_reader :args, :argc

    def initialize(func, args, orig, inline=false)
      super(func.rettype, func.name, orig)
      @args = args
      @argc = @args.size
      if @args[-1] && @args[-1].rettype == '...'
        @argc -= 1 
        @variadic = true
        @args.pop
      end
      @inline = inline
      self
    end

    def variadic?
      @variadic
    end

    def inline?
      @inline
    end
  end

  class FuncPointerInfo < FuncInfo
    def self.new_from_type(type)
      @cache ||= {}
      info = @cache[type]
      return info if info

      tokens = type.split(/\(\*\)/)
      return nil if tokens.size != 2

      rettype = tokens.first.strip
      rest = tokens.last.sub(/^\s*\(\s*/, '').sub(/\s*\)\s*$/, '')
      argtypes = rest.split(/,/).map { |x| x.strip }

      @cache[type] = self.new(rettype, argtypes, type) 
    end

    def initialize(rettype, argtypes, orig)
      args = argtypes.map { |x| VarInfo.new(x, '', '') }
      super(VarInfo.new(rettype, '', ''), args, orig)
    end
  end

  class MethodInfo < FuncInfo
    attr_reader :selector

    def initialize(method, selector, is_class, args, orig)
      super(method, args, orig)
      @selector, @is_class = selector, is_class
      self
    end

    def class_method?
      @is_class
    end

    def <=>(o)
      @selector <=> o.selector
    end

    def <=>(o)
      @selector <=> o.selector
    end
  end
end

class BridgeSupportGenerator
  VERSION = '0.9'
  TIGER_OR_BELOW = `sw_vers -productVersion`.strip.to_f <= 10.4

  def initialize(args)
    parse_args(args)
    scan_headers
    if @generate_format == FORMAT_FINAL
      collect_types_encoding
      collect_enums
      collect_numeric_defines
      collect_cftypes_info
      collect_structs_encoding
      collect_inf_protocols_encoding
    end
    if @generate_format == FORMAT_DYLIB
      collect_types_encoding
      generate_dylib
    else
      generate_xml
    end
  end

  #######
  private
  #######

  def collect_enums
    @resolved_enums ||= {} 
    lines = @enums.map do |name, val|
      "printf(((int)#{name}) < 0 ? \"%s: %d\\n\" : \"%s: %u\\n\", \"#{name}\", #{name});" 
    end
    code = <<EOS
#{@import_directive}

int main (void) 
{
    char *fmt;
    #{lines.join("\n  ")}
    return 0;
}
EOS
    compile_and_execute_code(code).split("\n").each do |line|
      name, value = line.split(':')
      @resolved_enums[name.strip] = value.strip
    end
  end

  def collect_numeric_defines
    @resolved_enums ||= {} 
    code = <<EOS
#{@import_directive}
#import <objc/objc-class.h>

/* Tiger compat */
#ifndef _C_ULNG_LNG
#define _C_ULNG_LNG 'Q'
#endif

#ifndef _C_LNG_LNG
#define _C_LNG_LNG 'q'
#endif

static const char * 
printf_format (const char *str)
{
  if (str == NULL || strlen(str) != 1)
    return NULL;
  switch (*str) {
    case _C_SHT: return "%s: %hd\\n";
    case _C_USHT: return "%s: %hu\\n";
    case _C_INT: return "%s: %d\\n";
    case _C_UINT: return "%s: %u\\n";
    case _C_LNG: return "%s: %ld\\n";
    case _C_ULNG: return "%s: %lu\\n";
    case _C_LNG_LNG: return "%s: %lld\\n";
    case _C_ULNG_LNG: return "%s: %llu\\n";
    case _C_FLT: return "%s: %.17g\\n";
    case _C_DBL: return "%s: %.17g\\n";
  }
  return NULL;
}

int main (void) 
{
    char *fmt;
    PRINTF_LINE_HERE 
    return 0;
}
EOS
    pure_numeric_lines = []
    numeric_re = /\)?\s*(0x[\da-fA-F]+|[\d\.]+)\s*\)*\s*$/
    @defines.each do |name, value|
      name.strip!
      value.strip!
      next if name.strip[0] == ?_
      next if @ignored_defines_regexps.any? { |re| re.match(name) }
      next if value[0] == ?"
      line = "if ((fmt = printf_format(@encode(__typeof__(#{value})))) != NULL) printf(fmt, \"#{name}\", #{value});"
      if numeric_re.match(value)
        pure_numeric_lines << line
      else
        begin
          name, value = compile_and_execute_code(code.sub(/PRINTF_LINE_HERE/, line), true).split(':')
          @resolved_enums[name.strip] = value.strip
        rescue
        end
      end
    end
    unless pure_numeric_lines.empty?
      compile_and_execute_code(code.sub(/PRINTF_LINE_HERE/, pure_numeric_lines.join("\n"))).each do |line|
        name, value = line.split(':')
        @resolved_enums[name.strip] = value.strip
      end
    end
  end

  def encoding_of(varinfo, try_64_bit=false)
    if /^(BOOL|Boolean)$/.match(varinfo.stripped_rettype)
      'B'
    elsif /^(BOOL|Boolean)\s*\*$/.match(varinfo.stripped_rettype)
      '^B'
    else
      h = try_64_bit ? @types_64_encoding : @types_encoding
      h[varinfo.stripped_rettype]
    end
  end

  def bool_type?(varinfo)
    type = encoding_of(varinfo)
    type and type[-1] == ?B
  end

  def add_type_attributes(element, varinfo)
    type = encoding_of(varinfo)
    element.add_attribute('type', type)
    type64 = encoding_of(varinfo, true)
    if type != type64
      element.add_attribute('type64', type64)
    end
    if func_ptr_info = varinfo.function_pointer?(@func_ptr_types)
      element.add_attribute('function_pointer', 'true')
      func_ptr_info.args.each do |a| 
        func_ptr_elem = element.add_element('arg')
        add_type_attributes(func_ptr_elem, a)
      end
      func_ptr_retval = element.add_element('retval')
      add_type_attributes(func_ptr_retval, func_ptr_info)
    end 
  end

  def collect_cftypes_info
    @resolved_cftypes ||= {}
    lines = []
    @cftypes.each do |name, ary|
      gettypeid_func, ignore_tollfree = ary
      lines << if gettypeid_func and !ignore_tollfree
        "ref = _CFRuntimeCreateInstance(NULL, #{gettypeid_func}(), 0, NULL); printf(\"%s: %s: %s\\n\", \"#{name}\", @encode(#{name}), ref != NULL ? object_getClassName((id)ref) : \"\");"
      else
        "printf(\"%s: %s: %s\\n\", \"#{name}\", @encode(#{name}), \"\");"
      end
    end
    code = <<EOS
#{@import_directive}
#import <objc/objc-class.h>

CFTypeRef _CFRuntimeCreateInstance(CFAllocatorRef allocator, CFTypeID typeID, CFIndex extraBytes, unsigned char *category);

int main (void) 
{
    CFTypeRef ref;
    #{lines.join("\n  ")}
    return 0;
}
EOS
    compile_and_execute_code(code).split("\n").each do |line|
      name, encoding, tollfree = line.split(':')
      tollfree.strip!
      tollfree = nil if tollfree.empty? or tollfree == 'NSCFType'
      @resolved_cftypes[name.strip] = [encoding.strip, tollfree, @cftypes[name.strip].first]
    end
  end

  def collect_types_encoding
    @types_encoding ||= {}
    @types_64_encoding ||= {}
    all_types = @functions.map { |x| 
      [x.stripped_rettype, *x.args.map { |y| y.stripped_rettype }] 
    }.flatten 
    all_types |= @constants.map { |x| x.stripped_rettype }
    all_types |= @ocmethods.map { |c, m| 
      m.map { |x| x.stripped_rettype } 
    }.flatten
    all_types |= @method_exception_types
    all_types |= @opaques.keys
    all_types |= @func_ptr_types.values.map { |x| 
      info = OCHeaderAnalyzer::FuncPointerInfo.new_from_type(x)
      [info.stripped_rettype, *info.args.map { |y| y.stripped_rettype }] 
    }.flatten

    lines = all_types.map do |type|
      "printf(\"%s: %s\\n\", \"#{type}\", @encode(#{type}));"
    end
    code = <<EOS
#{@import_directive}

int main (void) 
{
    #{lines.join("\n  ")}
    return 0;
}
EOS
    compile_and_execute_code(code).split("\n").each do |line|
      name, value = line.split(':')
      @types_encoding[name.strip] = value.strip
    end

    if @enable_64
      compile_and_execute_code(code, false, true).split("\n").each do |line|
        name, value = line.split(':')
        name.strip!
        value.strip!
        unless value == @types_encoding[name]
          @types_64_encoding[name] = value
        end
      end
    end

    @opaques.each do |name, type|
      next unless type
      old_type = @types_encoding[name]
      @types_encoding.each do |n, t|
        next unless t == old_type
        @types_encoding[n] = type
      end
    end

    @types_encoding['CFTypeRef'] = '@'
  end

  def collect_structs_encoding
    @resolved_structs ||= {}
    @resolved_structs_64 ||= {}
    ivar_st = []
    log_st = []
    @structs.each do |name, is_opaque|
      ivar_st << "#{name} a#{name};"
      log_st << "printf(\"%s: %s\\n\", \"#{name}\", ivar_getTypeEncoding(class_getInstanceVariable(klass, \"a#{name}\")));"
    end
    code = <<EOS
#{@import_directive}
#import <objc/objc-class.h>

#{TIGER_OR_BELOW ? '#define ivar_getTypeEncoding(x) (x->ivar_type)' : ''}

@interface __MyClass : NSObject
{
#{ivar_st.join("\n")}
}
@end

@implementation __MyClass
@end

int main (void) 
{
  Class klass = objc_getClass("__MyClass");
  #{log_st.join("\n")}
  return 0;
}
EOS
    compile_and_execute_code(code).split("\n").each do |line|
      name, value = line.split(':')
      @resolved_structs[name.strip] = value.strip
    end
    
    if @enable_64 
      compile_and_execute_code(code, false, true).split("\n").each do |line|
        name, value = line.split(':')
        name.strip!
        value.strip!
        unless value == @resolved_structs[name]
          @resolved_structs_64[name] = value
        end
      end
    end
  end

  def collect_inf_protocols_encoding
    objc_impl_st = []
    log_st = []
    @resolved_inf_protocols_encoding ||= {}
    @inf_protocols.each do |name, methods|
      methods.each do |method|
        objc_impl_st << "#{method.orig}" + ' {}'
        log_st << if TIGER_OR_BELOW
          <<EOS
printf("%s -> %s\\n", "#{method.selector}", #{method.class_method? ? "class_getClassMethod" : "class_getInstanceMethod"}(klass, @selector(#{method.selector}))->method_types); 
EOS
        else
          <<EOS
printf("%s -> %s\\n", "#{method.selector}", method_getDescription(#{method.class_method? ? "class_getClassMethod" : "class_getInstanceMethod"}(klass, @selector(#{method.selector})))->types); 
EOS
        end
      end
    end
    code = <<EOS
#{@import_directive}
#import <objc/objc-class.h>

@interface __MyClass : NSObject
@end

@implementation __MyClass
#{objc_impl_st.join("\n")}
@end

int main (void) 
{
  Class klass = objc_getClass("__MyClass");
  #{log_st.join("\n  ")}
  return 0;
}
EOS
    compile_and_execute_code(code).split("\n").each do |line|
      name, value = line.split('->')
      @resolved_inf_protocols_encoding[name.strip] = value.strip
    end
  end

  def generate_dylib
    inline_functions = @functions.select { |x| x.inline? }
    if inline_functions.empty?
      puts "No inline functions in the given framework/library, no need to generate a dylib."
      return
    end    
    code = "#{@import_directive}\n"
    inline_functions.each do |function|
      orig = function.orig.sub(/__attribute__\(\(always_inline\)\)/, '').strip
      new = orig.sub(function.name, '__dummy_' + function.name)
      ret = encoding_of(function) == 'v' ? '' : 'return '
      code << <<EOC
#{new} __asm__ ("_#{function.name}");
#{new} { 
  #{ret}#{function.name}(#{function.args.map { |x| x.name }.join(', ')});
} 
EOC
    end
    tmp_src = File.open(unique_tmp_path('src', '.m'), 'w')
    tmp_src.puts code
    tmp_src.close
    if File.extname(@out_file) != '.dylib'
      @out_file << '.dylib'
    end
    gcc = "gcc #{ENV['CFLAGS']} #{tmp_src.path} -o #{@out_file} #{@compiler_flags} -dynamiclib -O3 -current_version #{VERSION} -compatibility_version #{VERSION}"
    unless system(gcc)
      die "Can't compile dylib source file '#{tmp_src.path}'"
    end
    File.unlink(tmp_src.path)
  end

  def generate_xml
    document = REXML::Document.new
    document << REXML::XMLDecl.new
    document << REXML::DocType.new(['signatures', 'SYSTEM', '"file://localhost/System/Library/DTDs/BridgeSupport.dtd"'])
    root = document.add_element('signatures')
    root.add_attribute('version', VERSION)

    case @generate_format
    when FORMAT_TEMPLATE
      # Generate the exception template file.
      @cftype_names.sort.each do |name|
        element = root.add_element('cftype')
        element.add_attribute('name', name) 
        gettypeid_func = name.sub(/Ref$/, '') + 'GetTypeID'
        ok = @functions.find { |x| x.name == gettypeid_func }
        if !ok and gettypeid_func.sub!(/Mutable/, '')
          ok = @functions.find { |x| x.name == gettypeid_func }
        end
        element.add_attribute('gettypeid_func', ok ? gettypeid_func : '?')
      end
      @struct_names.each do |struct_name|
        root.add_element('struct').add_attribute('name', struct_name)
      end
      @functions.each do |function|
        pointer_arg_indexes = []
        function.args.each_with_index do |arg, i| 
          pointer_arg_indexes << i if arg.pointer?
        end
        next if pointer_arg_indexes.empty?

        element = root.add_element('function')
        element.add_attribute('name', function.name)
        pointer_arg_indexes.each do |i|
          arg_element = element.add_element('arg')
          arg_element.add_attribute('index', i)
          arg_element.add_attribute('type_modifier', 'o')
        end
      end
      @ocmethods.each do |class_name, methods|
        method_elements = []
        methods.each do |method|
          pointer_arg_indexes = []
          method.args.each_with_index do |arg, i|
            pointer_arg_indexes << i if arg.pointer?
          end
          next if pointer_arg_indexes.empty?
          
          element = REXML::Element.new('method')
          element.add_attribute('selector', method.selector)
          element.add_attribute('class_method', true) if method.class_method?
          pointer_arg_indexes.each do |i|
            arg_element = element.add_element('arg')
            arg_element.add_attribute('index', i)
            arg_element.add_attribute('type_modifier', 'o')
          end
          method_elements << element
        end
        next if method_elements.empty?
        element = root.add_element('class')
        element.add_attribute('name', class_name)
        method_elements.each { |x| element.add_element(x) }
      end
    when FORMAT_FINAL
      # Generate the final metadata file.
      @resolved_structs.sort { |x, y| x[0] <=> y[0] }.each do |name, encoding|
        element = root.add_element('struct')
        element.add_attribute('name', name)
        element.add_attribute('type', encoding)
        encoding64 = @resolved_structs_64[name]
        if encoding64 != encoding
          element.add_attribute('type64', encoding64)
        end
        element.add_attribute('opaque', true) if @structs[name]
      end
      @resolved_cftypes.sort { |x, y| x[0] <=> y[0] }.each do |name, ary|
        encoding, tollfree, gettypeid_func = ary
        element = root.add_element('cftype')
        element.add_attribute('name', name) 
        element.add_attribute('type', encoding)
        element.add_attribute('gettypeid_func', gettypeid_func) if gettypeid_func 
        element.add_attribute('tollfree', tollfree) if tollfree 
      end
      @opaques.keys.sort.each do |name|
        next if @opaques_to_ignore.include?(name)
        encoding = @types_encoding[name]
        raise "encoding of opaque type '#{name}' not resolved" if encoding.nil?
        element = root.add_element('opaque')
        element.add_attribute('name', name.sub(/\s*\*+$/, '')) 
        element.add_attribute('type', encoding) 
      end
      @constants.sort.each do |constant| 
        element = root.add_element('constant')
        element.add_attribute('name', constant.name)
        add_type_attributes(element, constant)
      end
      @defines.sort { |x, y| x[0] <=> y[0] }.each do |name, value|
        value.strip!
        c_str = objc_str = false
        if value[0] == ?" and value[-1] == ?"
          value = value[1..-2]
          c_str =  true
        elsif value[0] == ?@ and value[1] == ?" and value[-1] == ?"
          value = value[2..-2]
          objc_str = true
        elsif md = /^CFSTR\s*\(\s*([^)]+)\s*\)\s*$/.match(value)
          if md[1][0] == ?" and md[1][-1] == ?"
            value = md[1][1..-2]
            objc_str = true
          end
        end
        next if !c_str and !objc_str
        element = root.add_element('string_constant')
        element.add_attribute('name', name.strip)
        element.add_attribute('value', value)
        element.add_attribute('nsstring', objc_str) if objc_str
      end
      @resolved_enums.sort { |x, y| x[0] <=> y[0] }.each do |enum, value| 
        element = root.add_element('enum')
        element.add_attribute('name', enum)
        element.add_attribute('value', value)
      end
      @functions.uniq.sort.each do |function|
        element = root.add_element('function')
        element.add_attribute('name', function.name)
        element.add_attribute('variadic', true) if function.variadic?
        element.add_attribute('inline', true) if function.inline?
        function.args.each do |arg|
          arg_elem = element.add_element('arg')
          add_type_attributes(arg_elem, arg)
        end
        rettype = encoding_of(function)
        if rettype != 'v'
          retval_element = element.add_element('retval')
          add_type_attributes(retval_element, function)
          retval_element.add_attribute('already_retained', true) \
            if @resolved_cftypes.has_key?(function.stripped_rettype) \
            and /(Create|Copy)/.match(function.name)
        end
      end
      @func_aliases.to_a.sort { |x, y| x[1] <=> y[1] }.each do |original, name|
        element = root.add_element('function_alias')
        element.add_attribute('name', name)
        element.add_attribute('original', original)
      end
      @ocmethods.sort { |x, y| x[0] <=> y[0] }.each do |class_name, methods|
        elements = methods.sort.map { |method| 
          predicate = bool_type?(method)
          bool_args = []
          func_pointer_args = []
          method.args.each_with_index do |a, i|
            if bool_type?(a)
              bool_args << i 
            elsif a.function_pointer?(@func_ptr_types)
              func_pointer_args << i
            end
          end 
          next if !predicate and bool_args.empty? and func_pointer_args.empty?
          element = REXML::Element.new('method')
          element.add_attribute('selector', method.selector)
          element.add_attribute('class_method', true) if method.class_method?
          (bool_args | func_pointer_args).each do |i|
            arg_elem = element.add_element('arg')
            arg_elem.add_attribute('index', i)
            arg_elem.add_attribute('type', encoding_of(method.args[i])) if bool_args.include?(i)
            if func_pointer_args.include?(i) 
              add_type_attributes(arg_elem, method.args[i])
            end
          end
          element.add_element('retval').add_attribute('type', encoding_of(method)) if predicate
          element
        }.compact
        next if elements.empty?
        class_element = root.add_element('class')
        class_element.add_attribute('name', class_name)           
        elements.each { |x| class_element.add_element(x) }
      end
      @inf_protocols.sort { |x, y| x[0] <=> y[0] }.each do |name, methods|
        prot_element = root.add_element('informal_protocol')
        prot_element.add_attribute('name', name)
        methods.sort.each do |method|
          element = prot_element.add_element('method')
          method_type = @resolved_inf_protocols_encoding[method.selector]
          offset = 0
          [method, *method.args].each do |arg|
            type = encoding_of(arg)
            if type == 'B' or type == 'c'
              offset = method_type.index('c', offset)
              method_type[offset] = type if type == 'B'
              offset += 1
            end 
          end
          element.add_attribute('selector', method.selector)
          element.add_attribute('class_method', true) if method.class_method?
          element.add_attribute('type', method_type)
        end
      end

      # Merge with exceptions.
      @exceptions.each { |x| merge_document_with_exceptions(document, x) }
    end

    if @out_file
      File.open(@out_file, 'w') { |io| document.write(io, 0) }
    else
      document.write(STDOUT, 0)
    end
  end

  def merge_document_with_exceptions(document, exception_document)
    # Merge constants.
    exception_document.elements.each('/signatures/constant') do |const_element|
      const_name = const_element.attributes['name']
      orig_const_element = document.elements["/signatures/constant[@name='#{const_name}']"]
      raise "Constant '#{const_name}' is described in an exception file but it has not been discovered by the final generator" if orig_const_element.nil?
      magic_cookie = const_element.attributes['magic_cookie']
      # Append the magic_cookie attribute.
      if magic_cookie == 'true'
        orig_const_element.add_attribute('magic_cookie', true)
      end
    end
    # Merge enums.
    exception_document.elements.each('/signatures/enum') do |enum_element|
      enum_name = enum_element.attributes['name']
      orig_enum_element = document.elements["/signatures/enum[@name='#{enum_name}']"]
      if orig_enum_element.nil?
        if @defines.any? { |n, v| n == enum_name }
          document.root.add_element(enum_element) 
        else
          raise "Enum '#{enum_name}' is described in an exception file but it has not been discovered by the final generator" 
        end
      else
        ignore = enum_element.attributes['ignore']
        # Append the ignore/suggestion attributes.
        if ignore == 'true'
          orig_enum_element.add_attribute('ignore', true)
          suggestion = enum_element.attributes['suggestion']
          orig_enum_element.add_attribute('suggestion', suggestion) if suggestion
          orig_enum_element.delete_attribute('value')
        end
      end
    end
    # Merge functions.
    exception_document.elements.each('/signatures/function') do |func_element|
     func_name = func_element.attributes['name']
      # Do the merging.
      orig_func_element = document.elements["/signatures/function[@name='#{func_name}']"]
      raise "Function '#{func_name}' is described in an exception file but it has not been discovered by the final generator" if orig_func_element.nil?
      orig_func_args = orig_func_element.get_elements('arg')
      func_element.elements.each('arg') do |arg_element|
        idx = arg_element.attributes['index'].to_i
        orig_arg_element = orig_func_args[idx]
        raise "Function '#{func_name}' is described with more arguments than it should" if orig_arg_element.nil?
        # Append attributes (except 'index').
        arg_element.attributes.each do |name, value|
          next if name == 'index'
          if name == 'type'
            orig_type = value
            value = @types_encoding[value]
            raise "encoding of function argument '#{func_name}' type '#{orig_type}' not resolved" if value.nil?
          end
          orig_arg_element.add_attribute(name, value)
        end
      end
      retval_element = func_element.elements['retval']
      if retval_element
        type_name = retval_element.attributes['type']
        if type_name
          type = @types_encoding[type_name]
          raise "encoding of function return type '#{func_name}' not resolved" if type.nil?
          orig_retval_element = orig_func_element.elements['retval']
          raise "Function '#{func_name}' is described with a return value in an exception file but the return value has not been discovered by the final generator" if orig_retval_element.nil?
          orig_retval_element.add_attribute('type', type)
        end
      end
    end
    # Merge class/methods.
    exception_document.elements.each('/signatures/class') do |class_element|
      class_name = class_element.attributes['name']
      if @ocmethods[class_name].nil?
        raise "Class '#{class_name}' is described in an exception file but it has not been discovered by the final generator"
      end
      # First replace the type attributes by the real encoding.
      class_element.elements.each('method') do |element|
        retval_element = element.elements['retval']
        if retval_element
          type_name = retval_element.attributes['type']
          if type_name
            type = @types_encoding[type_name]
            raise "encoding of method return type '#{class_element.attributes['selector']}' not resolved" if type.nil?
            retval_element.add_attribute('type', type)
          end
        end
        element.elements.each('arg') do |arg_element|
          type_name = arg_element.attributes['type']
          if type_name
            type = @types_encoding[type_name]
            raise "encoding of method arg type '#{class_element.attributes['selector']}' not resolved" if type.nil?
            arg_element.add_attribute('type', type)
          end
        end
      end
      # Do the merging.
      orig_class_element = document.elements["/signatures/class[@name='#{class_name}']"]
      if orig_class_element.nil?
        # Class is not defined in the original document, we can append it with its methods.
        document.root.add_element(class_element)
      else
        # Merge methods.
        class_element.elements.each('method') do |element|
          selector = element.attributes['selector']
          orig_element = orig_class_element.elements["method[@selector='#{selector}']"]
          if orig_element.nil?
            # Method is not defined in the original document, we can append it.
            orig_class_element.add_element(element)
          else
            # Smart merge of attributes.  
            element.attributes.each do |name, value|
              orig_value = orig_element.attributes[name]
              if orig_value != value                        
                STDERR.puts "Warning: attribute '#{name}' of method '#{selector}' of class '#{class_name}' has a different value in the exception file -- using the latter value" unless orig_value.nil?
                orig_element.add_attribute(name, value)
              end
            end
            # We can just append/update the retval/args
            orig_retval = orig_element.elements['retval']
            orig_element.delete_element(orig_retval) if orig_retval
            element.elements.each('arg') do |child| 
              index = child.attributes['index']
              orig_arg = orig_element.elements["arg[@index='#{index}']"]
              if orig_arg.nil?
                orig_element.add_element(child) 
              else
                child.attributes.each do |name, value|
                  orig_arg.add_attribute(name, value)
                end
              end
            end
            orig_element.add_element(orig_retval) if orig_retval
            retval = element.elements['retval']
            if retval
              retval.attributes.each do |name, value|
                orig_retval.add_attribute(name, value)
              end
            end
          end
        end
      end
    end
  end

  def scan_headers
    @functions = [] 
    @constants = [] 
    @enums = {}
    @defines = []
    @struct_names = []
    @cftype_names = []
    @inf_protocols = {} 
    @ocmethods = {}
    @func_ptr_types = {}
    @headers.each do |path|
      die "Given header file `#{path}' doesn't exist" unless File.exist?(path)
      analyzer = OCHeaderAnalyzer.new(path, !@private)
      case @generate_format
      when FORMAT_DYLIB
        @functions.concat(analyzer.functions(true))
      when FORMAT_TEMPLATE
        @functions.concat(analyzer.functions)
        @functions.concat(analyzer.functions(true))
        @struct_names.concat(analyzer.struct_names)
        @cftype_names.concat(analyzer.cftype_names)
      when FORMAT_FINAL 
        @functions.concat(analyzer.functions)
        @functions.concat(analyzer.functions(true))
        @constants.concat(analyzer.constants)
        @enums.merge!(analyzer.enums)
        @defines.concat(analyzer.defines)
        @inf_protocols.merge!(analyzer.informal_protocols)
        @func_ptr_types.merge!(analyzer.function_pointer_types)
      end
      @ocmethods.merge!(analyzer.ocmethods) { |key, old, new| old.concat(new) }
    end
    to_not_delete = @func_aliases.keys
    [@functions, @constants, @defines, @enums].each do |c|
      c.delete_if do |*a|
        n = a[0]
        n = n.name if n.is_a?(OCHeaderAnalyzer::VarInfo)
        !to_not_delete.include?(n) and n[0] == ?_ 
      end
    end
    [@constants, @struct_names, @cftype_names].each { |c| c.uniq! }
    all_inf_protocol_signatures = @inf_protocols.values.map { |ary| ary.map { |m| m.selector } }.flatten
    @inf_protocols.each do |name, methods|
      methods.delete_if do |method|
        s = method.selector
        all_inf_protocol_signatures.select { |s2| s2 == s }.length > 1
      end
    end
  end

  FORMATS = ['final', 'exceptions-template', 'dylib']
  FORMAT_FINAL, FORMAT_TEMPLATE, FORMAT_DYLIB = FORMATS
 
  def parse_args(args)
    @headers = []
    @exceptions = []
    @objc = false
    @out_file = nil
    @generate_format = FORMAT_FINAL
    @private = false 
    @enable_64 = false

    frameworks_to_handle = []

    OptionParser.new do |opts|
      opts.banner = "Usage: #{File.basename(__FILE__)} [options] <headers...>\nSee -h or gen_bridge_metadata(1) for more help."
      opts.separator ''
      opts.separator 'Options:'

      opts.on('-p', '--private', 'Only grep private headers (framework only)') { @private = true } 

      opts.on('-f', '--framework FRAMEWORK', 'Grep headers within the given framework') do |opt|
        frameworks_to_handle << opt
        @objc = true
      end

      opts.on('-o', '--output OUTFILE', 'Redirect output to the given file (stdout by default)') do |opt|
        die 'Output file can\'t be specified more than once' if @out_file
        @out_file = opt
      end

      opts.on('-e', '--exception EXCPFILE', 'Consider the given exception file when generating the metadata') do |opt|
        @exceptions << opt
      end

      opts.on('-F', '--format FORMAT', FORMATS, {}, "Select metadata format ('#{FORMATS.first}' (default), '#{FORMATS[1..-1].map { |x| '\'' + x + '\'' }.join(', ')})") do |opt|
        @generate_format = opt
      end

      opts.on('-c', '--compiler-flags FLAGS', 'Specify custom compiler flags (by default, "-F... -framework ...")') do |flags|
        @compiler_flags ||= ''
        @compiler_flags << ' ' + flags + ' '
      end

      opts.on(nil, '--enable-64', 'Enable 64-bit annotations in the generated metadata (10.5 only)') do
        die '--enable-64 requires Mac OS X 10.5 or later' if TIGER_OR_BELOW
        @enable_64 = true
      end

      opts.on('-h', '--help', 'Show this message') do
        puts opts
        exit
      end

      opts.on('-v', '--version', 'Show version') do
        puts VERSION
        exit
      end

      opts.separator ''
      opts.separator 'Examples:'
      opts.separator "    #{__FILE__} -f Foundation -o Foundation.bridgesupport"
      opts.separator "    #{__FILE__} /path/to/my/library/headers/* > MyLibrary.bridgesupport"

      if args.empty?
        die opts.banner
      else
        begin
          opts.parse!(args)
        rescue => e
          die e.message, opts.banner
        end
        frameworks_to_handle.each { |f| handle_framework(f) }
        @headers.concat(args)
        if @headers.empty?
          die "No headers given", opts.banner
        end
        if @generate_format == FORMAT_DYLIB and @out_file.nil? 
          die "dylib format requires --output"
        end
      end
    end

    # Link against Foundation by default.
    if @compiler_flags and @import_directive 
      @import_directive.insert(0, "#import <Foundation/Foundation.h>\n")
      @compiler_flags << ' -framework Foundation '
    end
    # Open exceptions, ignore mentionned headers.
    # Keep the list of structs, CFTypes, boxed and methods return/args types.
    @ignored_defines_regexps = []
    @structs = {} 
    @cftypes = {} 
    @opaques = {} 
    @opaques_to_ignore = []
    @method_exception_types = []
    @func_aliases = {}
    @exceptions.map! { |x| REXML::Document.new(File.read(x)) }
    @exceptions.each do |doc|
      doc.get_elements('/signatures/ignored_headers/header').each do |element|
        path = element.text
        path_re = /#{path}/
        ignored = @headers.select { |x| path_re.match(x) }
        @headers -= ignored
        if @import_directive
          ignored.each { |x| @import_directive.gsub!(/#import.+#{File.basename(x)}>/, '') } 
        end
      end
      doc.get_elements('/signatures/ignored_defines/regex').each do |element|
        @ignored_defines_regexps << Regexp.new(element.text.strip)
      end
      doc.get_elements('/signatures/struct').each do |elem|
        @structs[elem.attributes['name']] = elem.attributes['opaque'] == 'true'
      end
      doc.get_elements('/signatures/cftype').each do |elem|
        @cftypes[elem.attributes['name']] = [
          elem.attributes['gettypeid_func'], 
          elem.attributes['ignore_tollfree'] == 'true'
        ]
      end
      doc.get_elements('/signatures/opaque').each do |elem|
        name, type, ignore = elem.attributes['name'], elem.attributes['type'], elem.attributes['ignore']
        @opaques[name] = type 
        @opaques_to_ignore << name if ignore == 'true'
      end
      ['/signatures/class/method', '/signatures/function'].each do |path|
        doc.get_elements(path).each do |elem|
          retval_elem = elem.elements['retval']
          if retval_elem
            type = retval_elem.attributes['type']
            @method_exception_types << type if type
          end
          elem.elements.each('arg') do |arg_elem|
            type = arg_elem.attributes['type']
            @method_exception_types << type if type
          end
        end
      end
      doc.get_elements('/signatures/function_alias').each do |elem|
        name, original = elem.attributes['name'], elem.attributes['original']
        @func_aliases[original.strip] = name.strip
      end
    end
  end
  
  def handle_framework(val)
    path = framework_path(val)
    die "Can't locate framework '#{val}'" if path.nil?
    (@framework_paths ||= []) << File.dirname(path)
    die "Can't find framework '#{val}'" if path.nil?
    parent_path, name = path.scan(/^(.+)\/(\w+)\.framework\/?$/)[0]
    if @private
      headers_path = File.join(path, 'PrivateHeaders')
      die "Can't locate private framework headers at '#{headers_path}'" unless File.exist?(headers_path) 
      headers = Dir.glob(File.join(headers_path, '**', '*.h'))
      public_headers_path = File.join(path, 'Headers')
      public_headers = if File.exist?(public_headers_path)
        OCHeaderAnalyzer::CPPFLAGS << " -I#{public_headers_path} "
        Dir.glob(File.join(headers_path, '**', '*.h'))
      else
        []
      end
    else
      headers_path = File.join(path, 'Headers')
      die "Can't locate public framework headers at '#{headers_path}'" unless File.exist?(headers_path) 
      public_headers = headers = Dir.glob(File.join(headers_path, '**', '*.h'))
    end
    libpath = File.join(path, name)
    die "Can't locate framework library at '#{libpath}'" unless File.exist?(libpath)
    OBJC.dlload(libpath)
    # We can't just "#import <x/x.h>" as the main Framework header might not include _all_ headers.
    # So we are tricking this by importing the main header first, then all headers.
    header_basenames = (headers | public_headers).map { |x| x.sub(/#{headers_path}\/*/, '') } 
    if idx = header_basenames.index("#{name}.h")
      header_basenames.delete_at(idx)
      header_basenames.unshift("#{name}.h")
    end
    @import_directive = header_basenames.map { |x| "#import <#{name}/#{x}>" }.join("\n")
    @compiler_flags ||= "-F\"#{parent_path}\" -framework #{name}"
    @headers.concat(headers)
  end
 
  def framework_path(val)
    return val if File.exist?(val)
    val += '.framework' unless /\.framework$/.match(val)
    paths = ['/System/Library/Frameworks',
     '/Library/Frameworks',
     "#{ENV['HOME']}/Library/Frameworks"
    ]
    paths << '/System/Library/PrivateFrameworks' if @private
    paths.each do |dir|
      path = File.join(dir, val)
      return path if File.exist?(path)
    end
    return nil
  end

  def die(*msg)
    STDERR.puts msg
    exit 1
  end
  
  def unique_tmp_path(base, extension='', dir=Dir.tmpdir)
    i = 0
    loop do
      p = File.join(dir, "#{base}-#{i}-#{Process.pid}" + extension)
      return p unless File.exist?(p)
      i += 1
    end
  end

  IS_PPC = `arch`.strip == 'ppc'
  def compile_and_execute_code(code, cleanup_when_fail=false, run_64_bit=false)
    if @import_directive.nil? or @compiler_flags.nil?
      STDERR.puts "Can't compile for non-frameworks targets (yet)"
      return ''
    end
    
    tmp_src = File.open(unique_tmp_path('src', '.m'), 'w')
    tmp_src.puts code
    tmp_src.close

    tmp_bin_path = unique_tmp_path('bin')
    tmp_log_path = unique_tmp_path('log')

    arch_flag =     
      if run_64_bit
        raise "64-bit not supported on Tiger or below" if TIGER_OR_BELOW
        " -arch #{IS_PPC ? 'ppc64' : 'x86_64'}"
      else
        '' # nothing, by default the compiler choose the 32-bit arch
      end

    line = "gcc #{arch_flag} #{tmp_src.path} -o #{tmp_bin_path} #{@compiler_flags} 2>#{tmp_log_path}"
    unless system(line)
      msg = "Can't compile C code... aborting\ncommand was: #{line}\n\n#{File.read(tmp_log_path)}"
      File.unlink(tmp_log_path)
      File.unlink(tmp_src.path) if cleanup_when_fail
      raise msg
    end

    env = ''
    if @framework_paths
      env << "DYLD_FRAMEWORK_PATH=\"#{@framework_paths.join(':')}\""
    end

    env << " arch #{arch_flag}" if run_64_bit

    out = `#{env} #{tmp_bin_path}`
    unless $?.success?
      raise "Can't execute compiled C code... aborting\nbinary is #{tmp_bin_path}"
    end

    File.unlink(tmp_log_path)
    File.unlink(tmp_src.path)
    File.unlink(tmp_bin_path)

    return out
  end
end

if f = ENV['GBM_FLAGS']
  args = f.scan(/((\"[^"]+\")|[^\s]+)/).map { |x| x[0].delete('"') }
  ARGV.unshift(*args)
end
BridgeSupportGenerator.new(ARGV)
