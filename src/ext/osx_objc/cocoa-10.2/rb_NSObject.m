#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** functions ****/
// id < NSObject > NSAllocateObject ( Class aClass , unsigned extraBytes , NSZone * zone );
static VALUE
osx_NSAllocateObject(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{
  id < NSObject > ns_result;

  Class ns_a0;
  unsigned ns_a1;
  NSZone * ns_a2;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, "NSAllocateObject", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_UINT, &ns_a1, "NSAllocateObject", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _PRIV_C_PTR, &ns_a2, "NSAllocateObject", pool, 2);

NS_DURING
  ns_result = NSAllocateObject(ns_a0, ns_a1, ns_a2);
NS_HANDLER
  excp = oc_err_new ("NSAllocateObject", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, "NSAllocateObject", pool);
  [pool release];
  return rb_result;
}

// void NSDeallocateObject ( id < NSObject > object );
static VALUE
osx_NSDeallocateObject(VALUE mdl, VALUE a0)
{

  id < NSObject > ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, "NSDeallocateObject", pool, 0);

NS_DURING
  NSDeallocateObject(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSDeallocateObject", localException);
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

// id < NSObject > NSCopyObject ( id < NSObject > object , unsigned extraBytes , NSZone * zone );
static VALUE
osx_NSCopyObject(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{
  id < NSObject > ns_result;

  id < NSObject > ns_a0;
  unsigned ns_a1;
  NSZone * ns_a2;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, "NSCopyObject", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_UINT, &ns_a1, "NSCopyObject", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _PRIV_C_PTR, &ns_a2, "NSCopyObject", pool, 2);

NS_DURING
  ns_result = NSCopyObject(ns_a0, ns_a1, ns_a2);
NS_HANDLER
  excp = oc_err_new ("NSCopyObject", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, "NSCopyObject", pool);
  [pool release];
  return rb_result;
}

// BOOL NSShouldRetainWithZone ( id < NSObject > anObject , NSZone * requestedZone );
static VALUE
osx_NSShouldRetainWithZone(VALUE mdl, VALUE a0, VALUE a1)
{
  BOOL ns_result;

  id < NSObject > ns_a0;
  NSZone * ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, "NSShouldRetainWithZone", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSShouldRetainWithZone", pool, 1);

NS_DURING
  ns_result = NSShouldRetainWithZone(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSShouldRetainWithZone", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_PRIV_C_BOOL, &ns_result, "NSShouldRetainWithZone", pool);
  [pool release];
  return rb_result;
}

// void NSIncrementExtraRefCount ( id object );
static VALUE
osx_NSIncrementExtraRefCount(VALUE mdl, VALUE a0)
{

  id ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, "NSIncrementExtraRefCount", pool, 0);

NS_DURING
  NSIncrementExtraRefCount(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSIncrementExtraRefCount", localException);
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

// BOOL NSDecrementExtraRefCountWasZero ( id object );
static VALUE
osx_NSDecrementExtraRefCountWasZero(VALUE mdl, VALUE a0)
{
  BOOL ns_result;

  id ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, "NSDecrementExtraRefCountWasZero", pool, 0);

NS_DURING
  ns_result = NSDecrementExtraRefCountWasZero(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSDecrementExtraRefCountWasZero", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_PRIV_C_BOOL, &ns_result, "NSDecrementExtraRefCountWasZero", pool);
  [pool release];
  return rb_result;
}

// unsigned NSExtraRefCount ( id object );
static VALUE
osx_NSExtraRefCount(VALUE mdl, VALUE a0)
{
  unsigned ns_result;

  id ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, "NSExtraRefCount", pool, 0);

NS_DURING
  ns_result = NSExtraRefCount(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSExtraRefCount", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_UINT, &ns_result, "NSExtraRefCount", pool);
  [pool release];
  return rb_result;
}

void init_NSObject(VALUE mOSX)
{
  /**** functions ****/
  rb_define_module_function(mOSX, "NSAllocateObject", osx_NSAllocateObject, 3);
  rb_define_module_function(mOSX, "NSDeallocateObject", osx_NSDeallocateObject, 1);
  rb_define_module_function(mOSX, "NSCopyObject", osx_NSCopyObject, 3);
  rb_define_module_function(mOSX, "NSShouldRetainWithZone", osx_NSShouldRetainWithZone, 2);
  rb_define_module_function(mOSX, "NSIncrementExtraRefCount", osx_NSIncrementExtraRefCount, 1);
  rb_define_module_function(mOSX, "NSDecrementExtraRefCountWasZero", osx_NSDecrementExtraRefCountWasZero, 1);
  rb_define_module_function(mOSX, "NSExtraRefCount", osx_NSExtraRefCount, 1);
}
