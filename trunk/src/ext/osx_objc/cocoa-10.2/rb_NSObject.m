#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** functions ****/
// id < NSObject > NSAllocateObject ( Class aClass , unsigned extraBytes , NSZone * zone );
static VALUE
osx_NSAllocateObject(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{
  rb_notimplement();
}

// void NSDeallocateObject ( id < NSObject > object );
static VALUE
osx_NSDeallocateObject(VALUE mdl, VALUE a0)
{
  rb_notimplement();
}

// id < NSObject > NSCopyObject ( id < NSObject > object , unsigned extraBytes , NSZone * zone );
static VALUE
osx_NSCopyObject(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{
  rb_notimplement();
}

// BOOL NSShouldRetainWithZone ( id < NSObject > anObject , NSZone * requestedZone );
static VALUE
osx_NSShouldRetainWithZone(VALUE mdl, VALUE a0, VALUE a1)
{
  rb_notimplement();
}

// void NSIncrementExtraRefCount ( id object );
static VALUE
osx_NSIncrementExtraRefCount(VALUE mdl, VALUE a0)
{

  id ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);

  NSIncrementExtraRefCount(ns_a0);

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

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);

  ns_result = NSDecrementExtraRefCountWasZero(ns_a0);

  rb_result = nsresult_to_rbresult(_PRIV_C_BOOL, &ns_result, pool);
  [pool release];
  return rb_result;
}

// unsigned NSExtraRefCount ( id object );
static VALUE
osx_NSExtraRefCount(VALUE mdl, VALUE a0)
{
  unsigned ns_result;

  id ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);

  ns_result = NSExtraRefCount(ns_a0);

  rb_result = nsresult_to_rbresult(_C_UINT, &ns_result, pool);
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
