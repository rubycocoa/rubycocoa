/** -*-objc-*-
 *
 *   $Id$
 *
 *   Copyright (c) 2001 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
 *
 *   This program is free software.
 *   You can distribute/modify this program under the terms of
 *   the GNU Lesser General Public License version 2.
 *
 **/

#import "osx_ruby.h"
#import <Foundation/Foundation.h>
#import "RubyCocoa.h"
#import "RBThreadSwitcher.h"

#define OSX_MODULE_NAME "OSX"

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

// def OSX.objc_proxy_class_new (kls, kls_name)
// ex1.  OSX.objc_proxy_class_new (AA::BB::AppController, "AppController")
static VALUE
osx_mf_objc_proxy_class_new(VALUE mdl, VALUE kls, VALUE kls_name)
{
  kls_name = rb_obj_as_string(kls_name);
  RBOCClassNew(kls, STR2CSTR(kls_name), [RBObject class]);
  return Qnil;
}

// def OSX.objc_derived_class_new (kls, kls_name, super_name)
// ex1.  OSX.objc_derived_class_new (AA::BB::CustomView, "CustomView", "NSView")
static VALUE
osx_mf_objc_derived_class_new(VALUE mdl, VALUE kls, VALUE kls_name, VALUE super_name)
{
  Class super_class;
  Class new_cls = nil;
  id pool = [[NSAutoreleasePool alloc] init];

  kls_name = rb_obj_as_string(kls_name);
  super_name = rb_obj_as_string(super_name);
  super_class = NSClassFromString([NSString 
				    stringWithCString: STR2CSTR(super_name)]);
  if (super_class)
    new_cls = RBOCDerivedClassNew(kls, STR2CSTR(kls_name), super_class);
  [pool release];

  if (new_cls)
    return rb_ocobj_s_new(new_cls);
  return Qnil;
}

// def OSX.objc_derived_class_method_add (kls, method_name)
// ex1.  OSX.objc_derived_class_method_add (AA::BB::CustomView, "drawRect:")
static VALUE
osx_mf_objc_derived_class_method_add(VALUE mdl, VALUE kls, VALUE method_name)
{
  Class a_class;
  SEL a_sel;
  id pool = [[NSAutoreleasePool alloc] init];

  method_name = rb_obj_as_string(method_name);
  a_class = RBOCObjcClassFromRubyClass (kls);
  a_sel =
    NSSelectorFromString([NSString stringWithCString: STR2CSTR(method_name)]);
  if (a_class && a_sel) {
    [a_class addRubyMethod: a_sel];
  }
  [pool release];
  return Qnil;
}

static VALUE
osx_mf_ruby_thread_switcher_start(int argc, VALUE* argv, VALUE mdl)
{
  VALUE arg_interval, arg_wait;
  double interval, wait;

  rb_scan_args(argc, argv, "11", &arg_interval, &arg_wait);
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

void Init_osx_objc()
{
  VALUE mOSX;
  extern void init_cocoa(VALUE);

  mOSX = init_module_OSX();
  init_cls_ObjcID(mOSX);
  init_mdl_OCObjWrapper(mOSX);

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

  rb_define_module_function(mOSX, "ns_autorelease_pool",
			    ns_autorelease_pool, 0);

  rb_define_const(mOSX, "RUBYCOCOA_VERSION", 
		  rb_obj_freeze(rb_str_new2(RUBYCOCOA_VERSION)));
  rb_define_const(mOSX, "RUBYCOCOA_RELEASE_DATE", 
		  rb_obj_freeze(rb_str_new2(RUBYCOCOA_RELEASE_DATE)));

  init_cocoa(mOSX);
}
