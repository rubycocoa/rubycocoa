/** -*-objc-*-
 *
 *   $Id$
 *
 *   Copyright (c) 2001 FUJIMOTO Hisakuni
 *
 **/

#import "mdl_osxobjc.h"
#import "osx_ruby.h"
#import <Foundation/Foundation.h>
#import "RubyCocoa.h"
#import "Version.h"
#import "RBThreadSwitcher.h"
#import "RBObject.h"
#import "RBClassUtils.h"
#import "ocdata_conv.h"
#import <mach-o/dyld.h>
#import <string.h>

#define OSX_MODULE_NAME "OSX"

static VALUE _cOCObject = Qnil;
static ID _within_NSClassFromString_ID;
ID _relaxed_syntax_ID;

static VALUE init_module_OSX()
{
  VALUE module;
  RB_ID id_osx = rb_intern(OSX_MODULE_NAME);

  if (rb_const_defined(rb_cObject, id_osx))
    module = rb_const_get(rb_cObject, id_osx);
  else
    module = rb_define_module(OSX_MODULE_NAME);
  return module;
}

static VALUE init_cls_OCObject(VALUE mOSX)
{
  VALUE kObjcID;
  VALUE kOCObject;
  VALUE mOCObjWrapper;

  kObjcID = rb_const_get(mOSX, rb_intern("ObjcID"));
  kOCObject = rb_define_class_under(mOSX, "OCObject", kObjcID);
  mOCObjWrapper = rb_const_get(mOSX, rb_intern("OCObjWrapper"));
  rb_include_module(kOCObject, mOCObjWrapper);

  return kOCObject;
}

// def OSX.objc_proxy_class_new (kls, kls_name)
// ex1.  OSX.objc_proxy_class_new (AA::BB::AppController, "AppController")
static VALUE
osx_mf_objc_proxy_class_new(VALUE mdl, VALUE kls, VALUE kls_name)
{
  kls_name = rb_obj_as_string(kls_name);
  RBObjcClassNew(kls, STR2CSTR(kls_name), [RBObject class]);
  return Qnil;
}

// def OSX.objc_derived_class_new (kls, kls_name, super_name)
// ex1.  OSX.objc_derived_class_new (AA::BB::CustomView, "CustomView", "NSView")
static VALUE
osx_mf_objc_derived_class_new(VALUE mdl, VALUE kls, VALUE kls_name, VALUE super_name)
{
  Class super_class;
  Class new_cls = nil;

  kls_name = rb_obj_as_string(kls_name);
  super_name = rb_obj_as_string(super_name);
  super_class = objc_getClass(STR2CSTR(super_name));
  if (super_class)
    new_cls = RBObjcDerivedClassNew(kls, STR2CSTR(kls_name), super_class);

  if (new_cls)
    return ocobj_s_new(new_cls);
  return Qnil;
}

// def OSX.objc_derived_class_method_add (kls, method_name)
// ex1.  OSX.objc_derived_class_method_add (AA::BB::CustomView, "drawRect:")
static VALUE
osx_mf_objc_derived_class_method_add(VALUE mdl, VALUE kls, VALUE method_name)
{
  Class a_class;
  SEL a_sel;

  method_name = rb_obj_as_string(method_name);
  a_class = RBObjcClassFromRubyClass (kls);
  a_sel = sel_registerName(STR2CSTR(method_name));
  if (a_class && a_sel) {
    [a_class addRubyMethod: a_sel];
  }
  return Qnil;
}

static VALUE
osx_mf_ruby_thread_switcher_start(int argc, VALUE* argv, VALUE mdl)
{
  VALUE arg_interval, arg_wait;
  double interval, wait;

  rb_scan_args(argc, argv, "02", &arg_interval, &arg_wait);

  if (arg_interval == Qnil) {
    [RBThreadSwitcher start];
  }
  else {
    Check_Type(arg_interval, T_FLOAT);
    interval = RFLOAT(arg_interval)->value;

    if (arg_wait == Qnil) {
      [RBThreadSwitcher start: interval];
    }
    else {
      Check_Type(arg_wait, T_FLOAT);
      wait = RFLOAT(arg_wait)->value;
      [RBThreadSwitcher start: interval wait: wait];
    }
  }
  return Qnil;
}

static VALUE
osx_mf_ruby_thread_switcher_stop(VALUE mdl)
{
  [RBThreadSwitcher stop];
  return Qnil;
}

