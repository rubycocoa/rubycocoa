#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

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
// double NSAppKitVersionNumber;
static VALUE
osx_NSAppKitVersionNumber(VALUE mdl)
{
  double ns_result = NSAppKitVersionNumber;
  return nsresult_to_rbresult(_C_DBL, &ns_result, nil);
}

// NSString *NSModalPanelRunLoopMode;
static VALUE
osx_NSModalPanelRunLoopMode(VALUE mdl)
{
  NSString * ns_result = NSModalPanelRunLoopMode;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSEventTrackingRunLoopMode;
static VALUE
osx_NSEventTrackingRunLoopMode(VALUE mdl)
{
  NSString * ns_result = NSEventTrackingRunLoopMode;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// id NSApp;
static VALUE
osx_NSApp(VALUE mdl)
{
  id ns_result = NSApp;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSApplicationDidBecomeActiveNotification;
static VALUE
osx_NSApplicationDidBecomeActiveNotification(VALUE mdl)
{
  NSString * ns_result = NSApplicationDidBecomeActiveNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSApplicationDidHideNotification;
static VALUE
osx_NSApplicationDidHideNotification(VALUE mdl)
{
  NSString * ns_result = NSApplicationDidHideNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSApplicationDidFinishLaunchingNotification;
static VALUE
osx_NSApplicationDidFinishLaunchingNotification(VALUE mdl)
{
  NSString * ns_result = NSApplicationDidFinishLaunchingNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSApplicationDidResignActiveNotification;
static VALUE
osx_NSApplicationDidResignActiveNotification(VALUE mdl)
{
  NSString * ns_result = NSApplicationDidResignActiveNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSApplicationDidUnhideNotification;
static VALUE
osx_NSApplicationDidUnhideNotification(VALUE mdl)
{
  NSString * ns_result = NSApplicationDidUnhideNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSApplicationDidUpdateNotification;
static VALUE
osx_NSApplicationDidUpdateNotification(VALUE mdl)
{
  NSString * ns_result = NSApplicationDidUpdateNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSApplicationWillBecomeActiveNotification;
static VALUE
osx_NSApplicationWillBecomeActiveNotification(VALUE mdl)
{
  NSString * ns_result = NSApplicationWillBecomeActiveNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSApplicationWillHideNotification;
static VALUE
osx_NSApplicationWillHideNotification(VALUE mdl)
{
  NSString * ns_result = NSApplicationWillHideNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSApplicationWillFinishLaunchingNotification;
static VALUE
osx_NSApplicationWillFinishLaunchingNotification(VALUE mdl)
{
  NSString * ns_result = NSApplicationWillFinishLaunchingNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSApplicationWillResignActiveNotification;
static VALUE
osx_NSApplicationWillResignActiveNotification(VALUE mdl)
{
  NSString * ns_result = NSApplicationWillResignActiveNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSApplicationWillUnhideNotification;
static VALUE
osx_NSApplicationWillUnhideNotification(VALUE mdl)
{
  NSString * ns_result = NSApplicationWillUnhideNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSApplicationWillUpdateNotification;
static VALUE
osx_NSApplicationWillUpdateNotification(VALUE mdl)
{
  NSString * ns_result = NSApplicationWillUpdateNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSApplicationWillTerminateNotification;
static VALUE
osx_NSApplicationWillTerminateNotification(VALUE mdl)
{
  NSString * ns_result = NSApplicationWillTerminateNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSApplicationDidChangeScreenParametersNotification;
static VALUE
osx_NSApplicationDidChangeScreenParametersNotification(VALUE mdl)
{
  NSString * ns_result = NSApplicationDidChangeScreenParametersNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

  /**** functions ****/
// int NSApplicationMain(int argc, const char *argv[]);
static VALUE
osx_NSApplicationMain(VALUE mdl, VALUE a0, VALUE a1)
{
  rb_notimplement();
}

// BOOL NSShowsServicesMenuItem(NSString * itemName);
static VALUE
osx_NSShowsServicesMenuItem(VALUE mdl, VALUE a0)
{
  BOOL ns_result;

  NSString * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);

  ns_result = NSShowsServicesMenuItem(ns_a0);

  rb_result = nsresult_to_rbresult(_PRIV_C_BOOL, &ns_result, pool);
  [pool release];
  return rb_result;
}

// int NSSetShowsServicesMenuItem(NSString * itemName, BOOL enabled);
static VALUE
osx_NSSetShowsServicesMenuItem(VALUE mdl, VALUE a0, VALUE a1)
{
  int ns_result;

  NSString * ns_a0;
  BOOL ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_UCHR, &ns_a1, pool, 1);

  ns_result = NSSetShowsServicesMenuItem(ns_a0, ns_a1);

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, pool);
  [pool release];
  return rb_result;
}

// void NSUpdateDynamicServices(void);
static VALUE
osx_NSUpdateDynamicServices(VALUE mdl)
{
  NSUpdateDynamicServices();
  return Qnil;
}

// BOOL NSPerformService(NSString *itemName, NSPasteboard *pboard);
static VALUE
osx_NSPerformService(VALUE mdl, VALUE a0, VALUE a1)
{
  BOOL ns_result;

  NSString * ns_a0;
  NSPasteboard * ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_ID, &ns_a1, pool, 1);

  ns_result = NSPerformService(ns_a0, ns_a1);

  rb_result = nsresult_to_rbresult(_PRIV_C_BOOL, &ns_result, pool);
  [pool release];
  return rb_result;
}

// void NSRegisterServicesProvider(id provider, NSString *name);
static VALUE
osx_NSRegisterServicesProvider(VALUE mdl, VALUE a0, VALUE a1)
{

  id ns_a0;
  NSString * ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_ID, &ns_a1, pool, 1);

  NSRegisterServicesProvider(ns_a0, ns_a1);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSUnregisterServicesProvider(NSString *name);
static VALUE
osx_NSUnregisterServicesProvider(VALUE mdl, VALUE a0)
{

  NSString * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);

  NSUnregisterServicesProvider(ns_a0);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

void init_NSApplication(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSRunStoppedResponse", INT2NUM(NSRunStoppedResponse));
  rb_define_const(mOSX, "NSRunAbortedResponse", INT2NUM(NSRunAbortedResponse));
  rb_define_const(mOSX, "NSRunContinuesResponse", INT2NUM(NSRunContinuesResponse));
  rb_define_const(mOSX, "NSUpdateWindowsRunLoopOrdering", INT2NUM(NSUpdateWindowsRunLoopOrdering));
  rb_define_const(mOSX, "NSCriticalRequest", INT2NUM(NSCriticalRequest));
  rb_define_const(mOSX, "NSInformationalRequest", INT2NUM(NSInformationalRequest));
  rb_define_const(mOSX, "NSTerminateCancel", INT2NUM(NSTerminateCancel));
  rb_define_const(mOSX, "NSTerminateNow", INT2NUM(NSTerminateNow));
  rb_define_const(mOSX, "NSTerminateLater", INT2NUM(NSTerminateLater));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSAppKitVersionNumber", osx_NSAppKitVersionNumber, 0);
  rb_define_module_function(mOSX, "NSModalPanelRunLoopMode", osx_NSModalPanelRunLoopMode, 0);
  rb_define_module_function(mOSX, "NSEventTrackingRunLoopMode", osx_NSEventTrackingRunLoopMode, 0);
  rb_define_module_function(mOSX, "NSApp", osx_NSApp, 0);
  rb_define_module_function(mOSX, "NSApplicationDidBecomeActiveNotification", osx_NSApplicationDidBecomeActiveNotification, 0);
  rb_define_module_function(mOSX, "NSApplicationDidHideNotification", osx_NSApplicationDidHideNotification, 0);
  rb_define_module_function(mOSX, "NSApplicationDidFinishLaunchingNotification", osx_NSApplicationDidFinishLaunchingNotification, 0);
  rb_define_module_function(mOSX, "NSApplicationDidResignActiveNotification", osx_NSApplicationDidResignActiveNotification, 0);
  rb_define_module_function(mOSX, "NSApplicationDidUnhideNotification", osx_NSApplicationDidUnhideNotification, 0);
  rb_define_module_function(mOSX, "NSApplicationDidUpdateNotification", osx_NSApplicationDidUpdateNotification, 0);
  rb_define_module_function(mOSX, "NSApplicationWillBecomeActiveNotification", osx_NSApplicationWillBecomeActiveNotification, 0);
  rb_define_module_function(mOSX, "NSApplicationWillHideNotification", osx_NSApplicationWillHideNotification, 0);
  rb_define_module_function(mOSX, "NSApplicationWillFinishLaunchingNotification", osx_NSApplicationWillFinishLaunchingNotification, 0);
  rb_define_module_function(mOSX, "NSApplicationWillResignActiveNotification", osx_NSApplicationWillResignActiveNotification, 0);
  rb_define_module_function(mOSX, "NSApplicationWillUnhideNotification", osx_NSApplicationWillUnhideNotification, 0);
  rb_define_module_function(mOSX, "NSApplicationWillUpdateNotification", osx_NSApplicationWillUpdateNotification, 0);
  rb_define_module_function(mOSX, "NSApplicationWillTerminateNotification", osx_NSApplicationWillTerminateNotification, 0);
  rb_define_module_function(mOSX, "NSApplicationDidChangeScreenParametersNotification", osx_NSApplicationDidChangeScreenParametersNotification, 0);
  /**** functions ****/
  rb_define_module_function(mOSX, "NSApplicationMain", osx_NSApplicationMain, 2);
  rb_define_module_function(mOSX, "NSShowsServicesMenuItem", osx_NSShowsServicesMenuItem, 1);
  rb_define_module_function(mOSX, "NSSetShowsServicesMenuItem", osx_NSSetShowsServicesMenuItem, 2);
  rb_define_module_function(mOSX, "NSUpdateDynamicServices", osx_NSUpdateDynamicServices, 0);
  rb_define_module_function(mOSX, "NSPerformService", osx_NSPerformService, 2);
  rb_define_module_function(mOSX, "NSRegisterServicesProvider", osx_NSRegisterServicesProvider, 2);
  rb_define_module_function(mOSX, "NSUnregisterServicesProvider", osx_NSUnregisterServicesProvider, 1);
}
