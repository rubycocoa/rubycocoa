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

#import <LibRuby/cocoa_ruby.h>
#import <Foundation/Foundation.h>
#import <RubyCocoa/RBRuntime.h>
#import <RubyCocoa/RBObject.h>
#import <RubyCocoa/ocdata_conv.h>

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

// def OSX.objc_proxy_class_new (class_name)
// ex1.  OSX.objc_proxy_class_new (:AppController)
static VALUE
osx_mf_objc_proxy_class_new(VALUE mdl, VALUE class_name)
{
  class_name = rb_obj_as_string(class_name);
  RBOCClassNew(STR2CSTR(class_name), [RBObject class]);
  return Qnil;
}

// def OSX.objc_derived_class_new (class_name, super_name)
// ex1.  OSX.objc_derived_class_new (:CustomView, :NSView)
static VALUE
osx_mf_objc_derived_class_new(VALUE mdl, VALUE class_name, VALUE super_name)
{
  Class super_class;
  Class new_cls = nil;
  id pool = [[NSAutoreleasePool alloc] init];

  class_name = rb_obj_as_string(class_name);
  super_name = rb_obj_as_string(super_name);
  super_class = NSClassFromString([NSString 
				    stringWithCString: STR2CSTR(super_name)]);
  if (super_class)
    new_cls = RBOCDerivedClassNew(STR2CSTR(class_name), super_class);
  [pool release];

  if (new_cls)
    return rb_ocobj_s_new(new_cls);
  return Qnil;
}

// def OSX.objc_derived_class_method_add (class_name, method_name)
// ex1.  OSX.objc_derived_class_method_add (:CustomView, "drawRect:")
static VALUE
osx_mf_objc_derived_class_method_add(VALUE mdl, VALUE class_name, VALUE method_name)
{
  Class a_class;
  SEL a_sel;
  id pool = [[NSAutoreleasePool alloc] init];

  class_name = rb_obj_as_string(class_name);
  method_name = rb_obj_as_string(method_name);
  a_class = 
    NSClassFromString([NSString stringWithCString: STR2CSTR(class_name)]);
  a_sel =
    NSSelectorFromString([NSString stringWithCString: STR2CSTR(method_name)]);
  if (a_class && a_sel) {
    [a_class addRubyMethod: a_sel];
  }
  [pool release];
  return Qnil;
}

static VALUE
osx_mf_ruby_thread_switcher_start(VALUE mdl, VALUE interval)
{
  NSTimeInterval it;
  Check_Type(interval, T_FLOAT);
  RBThreadSchedulerStart(RFLOAT(interval)->value);
}


void Init_osx_objc()
{
  VALUE mOSX;
  extern void init_cocoa(VALUE);

  mOSX = init_module_OSX();
  init_cls_ObjcID(mOSX);
  init_mdl_OCObjWrapper(mOSX);

  rb_define_module_function(mOSX, "objc_proxy_class_new", 
			    osx_mf_objc_proxy_class_new, 1);
  rb_define_module_function(mOSX, "objc_derived_class_new", 
			    osx_mf_objc_derived_class_new, 2);
  rb_define_module_function(mOSX, "objc_derived_class_method_add",
			    osx_mf_objc_derived_class_method_add, 2);

  rb_define_module_function(mOSX, "ruby_thread_switcher_start",
			    osx_mf_ruby_thread_switcher_start, 1);

  init_cocoa(mOSX);
}
