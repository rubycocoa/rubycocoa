#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <Foundation/Foundation.h>

  /**** constants ****/
// NSString * const NSJavaClasses;
static VALUE
osx_NSJavaClasses(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSJavaRoot;
static VALUE
osx_NSJavaRoot(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSJavaPath;
static VALUE
osx_NSJavaPath(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSJavaUserPath;
static VALUE
osx_NSJavaUserPath(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSJavaLibraryPath;
static VALUE
osx_NSJavaLibraryPath(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSJavaOwnVirtualMachine;
static VALUE
osx_NSJavaOwnVirtualMachine(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSJavaPathSeparator;
static VALUE
osx_NSJavaPathSeparator(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSJavaWillSetupVirtualMachineNotification;
static VALUE
osx_NSJavaWillSetupVirtualMachineNotification(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSJavaDidSetupVirtualMachineNotification;
static VALUE
osx_NSJavaDidSetupVirtualMachineNotification(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSJavaWillCreateVirtualMachineNotification;
static VALUE
osx_NSJavaWillCreateVirtualMachineNotification(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSJavaDidCreateVirtualMachineNotification;
static VALUE
osx_NSJavaDidCreateVirtualMachineNotification(VALUE mdl)
{
  rb_notimplement();
}

  /**** functions ****/
// BOOL NSJavaNeedsVirtualMachine(NSDictionary *plist);
static VALUE
osx_NSJavaNeedsVirtualMachine(int argc, VALUE* argv, VALUE mdl)
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

  ns_result =  NSJavaNeedsVirtualMachine(oc_args[0]);
  rb_result = bool_to_rbobj(ns_result);
  [pool release];
  return rb_result;
}

// BOOL NSJavaProvidesClasses(NSDictionary *plist);
static VALUE
osx_NSJavaProvidesClasses(int argc, VALUE* argv, VALUE mdl)
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

  ns_result =  NSJavaProvidesClasses(oc_args[0]);
  rb_result = bool_to_rbobj(ns_result);
  [pool release];
  return rb_result;
}

// BOOL NSJavaNeedsToLoadClasses(NSDictionary *plist);
static VALUE
osx_NSJavaNeedsToLoadClasses(int argc, VALUE* argv, VALUE mdl)
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

  ns_result =  NSJavaNeedsToLoadClasses(oc_args[0]);
  rb_result = bool_to_rbobj(ns_result);
  [pool release];
  return rb_result;
}

// id NSJavaSetup(NSDictionary *plist);
static VALUE
osx_NSJavaSetup(int argc, VALUE* argv, VALUE mdl)
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

  ns_result =  NSJavaSetup(oc_args[0]);
  rb_result = ocobj_new_with_ocid(ns_result);
  [pool release];
  return rb_result;
}

// id NSJavaSetupVirtualMachine(void);
static VALUE
osx_NSJavaSetupVirtualMachine(VALUE mdl)
{
  id pool = [[NSAutoreleasePool alloc] init];
  id ns_result;
  VALUE rb_result;
  
  ns_result =  NSJavaSetupVirtualMachine();
  rb_result = ocobj_new_with_ocid(ns_result);
  [pool release];
  return rb_result;
}

// id NSJavaObjectNamedInPath(NSString *name, NSArray *path);
static VALUE
osx_NSJavaObjectNamedInPath(int argc, VALUE* argv, VALUE mdl)
{
  id pool = [[NSAutoreleasePool alloc] init];
  id ns_result;
  VALUE rb_result;
    int i;
  id oc_args[2];
  for (i = 0; i < argc; i++) {
    if (!rbobj_to_nsobj(argv[i], &oc_args[i])) {
      [pool release];
      rb_raise(rb_eArgError, "arg #%d cannot convert to nsobj.", i);
    }
  }

  ns_result =  NSJavaObjectNamedInPath(oc_args[0], oc_args[1]);
  rb_result = ocobj_new_with_ocid(ns_result);
  [pool release];
  return rb_result;
}

// NSArray *NSJavaClassesFromPath(NSArray *path, NSArray *wanted, BOOL usesyscl, id *vm);
static VALUE
osx_NSJavaClassesFromPath(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSArray *NSJavaClassesForBundle(NSBundle *bundle, BOOL usesyscl, id *vm);
static VALUE
osx_NSJavaClassesForBundle(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// id NSJavaBundleSetup(NSBundle *bundle, NSDictionary *plist);
static VALUE
osx_NSJavaBundleSetup(int argc, VALUE* argv, VALUE mdl)
{
  id pool = [[NSAutoreleasePool alloc] init];
  id ns_result;
  VALUE rb_result;
    int i;
  id oc_args[2];
  for (i = 0; i < argc; i++) {
    if (!rbobj_to_nsobj(argv[i], &oc_args[i])) {
      [pool release];
      rb_raise(rb_eArgError, "arg #%d cannot convert to nsobj.", i);
    }
  }

  ns_result =  NSJavaBundleSetup(oc_args[0], oc_args[1]);
  rb_result = ocobj_new_with_ocid(ns_result);
  [pool release];
  return rb_result;
}

// void NSJavaBundleCleanup(NSBundle *bundle, NSDictionary *plist);
static VALUE
osx_NSJavaBundleCleanup(int argc, VALUE* argv, VALUE mdl)
{
  id pool = [[NSAutoreleasePool alloc] init];
  
  VALUE rb_result;
    int i;
  id oc_args[2];
  for (i = 0; i < argc; i++) {
    if (!rbobj_to_nsobj(argv[i], &oc_args[i])) {
      [pool release];
      rb_raise(rb_eArgError, "arg #%d cannot convert to nsobj.", i);
    }
  }

   NSJavaBundleCleanup(oc_args[0], oc_args[1]);
  rb_result = Qnil;
  [pool release];
  return rb_result;
}

void init_NSJavaSetup(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSJavaClasses", osx_NSJavaClasses, 0);
  rb_define_module_function(mOSX, "NSJavaRoot", osx_NSJavaRoot, 0);
  rb_define_module_function(mOSX, "NSJavaPath", osx_NSJavaPath, 0);
  rb_define_module_function(mOSX, "NSJavaUserPath", osx_NSJavaUserPath, 0);
  rb_define_module_function(mOSX, "NSJavaLibraryPath", osx_NSJavaLibraryPath, 0);
  rb_define_module_function(mOSX, "NSJavaOwnVirtualMachine", osx_NSJavaOwnVirtualMachine, 0);
  rb_define_module_function(mOSX, "NSJavaPathSeparator", osx_NSJavaPathSeparator, 0);
  rb_define_module_function(mOSX, "NSJavaWillSetupVirtualMachineNotification", osx_NSJavaWillSetupVirtualMachineNotification, 0);
  rb_define_module_function(mOSX, "NSJavaDidSetupVirtualMachineNotification", osx_NSJavaDidSetupVirtualMachineNotification, 0);
  rb_define_module_function(mOSX, "NSJavaWillCreateVirtualMachineNotification", osx_NSJavaWillCreateVirtualMachineNotification, 0);
  rb_define_module_function(mOSX, "NSJavaDidCreateVirtualMachineNotification", osx_NSJavaDidCreateVirtualMachineNotification, 0);
  /**** functions ****/
  rb_define_module_function(mOSX, "NSJavaNeedsVirtualMachine", osx_NSJavaNeedsVirtualMachine, -1);
  rb_define_module_function(mOSX, "NSJavaProvidesClasses", osx_NSJavaProvidesClasses, -1);
  rb_define_module_function(mOSX, "NSJavaNeedsToLoadClasses", osx_NSJavaNeedsToLoadClasses, -1);
  rb_define_module_function(mOSX, "NSJavaSetup", osx_NSJavaSetup, -1);
  rb_define_module_function(mOSX, "NSJavaSetupVirtualMachine", osx_NSJavaSetupVirtualMachine, 0);
  rb_define_module_function(mOSX, "NSJavaObjectNamedInPath", osx_NSJavaObjectNamedInPath, -1);
  rb_define_module_function(mOSX, "NSJavaClassesFromPath", osx_NSJavaClassesFromPath, -1);
  rb_define_module_function(mOSX, "NSJavaClassesForBundle", osx_NSJavaClassesForBundle, -1);
  rb_define_module_function(mOSX, "NSJavaBundleSetup", osx_NSJavaBundleSetup, -1);
  rb_define_module_function(mOSX, "NSJavaBundleCleanup", osx_NSJavaBundleCleanup, -1);
}