static VALUE
ns_autorelease_pool(VALUE mdl)
{
  id pool = [[NSAutoreleasePool alloc] init];
  rb_yield(Qnil);
  [pool release];
  return Qnil;
}

static void
thread_switcher_start()
{
  [RBThreadSwitcher start];
}

static VALUE
osx_mf_init_cocoa(VALUE mdl)
{
  extern void init_cocoa(VALUE);
  static int init_p = 0;
  if (init_p) 
    return Qfalse;
  rb_require("osx/objc/oc_types");
  init_cocoa(mdl);
  init_p = 1;
  return Qtrue;
}

/******************/

static VALUE
wrapper_rb_osx_const (VALUE name)
{
  VALUE mOSX;
  
  mOSX = osx_s_module();
  if (NIL_P(mOSX)) 
    return Qnil;
  
  return rb_const_get(mOSX, rb_intern(StringValueCStr(name)));
}

static VALUE
rb_osx_const (const char* name)
{
  VALUE mOSX;
  VALUE constant;
  VALUE old_ruby_debug;
  
  mOSX = osx_s_module();
  if (NIL_P(mOSX)) 
    return Qnil;

  constant = Qnil;

  if (rb_ivar_get(mOSX, _within_NSClassFromString_ID) == Qtrue) {
    // We are called by NSClassFromString, just return the constant if it exists.
    if (rb_const_defined(mOSX, rb_intern(name)))
      constant = rb_const_get(mOSX, rb_intern(name));
  }
  else {
    // Explicitely call const_get, this will make sure the constant is generated if it does not
    // exist (through const_missing -> OSX::ns_import...).
    // Disable warnings just between the const_get instruction, as it would raise too many false
    // positives.
    old_ruby_debug = ruby_debug;
    ruby_debug = Qfalse;
    constant = rb_rescue2(&wrapper_rb_osx_const, rb_str_new2(name), NULL, Qnil, rb_eNameError, NULL);  
    ruby_debug = old_ruby_debug;
  }

  return constant;
}

static VALUE
rb_cls_ocobj (const char* name)
{
  VALUE cls = rb_osx_const(name);
  if (cls == Qnil) 
    cls = _cOCObject;
  return cls;
}

static id
rb_obj_ocid(VALUE rcv)
{
  VALUE val = rb_funcall(rcv, rb_intern("__ocid__"), 0);
  return NUM2OCID(val);
}

static VALUE
osx_mf_objc_symbol_to_obj(VALUE mdl, VALUE const_name, VALUE const_type)
{
  VALUE result = Qnil;
  char buf[BUFSIZ];
  NSSymbol sym = NULL;
  void* addr = NULL;
  int octype;

  const_name = rb_obj_as_string(const_name);
  const_type = rb_obj_as_string(const_type);

  strncpy(buf+1, STR2CSTR(const_name), BUFSIZ - 1);
  buf[0] = '_';
  if (NSIsSymbolNameDefined(buf) == FALSE)
    rb_raise(rb_eRuntimeError, "symbol '%s' not found.", STR2CSTR(const_name));

  sym = NSLookupAndBindSymbol(buf);
  if (sym == NULL)
    rb_raise(rb_eRuntimeError, "symbol'%s' is NULL.", STR2CSTR(const_name));

  addr = NSAddressOfSymbol(sym);
  if (addr == NULL)
    rb_raise(rb_eRuntimeError, "address of '%s' is NULL.", STR2CSTR(const_name));

  octype = to_octype(STR2CSTR(const_type));
  if (!ocdata_to_rbobj(Qnil, octype, addr, &result))
    rb_raise(rb_eRuntimeError, "cannot convert to rbobj for type '%s'.", STR2CSTR(const_type));

  return result;
}

/***/

VALUE
osx_s_module()
{
  RB_ID rid;

  rid = rb_intern("OSX");
  if (! rb_const_defined(rb_cObject, rid))
    return rb_define_module("OSX");
  return rb_const_get(rb_cObject, rid);
}

VALUE
ocobj_s_new(id ocid)
{
  VALUE obj;
  const char *cls_name;

  cls_name = object_getClassName(ocid);
  obj = rb_funcall(rb_cls_ocobj(cls_name), rb_intern("new_with_ocid"), 1, OCID2NUM(ocid));
  return obj;
}

