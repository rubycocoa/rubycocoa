#
#  $Id$
#
#  Copyright (c) 2001 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
#
#  This program is free software.
#  You can distribute/modify this program under the terms of
#  the GNU Lesser General Public License version 2.
#

FORCE_MODE = (ARGV.size > 0 && ARGV[0] == "-f")

require 'och_analyzer'

def collect_src_headers(src_path, re_pat)
  File.open(src_path) {|f|
    f.map {|s|
      if m = re_pat.match(s) then
	File.join(File.dirname(src_path), m[1])
      end
    }.compact.uniq
  }
end

def collect_appkit_headers
  path = "/System/Library/Frameworks/AppKit.framework/Headers/AppKit.h"
  re = %r{^\s*#import\s*<AppKit/(\w+\.h)>}
  collect_src_headers(path, re)
end

def collect_foundation_headers
  path = '/System/Library/Frameworks/Foundation.framework/Headers/Foundation.h'
  re = %r{^\s*#import\s*<Foundation/(\w+\.h)>}
  collect_src_headers(path, re)
end

def collect_classes(pathes)
  re = /^\s*@interface\s+(\w*)\b/
  names = Array.new
  pathes.each do |path|
    File.open(path) do |f|
      names.concat f.map {|line|
	m = re.match(line)
	m[1] if m && m.size > 0
      }
    end
  end
  names.compact!
  names.uniq!
  names
end

STATIC_FUNCS = <<'STATIC_FUNCS_DEFINE'
static void
rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index)
{
  if (!rbobj_to_ocdata(rbarg, octype, nsarg)) {
    if (pool) [pool release];
    rb_raise(rb_eArgError, "arg #%d cannot convert to nsobj.", index);
  }
}

static VALUE
nsresult_to_rbresult(int octype, const void* nsresult, id pool)
{
  VALUE rbresult;
  if (octype == _C_ID) {
    rbresult = ocobj_new_with_ocid(*(id*)nsresult);
  }
  else {
    if (!ocdata_to_rbobj(octype, nsresult, &rbresult)) {
      if (pool) [pool release];
      rb_raise(rb_eRuntimeError, "result cannot convert to rbobj.");
    }
  }
  return rbresult;
}
STATIC_FUNCS_DEFINE

GEN_C_FUNC_NOTIMPL =  "  rb_notimplement();\n"


def gen_c_func_body_noarg(info)
  name = info.name
  name += "()" if info.is_a? OCHeaderAnalyzer::FuncInfo
  if info.octype == :UNKNOWN then
    GEN_C_FUNC_NOTIMPL
  elsif info.octype == :_C_VOID then
    "  #{name};\n" +
    "  return Qnil;\n"
  else
    "  #{info.type} ns_result = #{name};\n" +
    "  return nsresult_to_rbresult(#{info.octype}, &ns_result, nil);\n"
  end
end

def gen_c_func_arglist(argc)
  if argc == 0 then
    "(VALUE mdl)"
  elsif argc == -1 then
    "(int argc, VALUE* argv, VALUE mdl)"
  else
    s = "(VALUE mdl"
    argc.times {|i| s.concat ", VALUE a#{i}" }
    s.concat ")"
    s
  end
end

def gen_c_func_var_defs(arginfos)
  ret = ""
  arginfos.each_with_index do |info,index|
    ret.concat "  #{info.type} ns_a#{index};\n"
  end
  ret
end

def gen_c_func_var_sets(arginfos, va = false)
  ret = ""
  arginfos.each_with_index do |info,index|
    return nil if info.octype == :UNKNOWN
    aname = va ? "argv[#{index}]" : "a#{index}"
    type_str = info.octype.to_s
    type_str = "_C_UCHR" if info.octype == :_PRIV_C_BOOL
    ret.concat "  /* #{aname} */\n"
    ret.concat "  rbarg_to_nsarg(#{aname}, #{type_str}, "
    ret.concat "&ns_a#{index}, pool, #{index});\n"
  end
  ret
end

def gen_c_func_func_call(info)
  if info.octype == :_C_VOID then
    s = "  #{info.name}("
  else
    s = "  ns_result = #{info.name}("
  end
  s.concat ((0...info.args.size).map{|i| "ns_a#{i}"}.join(', '))
  s.concat ");\n"
  s
end

def gen_c_func_conv_call(octype)
  if octype == :UNKNOWN then
    nil
  elsif octype == :_C_VOID then
    "Qnil"
  else
    "nsresult_to_rbresult(#{octype}, &ns_result, pool)"
  end
end

FUNC_BODY_TMPL = <<'FUNC_BODY_TMPL_DEFINE'
%%ns_result_defs%%
%%var_defs%%
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
%%var_set%%
%%func_call%%
  rb_result = %%conv_call%%;
  [pool release];
  return rb_result;
FUNC_BODY_TMPL_DEFINE

def gen_def_c_func_body(info, va = false)
  ngresult = GEN_C_FUNC_NOTIMPL
  return ngresult if info.octype == :UNKNOWN
  tmpl = FUNC_BODY_TMPL.dup
  if info.octype == :_C_VOID then
    tmpl.sub! /%%ns_result_defs%%/, ''
  else
    tmpl.sub! /%%ns_result_defs%%/, "  #{info.type} ns_result;\n"
  end
  tmpl.sub! /%%var_defs%%/, gen_c_func_var_defs(info.args)
  unless s = gen_c_func_var_sets(info.args, va) then
    return ngresult
  end
  tmpl.sub! /%%var_set%%/,  s
  tmpl.sub! /%%func_call%%/,  gen_c_func_func_call(info)
  unless s = gen_c_func_conv_call(info.octype) then
    return ngresult
  end
  tmpl.sub! /%%conv_call%%/, s
  tmpl
end


def gen_def_c_func(info, argc = -1)
  ret =      "// #{info.orig};\n"
  ret.concat "static VALUE\nosx_#{info.name}"
  ret.concat gen_c_func_arglist(argc)
  ret.concat "\n{\n"

  if argc == 0 then
    ret.concat gen_c_func_body_noarg(info)
  elsif argc > 0 then
    ret.concat gen_def_c_func_body(info)
  else
    ret.concat GEN_C_FUNC_NOTIMPL
  end

  ret.concat "}\n\n"
  ret
end

def gen_def_rb_mod_func(info, argc = -1)
  ret =      "  rb_define_module_function(mOSX, \""
  ret.concat "#{info.name}\", osx_#{info.name}, #{argc});\n"
  ret
end

def gen_def_enums(och)
  enums = och.enums
  return nil if enums.size == 0
  ret = "  /**** enums ****/\n"
  enums.each do |name|
    ret.concat "  rb_define_const(mOSX, \"#{name}\", INT2NUM(#{name}));\n"
  end
  ret.concat "\n"
  ret
end

def reconfig_info(info)
  if CLASSES.find {|c| /^(const\s+)?#{c}\s*\*$/.match(info.type) } then
    info.octype = :_C_ID
  end
  if info.is_a? OCHeaderAnalyzer::FuncInfo then
    info.args.each do |i|
      if CLASSES.find {|c| /^(const\s+)?#{c}\s*\*$/.match(i.type) } then
	i.octype = :_C_ID
      end
    end
  end
end

def gen_def_consts(och)
  consts = och.constants
  return nil if consts.size == 0
  ret_a = "  /**** constants ****/\n"
  ret_b = "  /**** constants ****/\n"
  consts.each do |info|
    reconfig_info(info)
    ret_a.concat gen_def_c_func(info, 0)
    ret_b.concat gen_def_rb_mod_func(info, 0)
  end
  [ ret_a, ret_b ]
end

def gen_def_funcs(och)
  funcs = och.functions
  return nil if funcs.size == 0
  ret_a = "  /**** functions ****/\n"
  ret_b = "  /**** functions ****/\n"
  funcs.each do |info|
    reconfig_info(info)
    ret_a.concat gen_def_c_func(info, info.argc)
    ret_b.concat gen_def_rb_mod_func(info, info.argc)
  end
  [ ret_a, ret_b ]
end

def gen_skelton(hpath)
  och = OCHeaderAnalyzer.new(hpath)
  $stderr.puts "#{och.filename}..."
  enums = gen_def_enums(och)
  consts = gen_def_consts(och)
  funcs = gen_def_funcs(och)
  if enums || consts || funcs then
    name = och.filename.split('.')[0]
    fname = "rb_#{name}.m"
    if File.exist?(fname) then
      if FORCE_MODE then
	system "mkdir -p old"
	File.rename(fname, "old/#{fname}")
      else
	raise "'#{fname}' already exist !"
      end
    end
    File.open(fname, "w") do |f|
      f.print "\#import <LibRuby/cocoa_ruby.h>\n"
      f.print "\#import \"ocdata_conv.h\"\n"
      f.print "\#import <#{och.framework}/#{och.framework}.h>\n\n"
      f.print STATIC_FUNCS
      f.print "\n\n"
      f.print consts[0] if consts
      f.print funcs[0] if funcs
      f.print "void init_#{name}(VALUE mOSX)\n"
      f.print "{\n"
      f.print enums if enums
      f.print consts[1] if consts
      f.print funcs[1] if funcs
      f.print "}\n"
    end
  end
end

fnd_headers = collect_foundation_headers
akt_headers = collect_appkit_headers
CLASSES = collect_classes(fnd_headers) + collect_classes(akt_headers)
CLASSES.uniq!

fnd_headers.each {|hpath| gen_skelton(hpath) }
akt_headers.each {|hpath| gen_skelton(hpath) }
