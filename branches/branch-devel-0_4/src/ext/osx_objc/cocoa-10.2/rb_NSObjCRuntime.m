#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// double NSFoundationVersionNumber;
static VALUE
osx_NSFoundationVersionNumber(VALUE mdl)
{
  return nsresult_to_rbresult(_C_DBL, &NSFoundationVersionNumber, "NSFoundationVersionNumber", nil);
}

  /**** functions ****/
// NSString * NSStringFromSelector ( SEL aSelector );
static VALUE
osx_NSStringFromSelector(VALUE mdl, VALUE a0)
{
  NSString * ns_result;

  SEL ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_SEL, &ns_a0, "NSStringFromSelector", pool, 0);

NS_DURING
  ns_result = NSStringFromSelector(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSStringFromSelector", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, "NSStringFromSelector", pool);
  [pool release];
  return rb_result;
}

// SEL NSSelectorFromString ( NSString * aSelectorName );
static VALUE
osx_NSSelectorFromString(VALUE mdl, VALUE a0)
{
  SEL ns_result;

  NSString * ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, "NSSelectorFromString", pool, 0);

NS_DURING
  ns_result = NSSelectorFromString(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSSelectorFromString", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_SEL, &ns_result, "NSSelectorFromString", pool);
  [pool release];
  return rb_result;
}

// Class NSClassFromString ( NSString * aClassName );
static VALUE
osx_NSClassFromString(VALUE mdl, VALUE a0)
{
  Class ns_result;

  NSString * ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, "NSClassFromString", pool, 0);

NS_DURING
  ns_result = NSClassFromString(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSClassFromString", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, "NSClassFromString", pool);
  [pool release];
  return rb_result;
}

// NSString * NSStringFromClass ( Class aClass );
static VALUE
osx_NSStringFromClass(VALUE mdl, VALUE a0)
{
  NSString * ns_result;

  Class ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, "NSStringFromClass", pool, 0);

NS_DURING
  ns_result = NSStringFromClass(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSStringFromClass", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, "NSStringFromClass", pool);
  [pool release];
  return rb_result;
}

// const char * NSGetSizeAndAlignment ( const char * typePtr , unsigned int * sizep , unsigned int * alignp );
static VALUE
osx_NSGetSizeAndAlignment(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{
  const char * ns_result;

  const char * ns_a0;
  unsigned int * ns_a1;
  unsigned int * ns_a2;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_CHARPTR, &ns_a0, "NSGetSizeAndAlignment", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSGetSizeAndAlignment", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _PRIV_C_PTR, &ns_a2, "NSGetSizeAndAlignment", pool, 2);

NS_DURING
  ns_result = NSGetSizeAndAlignment(ns_a0, ns_a1, ns_a2);
NS_HANDLER
  excp = oc_err_new ("NSGetSizeAndAlignment", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_CHARPTR, &ns_result, "NSGetSizeAndAlignment", pool);
  [pool release];
  return rb_result;
}

// void NSLog ( NSString * format , ... );
static VALUE
osx_NSLog(int argc, VALUE* argv, VALUE mdl)
{

  NSString * ns_a0;
  int va_first = 1;
  int va_last;
  id ns_va[VA_MAX];
  int i;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* argv[0] */
  rbarg_to_nsarg(argv[0], _C_ID, &ns_a0, "NSLog", pool, 0);
  /* ns_va */
  va_last = va_first + VA_MAX;
  for (i = va_first; (i < argc) && (i < va_last); i++)
    rbarg_to_nsarg(argv[i], _C_ID, &ns_va[i - va_first], "NSLog", pool, i);

NS_DURING
  if (argc == va_first)
    NSLog(ns_a0);
  else if (argc == (va_first + 1))
    NSLog(ns_a0,
      ns_va[0]);
  else if (argc == (va_first + 2))
    NSLog(ns_a0,
      ns_va[0], ns_va[1]);
  else if (argc == (va_first + 3))
    NSLog(ns_a0,
      ns_va[0], ns_va[1], ns_va[2]);
  else if (argc == (va_first + 4))
    NSLog(ns_a0,
      ns_va[0], ns_va[1], ns_va[2], ns_va[3]);

NS_HANDLER
  excp = oc_err_new ("NSLog", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSLogv ( NSString * format , va_list args );
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
  rb_define_module_function(mOSX, "NSLog", osx_NSLog, -1);
  rb_define_module_function(mOSX, "NSLogv", osx_NSLogv, 2);
}