id
rbobj_get_ocid (VALUE obj)
{
  RB_ID mtd;

  if (rb_obj_is_kind_of(obj, objid_s_class()) == Qtrue)
    return rb_obj_ocid(obj);

  mtd = rb_intern("__ocid__");
  if (rb_respond_to(obj, mtd))
    return rb_obj_ocid(obj);

  if (rb_respond_to(obj, rb_intern("to_nsobj"))) {
    VALUE nso = rb_funcall(obj, rb_intern("to_nsobj"), 0);
    return rb_obj_ocid(nso);
  }

  return nil;
}

VALUE
ocid_get_rbobj (id ocid)
{
  VALUE result = Qnil;

  @try {  
    if ([ocid isProxy] && [ocid isRBObject])
      result = [ocid __rbobj__];
    else if ([ocid respondsToSelector: @selector(__rbobj__)])
      result = [ocid __rbobj__];
  } 
  @catch (id exception) {
    result = Qnil;
  }

  return result;
}

static ID _bridge_support_signatures_ID;

#if HAS_LIBXML2
#include <libxml/xmlreader.h>
static BOOL
next_node(xmlTextReaderPtr reader)
{
  int   retval;

  retval = xmlTextReaderRead(reader);
  if (retval == 0)
    return NO;

  if (retval < 0)
    rb_raise(rb_eRuntimeError, "parsing error: %d", retval);

  return YES;
}

static VALUE
get_attribute_and_check(xmlTextReaderPtr reader, const char *name)
{
  xmlChar * attribute;
  VALUE     value;
  
  attribute = xmlTextReaderGetAttribute(reader, (const xmlChar *)name);
  if (attribute == NULL)
    rb_raise(rb_eRuntimeError, "expected attribute `%s' for element `%s'", name, xmlTextReaderConstName(reader));

  value = rb_str_new2((const char *)attribute);
  xmlFree(attribute);

  return value;
}

static VALUE
get_value_and_check(xmlTextReaderPtr reader)
{
  const xmlChar * value;
  
  value = xmlTextReaderConstValue(reader);
  if (value == NULL)
    rb_raise(rb_eRuntimeError, "expected value for element `%s'", xmlTextReaderConstName(reader));

  return rb_str_new2((const char *)value);
}

static inline void
add_method_if_needed(VALUE signatures, VALUE class_name, VALUE methods_type, VALUE selector, VALUE passbyref_args_n)
{
  VALUE class_hash;
  VALUE methods_type_ary;
  VALUE value;
  int i;

  if (NIL_P(class_name) || NIL_P(methods_type) || NIL_P(selector) || NIL_P(passbyref_args_n) || RARRAY(passbyref_args_n)->len == 0)
    return;
  
  class_hash = rb_hash_aref(signatures, class_name);
  if (NIL_P(class_hash)) {
    class_hash = rb_hash_new();
    rb_hash_aset(signatures, class_name, class_hash);
  }
  
  methods_type_ary = rb_hash_aref(class_hash, methods_type);
  if (NIL_P(methods_type_ary)) {
    methods_type_ary = rb_ary_new();
    rb_hash_aset(class_hash, methods_type, methods_type_ary);
  }
  
  value = rb_ary_new();
  rb_ary_push(value, selector);
  for (i = 0; i < RARRAY(passbyref_args_n)->len; i++)
    rb_ary_push(value, RARRAY(passbyref_args_n)->ptr[i]);

  rb_ary_push(methods_type_ary, value);
  
  rb_ary_clear(passbyref_args_n);
}

