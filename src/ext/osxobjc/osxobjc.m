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
#import "osx_ocobject.h"
#import <Foundation/Foundation.h>
#import <RubyCocoa/RBRuntime.h>	// RubyCocoa.framework
#import <RubyCocoa/RBProxy.h>	// RubyCocoa.framework

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

// def OSX.create_objc_stub (stubname, supername = nil)
// ex0.  OSX.create_objc_stub (:AppController)
// ex1.  OSX.create_objc_stub (:CustomView, :NSView)
static VALUE osx_mf_create_objc_stub(int argc, VALUE* argv, VALUE mdl)
{
  Class super_class;
  VALUE stub_name;
  if (argc == 1) {
    super_class = [RBProxy class];
  }
  else if (argc == 2) {
    id pool = [[NSAutoreleasePool alloc] init];
    VALUE super_name = rb_obj_as_string(argv[1]);
    super_class = 
      NSClassFromString([NSString stringWithCString: STR2CSTR(super_name)]);
    [pool release];
  }
  else {
    rb_raise(rb_eArgError, "wrong # of arguments");
  }
  stub_name = rb_obj_as_string(argv[0]);
  RBOCClassNew(STR2CSTR(stub_name), super_class);
  return Qnil;
}


void Init_osxobjc()
{
  VALUE mOSX, cOCObject;
  extern void init_cocoa(VALUE);

  mOSX = init_module_OSX();
  init_class_OCObject(mOSX);
  rb_define_module_function(mOSX, "create_objc_stub", osx_mf_create_objc_stub, -1);
  init_cocoa(mOSX);
}
