#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <Foundation/Foundation.h>

  /**** functions ****/
// id <NSObject> NSAllocateObject(Class aClass, unsigned extraBytes, NSZone *zone);
static VALUE
osx_NSAllocateObject(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSDeallocateObject(id <NSObject>object);
static VALUE
osx_NSDeallocateObject(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// id <NSObject> NSCopyObject(id <NSObject>object, unsigned extraBytes, NSZone *zone);
static VALUE
osx_NSCopyObject(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// BOOL NSShouldRetainWithZone(id <NSObject> anObject, NSZone *requestedZone);
static VALUE
osx_NSShouldRetainWithZone(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSIncrementExtraRefCount(id object);
static VALUE
osx_NSIncrementExtraRefCount(int argc, VALUE* argv, VALUE mdl)
{
  id pool = [[NSAutoreleasePool alloc] init];
  
  VALUE rb_result;
    int i;
  id oc_args[1];
  for (i = 0; i < argc; i++) {
    if (!rbobj_to_nsobj(argv[i], &oc_args[i])) {
      [pool release];
      rb_raise(rb_eArgError, "arg #%d cannot convert to nsobj.", i);
    }
  }

   NSIncrementExtraRefCount(oc_args[0]);
  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// BOOL NSDecrementExtraRefCountWasZero(id object);
static VALUE
osx_NSDecrementExtraRefCountWasZero(int argc, VALUE* argv, VALUE mdl)
{
  id pool = [[NSAutoreleasePool alloc] init];
  BOOL ns_result;
  VALUE rb_result;
    int i;
  id oc_args[1];
  for (i = 0; i < argc; i++) {
    if (!rbobj_to_nsobj(argv[i], &oc_args[i])) {
      [pool release];
      rb_raise(rb_eArgError, "arg #%d cannot convert to nsobj.", i);
    }
  }

  ns_result =  NSDecrementExtraRefCountWasZero(oc_args[0]);
  rb_result = bool_to_rbobj(ns_result);
  [pool release];
  return rb_result;
}

// unsigned NSExtraRefCount(id object);
static VALUE
osx_NSExtraRefCount(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

void init_NSObject(VALUE mOSX)
{
  /**** functions ****/
  rb_define_module_function(mOSX, "NSAllocateObject", osx_NSAllocateObject, -1);
  rb_define_module_function(mOSX, "NSDeallocateObject", osx_NSDeallocateObject, -1);
  rb_define_module_function(mOSX, "NSCopyObject", osx_NSCopyObject, -1);
  rb_define_module_function(mOSX, "NSShouldRetainWithZone", osx_NSShouldRetainWithZone, -1);
  rb_define_module_function(mOSX, "NSIncrementExtraRefCount", osx_NSIncrementExtraRefCount, -1);
  rb_define_module_function(mOSX, "NSDecrementExtraRefCountWasZero", osx_NSDecrementExtraRefCountWasZero, -1);
  rb_define_module_function(mOSX, "NSExtraRefCount", osx_NSExtraRefCount, -1);
}
