#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


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
osx_NSJavaNeedsVirtualMachine(VALUE mdl, VALUE a0)
{
  BOOL ns_result;

  NSDictionary * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);

  ns_result = NSJavaNeedsVirtualMachine(ns_a0);

  rb_result = nsresult_to_rbresult(_PRIV_C_BOOL, &ns_result, pool);
  [pool release];
  return rb_result;
}

// BOOL NSJavaProvidesClasses(NSDictionary *plist);
static VALUE
osx_NSJavaProvidesClasses(VALUE mdl, VALUE a0)
{
  BOOL ns_result;

  NSDictionary * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);

  ns_result = NSJavaProvidesClasses(ns_a0);

  rb_result = nsresult_to_rbresult(_PRIV_C_BOOL, &ns_result, pool);
  [pool release];
  return rb_result;
}

// BOOL NSJavaNeedsToLoadClasses(NSDictionary *plist);
static VALUE
osx_NSJavaNeedsToLoadClasses(VALUE mdl, VALUE a0)
{
  BOOL ns_result;

  NSDictionary * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);

  ns_result = NSJavaNeedsToLoadClasses(ns_a0);

  rb_result = nsresult_to_rbresult(_PRIV_C_BOOL, &ns_result, pool);
  [pool release];
  return rb_result;
}

// id NSJavaSetup(NSDictionary *plist);
static VALUE
osx_NSJavaSetup(VALUE mdl, VALUE a0)
{
  id ns_result;

  NSDictionary * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);

  ns_result = NSJavaSetup(ns_a0);

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, pool);
  [pool release];
  return rb_result;
}

// id NSJavaSetupVirtualMachine(void);
static VALUE
osx_NSJavaSetupVirtualMachine(VALUE mdl)
{
  id ns_result = NSJavaSetupVirtualMachine();
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// id NSJavaObjectNamedInPath(NSString *name, NSArray *path);
static VALUE
osx_NSJavaObjectNamedInPath(VALUE mdl, VALUE a0, VALUE a1)
{
  id ns_result;

  NSString * ns_a0;
  NSArray * ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_ID, &ns_a1, pool, 1);

  ns_result = NSJavaObjectNamedInPath(ns_a0, ns_a1);

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, pool);
  [pool release];
  return rb_result;
}

// NSArray *NSJavaClassesFromPath(NSArray *path, NSArray *wanted, BOOL usesyscl, id *vm);
static VALUE
osx_NSJavaClassesFromPath(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3)
{
  NSArray * ns_result;

  NSArray * ns_a0;
  NSArray * ns_a1;
  BOOL ns_a2;
  id * ns_a3;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_ID, &ns_a1, pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_UCHR, &ns_a2, pool, 2);
  /* a3 */
  rbarg_to_nsarg(a3, _C_PTR, &ns_a3, pool, 3);

  ns_result = NSJavaClassesFromPath(ns_a0, ns_a1, ns_a2, ns_a3);

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, pool);
  [pool release];
  return rb_result;
}

// NSArray *NSJavaClassesForBundle(NSBundle *bundle, BOOL usesyscl, id *vm);
static VALUE
osx_NSJavaClassesForBundle(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{
  NSArray * ns_result;

  NSBundle * ns_a0;
  BOOL ns_a1;
  id * ns_a2;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_UCHR, &ns_a1, pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_PTR, &ns_a2, pool, 2);

  ns_result = NSJavaClassesForBundle(ns_a0, ns_a1, ns_a2);

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, pool);
  [pool release];
  return rb_result;
}

// id NSJavaBundleSetup(NSBundle *bundle, NSDictionary *plist);
static VALUE
osx_NSJavaBundleSetup(VALUE mdl, VALUE a0, VALUE a1)
{
  id ns_result;

  NSBundle * ns_a0;
  NSDictionary * ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_ID, &ns_a1, pool, 1);

  ns_result = NSJavaBundleSetup(ns_a0, ns_a1);

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, pool);
  [pool release];
  return rb_result;
}

// void NSJavaBundleCleanup(NSBundle *bundle, NSDictionary *plist);
static VALUE
osx_NSJavaBundleCleanup(VALUE mdl, VALUE a0, VALUE a1)
{

  NSBundle * ns_a0;
  NSDictionary * ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_ID, &ns_a1, pool, 1);

  NSJavaBundleCleanup(ns_a0, ns_a1);

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
  rb_define_module_function(mOSX, "NSJavaNeedsVirtualMachine", osx_NSJavaNeedsVirtualMachine, 1);
  rb_define_module_function(mOSX, "NSJavaProvidesClasses", osx_NSJavaProvidesClasses, 1);
  rb_define_module_function(mOSX, "NSJavaNeedsToLoadClasses", osx_NSJavaNeedsToLoadClasses, 1);
  rb_define_module_function(mOSX, "NSJavaSetup", osx_NSJavaSetup, 1);
  rb_define_module_function(mOSX, "NSJavaSetupVirtualMachine", osx_NSJavaSetupVirtualMachine, 0);
  rb_define_module_function(mOSX, "NSJavaObjectNamedInPath", osx_NSJavaObjectNamedInPath, 2);
  rb_define_module_function(mOSX, "NSJavaClassesFromPath", osx_NSJavaClassesFromPath, 4);
  rb_define_module_function(mOSX, "NSJavaClassesForBundle", osx_NSJavaClassesForBundle, 3);
  rb_define_module_function(mOSX, "NSJavaBundleSetup", osx_NSJavaBundleSetup, 2);
  rb_define_module_function(mOSX, "NSJavaBundleCleanup", osx_NSJavaBundleCleanup, 2);
}