static VALUE
osx_mf_load_bridge_support_file (VALUE rcv, VALUE path)
{
  const char *      cpath;
  xmlTextReaderPtr  reader;
  VALUE             signatures;
  VALUE             current_class_name;
  VALUE             current_methods_type;
  VALUE             current_selector;
  VALUE             current_passbyref_args_n;
  
  signatures = rb_ivar_get(rcv, _bridge_support_signatures_ID);
  if (NIL_P(signatures))
    rb_raise(rb_eRuntimeError, "internal bridge support signatures cache not available");

  cpath = STR2CSTR(path);

  DLOG(@"MDLOSX", "Loading bridge support file `%s'", cpath);
  
  reader = xmlNewTextReaderFilename(cpath);
  if (reader == NULL)
    rb_raise(rb_eRuntimeError, "cannot create XML text reader for file at path `%s'", cpath);

  current_class_name = current_methods_type = current_selector = current_passbyref_args_n = Qnil;

  while (YES) {
    const char *name;
    int node_type = -1;
    BOOL eof;

    do {
      if ((eof = !next_node(reader)))
        break;
      
      node_type = xmlTextReaderNodeType(reader);
    }
    while (node_type != 1 && node_type != 15);    
    
    if (eof)
      break;

#define next_value(reader)                      \
  do {                                          \
    if ((eof = !next_node(reader)))             \
      break;                                    \
  }                                             \
  while (xmlTextReaderNodeType(reader) != 3)
    
    name = (const char *)xmlTextReaderConstName(reader);
    
    if (node_type == 1) {    
      if (strcmp("class", name) == 0) {
        current_class_name = get_attribute_and_check(reader, "name");
      }
      else if (strcmp("class_methods", name) == 0 || strcmp("instance_methods", name) == 0) {
        current_methods_type = ID2SYM(rb_intern(name));
      }
      else if (strcmp("selector", name) == 0) {
        next_value(reader);
        if (eof)
          break;
        current_selector = get_value_and_check(reader);
      }
      else if (strcmp("by_reference_argument", name) == 0) {
        next_value(reader);
        if (eof)
          break;
        if (NIL_P(current_passbyref_args_n))
          current_passbyref_args_n = rb_ary_new();
        rb_ary_push(current_passbyref_args_n, rb_str_to_inum(get_value_and_check(reader), 10, Qfalse));
      }
    }
    else if (node_type == 15) {
      if (strcmp("method", name) == 0) {
        add_method_if_needed(signatures, current_class_name, current_methods_type, current_selector, current_passbyref_args_n);      
      }
    }
  }

  xmlFreeTextReader(reader);

  return rcv;
}
#else
static VALUE
osx_mf_load_bridge_support_file (VALUE rcv, VALUE path)
{
  rb_warn("libxml2 is not available, bridge support file `%s' cannot be read", STR2CSTR(path));
  return rcv;
}
#endif

/******************/

void initialize_mdl_osxobjc()
{
  VALUE mOSX;

  _bridge_support_signatures_ID = rb_intern("@bridge_support_signatures");

  mOSX = init_module_OSX();
  init_cls_ObjcPtr(mOSX);
  init_cls_ObjcID(mOSX);
  init_mdl_OCObjWrapper(mOSX);
  _cOCObject = init_cls_OCObject(mOSX);

  _within_NSClassFromString_ID = rb_intern("@within_NSClassFromString");
  rb_ivar_set(mOSX, _within_NSClassFromString_ID, Qfalse);

  _relaxed_syntax_ID = rb_intern("@relaxed_syntax");
  rb_ivar_set(mOSX, _relaxed_syntax_ID, Qtrue);

  rb_define_module_function(mOSX, "objc_proxy_class_new", 
			    osx_mf_objc_proxy_class_new, 2);
  rb_define_module_function(mOSX, "objc_derived_class_new", 
			    osx_mf_objc_derived_class_new, 3);
  rb_define_module_function(mOSX, "objc_derived_class_method_add",
			    osx_mf_objc_derived_class_method_add, 2);

  rb_define_module_function(mOSX, "ruby_thread_switcher_start",
			    osx_mf_ruby_thread_switcher_start, -1);
  rb_define_module_function(mOSX, "ruby_thread_switcher_stop",
			    osx_mf_ruby_thread_switcher_stop, 0);

  rb_define_module_function(mOSX, "init_cocoa",
			    osx_mf_init_cocoa, 0);
  rb_define_module_function(mOSX, "ns_autorelease_pool",
			    ns_autorelease_pool, 0);
  rb_define_module_function(mOSX, "load_bridge_support_file",
			    osx_mf_load_bridge_support_file, 1);

  rb_define_const(mOSX, "RUBYCOCOA_VERSION", 
		  rb_obj_freeze(rb_str_new2(RUBYCOCOA_VERSION)));
  rb_define_const(mOSX, "RUBYCOCOA_RELEASE_DATE", 
		  rb_obj_freeze(rb_str_new2(RUBYCOCOA_RELEASE_DATE)));
  rb_define_const(mOSX, "RUBYCOCOA_SVN_REVISION", 
		  rb_obj_freeze(rb_str_new2(RUBYCOCOA_SVN_REVISION)));

  rb_define_module_function(mOSX, "objc_symbol_to_obj", osx_mf_objc_symbol_to_obj, 2);

  thread_switcher_start();
}
