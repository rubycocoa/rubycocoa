#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

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


  /**** constants ****/
// double NSFoundationVersionNumber;
static VALUE
osx_NSFoundationVersionNumber(VALUE mdl)
{
  double ns_result = NSFoundationVersionNumber;
  return nsresult_to_rbresult(_C_DBL, &ns_result, nil);
}

  /**** functions ****/
// NSString *NSStringFromSelector(SEL aSelector);
static VALUE
osx_NSStringFromSelector(VALUE mdl, VALUE a0)
{
  NSString * ns_result;

  SEL ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_SEL, &ns_a0, pool, 0);

  ns_result = NSStringFromSelector(ns_a0);

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, pool);
  [pool release];
  return rb_result;
}

// SEL NSSelectorFromString(NSString *aSelectorName);
static VALUE
osx_NSSelectorFromString(VALUE mdl, VALUE a0)
{
  SEL ns_result;

  NSString * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);

  ns_result = NSSelectorFromString(ns_a0);

  rb_result = nsresult_to_rbresult(_C_SEL, &ns_result, pool);
  [pool release];
  return rb_result;
}

// Class NSClassFromString(NSString *aClassName);
static VALUE
osx_NSClassFromString(VALUE mdl, VALUE a0)
{
  Class ns_result;

  NSString * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);

  ns_result = NSClassFromString(ns_a0);

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, pool);
  [pool release];
  return rb_result;
}

// NSString *NSStringFromClass(Class aClass);
static VALUE
osx_NSStringFromClass(VALUE mdl, VALUE a0)
{
  NSString * ns_result;

  Class ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);

  ns_result = NSStringFromClass(ns_a0);

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, pool);
  [pool release];
  return rb_result;
}

// const char *NSGetSizeAndAlignment(const char *typePtr, unsigned int *sizep, unsigned int *alignp);
static VALUE
osx_NSGetSizeAndAlignment(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{
  const char * ns_result;

  const char * ns_a0;
  unsigned int * ns_a1;
  unsigned int * ns_a2;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_CHARPTR, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_PTR, &ns_a1, pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_PTR, &ns_a2, pool, 2);

  ns_result = NSGetSizeAndAlignment(ns_a0, ns_a1, ns_a2);

  rb_result = nsresult_to_rbresult(_C_CHARPTR, &ns_result, pool);
  [pool release];
  return rb_result;
}

// void NSLog(NSString *format, ...);
static VALUE
osx_NSLog(VALUE mdl, VALUE a0, VALUE a1)
{
  rb_notimplement();
}

// void NSLogv(NSString *format, va_list args);
static VALUE
osx_NSLogv(VALUE mdl, VALUE a0, VALUE a1)
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
  rb_define_module_function(mOSX, "NSStringFromSelector", osx_NSStringFromSelector, 1);
  rb_define_module_function(mOSX, "NSSelectorFromString", osx_NSSelectorFromString, 1);
  rb_define_module_function(mOSX, "NSClassFromString", osx_NSClassFromString, 1);
  rb_define_module_function(mOSX, "NSStringFromClass", osx_NSStringFromClass, 1);
  rb_define_module_function(mOSX, "NSGetSizeAndAlignment", osx_NSGetSizeAndAlignment, 3);
  rb_define_module_function(mOSX, "NSLog", osx_NSLog, 2);
  rb_define_module_function(mOSX, "NSLogv", osx_NSLogv, 2);
}
