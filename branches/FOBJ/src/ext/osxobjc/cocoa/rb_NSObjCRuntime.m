#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <Foundation/Foundation.h>

  /**** constants ****/
// double NSFoundationVersionNumber;
static VALUE
osx_NSFoundationVersionNumber(VALUE mdl)
{
  rb_notimplement();
}

  /**** functions ****/
// NSString *NSStringFromSelector(SEL aSelector);
static VALUE
osx_NSStringFromSelector(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// SEL NSSelectorFromString(NSString *aSelectorName);
static VALUE
osx_NSSelectorFromString(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// Class NSClassFromString(NSString *aClassName);
static VALUE
osx_NSClassFromString(int argc, VALUE* argv, VALUE mdl)
{
  id pool = [[NSAutoreleasePool alloc] init];
  id ns_result;
  VALUE rb_result;
    int i;
  id oc_args[1];
  for (i = 0; i < argc; i++) {
    if (!rbobj_to_nsobj(argv[i], &oc_args[i])) {
      [pool release];
      rb_raise(rb_eArgError, "arg #%d cannot convert to nsobj.", i);
    }
  }

  ns_result =  NSClassFromString(oc_args[0]);
  rb_result = ocobj_new_with_ocid(ns_result);
  [pool release];
  return rb_result;
}

// NSString *NSStringFromClass(Class aClass);
static VALUE
osx_NSStringFromClass(int argc, VALUE* argv, VALUE mdl)
{
  id pool = [[NSAutoreleasePool alloc] init];
  id ns_result;
  VALUE rb_result;
    int i;
  id oc_args[1];
  for (i = 0; i < argc; i++) {
    if (!rbobj_to_nsobj(argv[i], &oc_args[i])) {
      [pool release];
      rb_raise(rb_eArgError, "arg #%d cannot convert to nsobj.", i);
    }
  }

  ns_result =  NSStringFromClass(oc_args[0]);
  rb_result = ocobj_new_with_ocid(ns_result);
  [pool release];
  return rb_result;
}

// const char *NSGetSizeAndAlignment(const char *typePtr, unsigned int *sizep, unsigned int *alignp);
static VALUE
osx_NSGetSizeAndAlignment(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSLog(NSString *format, ...);
static VALUE
osx_NSLog(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSLogv(NSString *format, va_list args);
static VALUE
osx_NSLogv(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

void init_NSObjCRuntime(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSOrderedAscending", INT2NUM(NSOrderedAscending));
  rb_define_const(mOSX, "NSOrderedSame", INT2NUM(NSOrderedSame));
  rb_define_const(mOSX, "NSOrderedDescending", INT2NUM(NSOrderedDescending));
  rb_define_const(mOSX, "NSNotFound", INT2NUM(NSNotFound));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSFoundationVersionNumber", osx_NSFoundationVersionNumber, 0);
  /**** functions ****/
  rb_define_module_function(mOSX, "NSStringFromSelector", osx_NSStringFromSelector, -1);
  rb_define_module_function(mOSX, "NSSelectorFromString", osx_NSSelectorFromString, -1);
  rb_define_module_function(mOSX, "NSClassFromString", osx_NSClassFromString, -1);
  rb_define_module_function(mOSX, "NSStringFromClass", osx_NSStringFromClass, -1);
  rb_define_module_function(mOSX, "NSGetSizeAndAlignment", osx_NSGetSizeAndAlignment, -1);
  rb_define_module_function(mOSX, "NSLog", osx_NSLog, -1);
  rb_define_module_function(mOSX, "NSLogv", osx_NSLogv, -1);
}
