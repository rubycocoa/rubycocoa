#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// double NSAppKitVersionNumber;
static VALUE
osx_NSAppKitVersionNumber(VALUE mdl)
{
  rb_notimplement();
}

// NSString *NSModalPanelRunLoopMode;
static VALUE
osx_NSModalPanelRunLoopMode(VALUE mdl)
{
  return ocobj_new_with_ocid(NSModalPanelRunLoopMode);
}

// NSString *NSEventTrackingRunLoopMode;
static VALUE
osx_NSEventTrackingRunLoopMode(VALUE mdl)
{
  return ocobj_new_with_ocid(NSEventTrackingRunLoopMode);
}

// id NSApp;
static VALUE
osx_NSApp(VALUE mdl)
{
  return ocobj_new_with_ocid(NSApp);
}

// NSString *NSApplicationDidBecomeActiveNotification;
static VALUE
osx_NSApplicationDidBecomeActiveNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSApplicationDidBecomeActiveNotification);
}

// NSString *NSApplicationDidHideNotification;
static VALUE
osx_NSApplicationDidHideNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSApplicationDidHideNotification);
}

// NSString *NSApplicationDidFinishLaunchingNotification;
static VALUE
osx_NSApplicationDidFinishLaunchingNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSApplicationDidFinishLaunchingNotification);
}

// NSString *NSApplicationDidResignActiveNotification;
static VALUE
osx_NSApplicationDidResignActiveNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSApplicationDidResignActiveNotification);
}

// NSString *NSApplicationDidUnhideNotification;
static VALUE
osx_NSApplicationDidUnhideNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSApplicationDidUnhideNotification);
}

// NSString *NSApplicationDidUpdateNotification;
static VALUE
osx_NSApplicationDidUpdateNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSApplicationDidUpdateNotification);
}

// NSString *NSApplicationWillBecomeActiveNotification;
static VALUE
osx_NSApplicationWillBecomeActiveNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSApplicationWillBecomeActiveNotification);
}

// NSString *NSApplicationWillHideNotification;
static VALUE
osx_NSApplicationWillHideNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSApplicationWillHideNotification);
}

// NSString *NSApplicationWillFinishLaunchingNotification;
static VALUE
osx_NSApplicationWillFinishLaunchingNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSApplicationWillFinishLaunchingNotification);
}

// NSString *NSApplicationWillResignActiveNotification;
static VALUE
osx_NSApplicationWillResignActiveNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSApplicationWillResignActiveNotification);
}

// NSString *NSApplicationWillUnhideNotification;
static VALUE
osx_NSApplicationWillUnhideNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSApplicationWillUnhideNotification);
}

// NSString *NSApplicationWillUpdateNotification;
static VALUE
osx_NSApplicationWillUpdateNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSApplicationWillUpdateNotification);
}

// NSString *NSApplicationWillTerminateNotification;
static VALUE
osx_NSApplicationWillTerminateNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSApplicationWillTerminateNotification);
}

// NSString *NSApplicationDidChangeScreenParametersNotification;
static VALUE
osx_NSApplicationDidChangeScreenParametersNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSApplicationDidChangeScreenParametersNotification);
}

  /**** functions ****/
// int NSApplicationMain(int argc, const char *argv[]);
static VALUE
osx_NSApplicationMain(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// BOOL NSShowsServicesMenuItem(NSString * itemName);
static VALUE
osx_NSShowsServicesMenuItem(int argc, VALUE* argv, VALUE mdl)
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

  ns_result =  NSShowsServicesMenuItem(oc_args[0]);
  rb_result = bool_to_rbobj(ns_result);
  [pool release];
  return rb_result;
}

// int NSSetShowsServicesMenuItem(NSString * itemName, BOOL enabled);
static VALUE
osx_NSSetShowsServicesMenuItem(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSUpdateDynamicServices(void);
static VALUE
osx_NSUpdateDynamicServices(VALUE mdl)
{
  id pool = [[NSAutoreleasePool alloc] init];
  
  VALUE rb_result;
  
   NSUpdateDynamicServices();
  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// BOOL NSPerformService(NSString *itemName, NSPasteboard *pboard);
static VALUE
osx_NSPerformService(int argc, VALUE* argv, VALUE mdl)
{
  id pool = [[NSAutoreleasePool alloc] init];
  BOOL ns_result;
  VALUE rb_result;
    int i;
  id oc_args[2];
  for (i = 0; i < argc; i++) {
    if (!rbobj_to_nsobj(argv[i], &oc_args[i])) {
      [pool release];
      rb_raise(rb_eArgError, "arg #%d cannot convert to nsobj.", i);
    }
  }

  ns_result =  NSPerformService(oc_args[0], oc_args[1]);
  rb_result = bool_to_rbobj(ns_result);
  [pool release];
  return rb_result;
}

// void NSRegisterServicesProvider(id provider, NSString *name);
static VALUE
osx_NSRegisterServicesProvider(int argc, VALUE* argv, VALUE mdl)
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

   NSRegisterServicesProvider(oc_args[0], oc_args[1]);
  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSUnregisterServicesProvider(NSString *name);
static VALUE
osx_NSUnregisterServicesProvider(int argc, VALUE* argv, VALUE mdl)
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

   NSUnregisterServicesProvider(oc_args[0]);
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
  rb_define_module_function(mOSX, "NSApplicationMain", osx_NSApplicationMain, -1);
  rb_define_module_function(mOSX, "NSShowsServicesMenuItem", osx_NSShowsServicesMenuItem, -1);
  rb_define_module_function(mOSX, "NSSetShowsServicesMenuItem", osx_NSSetShowsServicesMenuItem, -1);
  rb_define_module_function(mOSX, "NSUpdateDynamicServices", osx_NSUpdateDynamicServices, 0);
  rb_define_module_function(mOSX, "NSPerformService", osx_NSPerformService, -1);
  rb_define_module_function(mOSX, "NSRegisterServicesProvider", osx_NSRegisterServicesProvider, -1);
  rb_define_module_function(mOSX, "NSUnregisterServicesProvider", osx_NSUnregisterServicesProvider, -1);
}
