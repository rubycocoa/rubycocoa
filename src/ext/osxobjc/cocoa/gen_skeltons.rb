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

FUNC_TMPLATE_A = <<'FUNC_TMPLATE_A_DEFINE'
  id pool = [[NSAutoreleasePool alloc] init];
  %%retvar%%
  VALUE rb_result;
%%argpart%%
  %%retresult%% %%fname%%(%%args%%);
  rb_result = %%rbretval%%;
  [pool release];
  return rb_result;
FUNC_TMPLATE_A_DEFINE

FUNC_TMPLATE_A_ARG_PART = <<'FUNC_TMPLATE_A_ARG_PART_DEFINE'
  int i;
  id oc_args[%%argc%%];
  for (i = 0; i < argc; i++) {
    if (!rbobj_to_nsobj(argv[i], &oc_args[i])) {
      [pool release];
      rb_raise(rb_eArgError, "arg #%d cannot convert to nsobj.", i);
    }
  }
FUNC_TMPLATE_A_ARG_PART_DEFINE

def tmpl_a_gsub(tmpl, fname, argc)
  tmpl.gsub! /%%fname%%/, fname
  if argc > 0  then
    tmpl.gsub! /%%argpart%%/, FUNC_TMPLATE_A_ARG_PART
    argnames = Array.new
    argc.times {|i| argnames.push "oc_args[#{i}]" }
    tmpl.gsub! /%%argc%%/, argc.to_s
    tmpl.gsub! /%%args%%/, argnames.join(', ')
  else
    tmpl.gsub! /%%argpart%%/, ''
    tmpl.gsub! /%%args%%/, ''
  end
end

def tmpl_a_gsub_rettype(tmpl, rettype)
  if rettype == 'void' then
    tmpl.gsub! /%%retvar%%/, ""
    tmpl.gsub! /%%retresult%%/, ""
    tmpl.gsub! /%%rbretval%%/, "Qnil"
  else
    tmpl.gsub! /%%retvar%%/, "#{rettype} ns_result;"
    tmpl.gsub! /%%retresult%%/, "ns_result = "
    if rettype == 'id' then
      tmpl.gsub! /%%rbretval%%/, "ocobj_new_with_ocid(ns_result)"
    elsif rettype == 'BOOL' then
      tmpl.gsub! /%%rbretval%%/, "bool_to_rbobj(ns_result)"
    end
  end
end


def is_objc_id?(val)
  if val.is_a? Array then
    val.each {|i| return false unless is_objc_id?(i) }
  elsif val == "id" || val == 'Class' then
    true
  else
    f = false
    CLASSES.each do |c|
      re = /^#{c}\s*\*$/
      if re.match(val) then
	f = true
	break
      end
    end
    f
  end
end

def gen_def_c_func(info, argc = -1)
  ret =      "// #{info.orig};\n"
  ret.concat "static VALUE\nosx_#{info.name}"
  if argc == 0 then
    ret.concat "(VALUE mdl)\n"
  else
    ret.concat "(int argc, VALUE* argv, VALUE mdl)\n"
  end
  ret.concat "{\n"
  if info.is_a? OCHeaderAnalyzer::FuncInfo then
    argtypes = info.args.map{|i|i.type}
    if is_objc_id?(argtypes) then
      tmpl = FUNC_TMPLATE_A.dup
      tmpl_a_gsub(tmpl, info.name, info.args.size)
      if is_objc_id?(info.type) then
	tmpl_a_gsub_rettype(tmpl, "id")
	ret.concat tmpl
      elsif info.type == 'BOOL' then
	tmpl_a_gsub_rettype(tmpl, info.type)
	ret.concat tmpl
      elsif info.type == 'void' then
	tmpl_a_gsub_rettype(tmpl, info.type)
	ret.concat tmpl
      else
	ret.concat "  rb_notimplement();\n"
      end
    elsif argc == 0 && is_objc_id?(info.type) then
      ret.concat "  return ocobj_new_with_ocid(#{info.name}());\n"
    else
      ret.concat "  rb_notimplement();\n"
    end
  else
    if argc == 0 && is_objc_id?(info.type) then
      ret.concat "  return ocobj_new_with_ocid(#{info.name});\n"
    else
      ret.concat "  rb_notimplement();\n"
    end
  end
  ret.concat "}\n\n"
  ret
end

def gen_def_rb_mod_func(info, argc = -1)
  argc = -1 if argc > 0
  ret =      "  rb_define_module_function(mOSX, \""
  ret.concat "#{info.name}\", osx_#{info.name}, #{argc});\n"
  ret
end

def gen_def_consts(och)
  consts = och.constants
  return nil if consts.size == 0
  ret_a = "  /**** constants ****/\n"
  ret_b = "  /**** constants ****/\n"
  consts.each do |info|
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
    argc = info.args.size
    argc = -1 if info.args[-1].type == '...'
    ret_a.concat gen_def_c_func(info, argc)
    ret_b.concat gen_def_rb_mod_func(info, argc)
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
	File.rename(fname, "#{fname}.old")
      else
	raise "'#{fname}' already exist !"
      end
    end
    File.open(fname, "w") do |f|
      f.print "\#import <LibRuby/cocoa_ruby.h>\n"
      f.print "\#import \"ocdata_conv.h\"\n"
      f.print "\#import <#{och.framework}/#{och.framework}.h>\n\n"
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
