#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** functions ****/
// NSRange NSUnionRange ( NSRange range1 , NSRange range2 );
static VALUE
osx_NSUnionRange(VALUE mdl, VALUE a0, VALUE a1)
{
  NSRange ns_result;

  NSRange ns_a0;
  NSRange ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRANGE, &ns_a0, "NSUnionRange", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRANGE, &ns_a1, "NSUnionRange", pool, 1);

NS_DURING
  ns_result = NSUnionRange(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSUnionRange", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_PRIV_C_NSRANGE, &ns_result, "NSUnionRange", pool);
  [pool release];
  return rb_result;
}

// NSRange NSIntersectionRange ( NSRange range1 , NSRange range2 );
static VALUE
osx_NSIntersectionRange(VALUE mdl, VALUE a0, VALUE a1)
{
  NSRange ns_result;

  NSRange ns_a0;
  NSRange ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRANGE, &ns_a0, "NSIntersectionRange", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRANGE, &ns_a1, "NSIntersectionRange", pool, 1);

NS_DURING
  ns_result = NSIntersectionRange(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSIntersectionRange", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_PRIV_C_NSRANGE, &ns_result, "NSIntersectionRange", pool);
  [pool release];
  return rb_result;
}

// NSString * NSStringFromRange ( NSRange range );
static VALUE
osx_NSStringFromRange(VALUE mdl, VALUE a0)
{
  NSString * ns_result;

  NSRange ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRANGE, &ns_a0, "NSStringFromRange", pool, 0);

NS_DURING
  ns_result = NSStringFromRange(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSStringFromRange", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, "NSStringFromRange", pool);
  [pool release];
  return rb_result;
}

// NSRange NSRangeFromString ( NSString * aString );
static VALUE
osx_NSRangeFromString(VALUE mdl, VALUE a0)
{
  NSRange ns_result;

  NSString * ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, "NSRangeFromString", pool, 0);

NS_DURING
  ns_result = NSRangeFromString(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSRangeFromString", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_PRIV_C_NSRANGE, &ns_result, "NSRangeFromString", pool);
  [pool release];
  return rb_result;
}

void init_NSRange(VALUE mOSX)
{
  /**** functions ****/
  rb_define_module_function(mOSX, "NSUnionRange", osx_NSUnionRange, 2);
  rb_define_module_function(mOSX, "NSIntersectionRange", osx_NSIntersectionRange, 2);
  rb_define_module_function(mOSX, "NSStringFromRange", osx_NSStringFromRange, 1);
  rb_define_module_function(mOSX, "NSRangeFromString", osx_NSRangeFromString, 1);
}
