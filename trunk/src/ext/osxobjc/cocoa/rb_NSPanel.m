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


  /**** functions ****/
// int NSRunAlertPanel(NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, ...);
static VALUE
osx_NSRunAlertPanel(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3, VALUE a4, VALUE a5)
{
  rb_notimplement();
}

// int NSRunInformationalAlertPanel(NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, ...);
static VALUE
osx_NSRunInformationalAlertPanel(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3, VALUE a4, VALUE a5)
{
  rb_notimplement();
}

// int NSRunCriticalAlertPanel(NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, ...);
static VALUE
osx_NSRunCriticalAlertPanel(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3, VALUE a4, VALUE a5)
{
  rb_notimplement();
}

// int NSRunAlertPanelRelativeToWindow(NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, NSWindow *docWindow, ...);
static VALUE
osx_NSRunAlertPanelRelativeToWindow(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3, VALUE a4, VALUE a5, VALUE a6)
{
  rb_notimplement();
}

// int NSRunInformationalAlertPanelRelativeToWindow(NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, NSWindow *docWindow, ...);
static VALUE
osx_NSRunInformationalAlertPanelRelativeToWindow(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3, VALUE a4, VALUE a5, VALUE a6)
{
  rb_notimplement();
}

// int NSRunCriticalAlertPanelRelativeToWindow(NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, NSWindow *docWindow, ...);
static VALUE
osx_NSRunCriticalAlertPanelRelativeToWindow(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3, VALUE a4, VALUE a5, VALUE a6)
{
  rb_notimplement();
}

// void NSBeginAlertSheet(NSString *title, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, NSWindow *docWindow, id modalDelegate, SEL didEndSelector, SEL didDismissSelector, void *contextInfo, NSString *msg, ...);
static VALUE
osx_NSBeginAlertSheet(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3, VALUE a4, VALUE a5, VALUE a6, VALUE a7, VALUE a8, VALUE a9, VALUE a10)
{
  rb_notimplement();
}

// void NSBeginInformationalAlertSheet(NSString *title, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, NSWindow *docWindow, id modalDelegate, SEL didEndSelector, SEL didDismissSelector, void *contextInfo, NSString *msg, ...);
static VALUE
osx_NSBeginInformationalAlertSheet(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3, VALUE a4, VALUE a5, VALUE a6, VALUE a7, VALUE a8, VALUE a9, VALUE a10)
{
  rb_notimplement();
}

// void NSBeginCriticalAlertSheet(NSString *title, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, NSWindow *docWindow, id modalDelegate, SEL didEndSelector, SEL didDismissSelector, void *contextInfo, NSString *msg, ...);
static VALUE
osx_NSBeginCriticalAlertSheet(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3, VALUE a4, VALUE a5, VALUE a6, VALUE a7, VALUE a8, VALUE a9, VALUE a10)
{
  rb_notimplement();
}

// id NSGetAlertPanel(NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, ...);
static VALUE
osx_NSGetAlertPanel(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3, VALUE a4, VALUE a5)
{
  rb_notimplement();
}

// id NSGetInformationalAlertPanel(NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, ...);
static VALUE
osx_NSGetInformationalAlertPanel(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3, VALUE a4, VALUE a5)
{
  rb_notimplement();
}

// id NSGetCriticalAlertPanel(NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, ...);
static VALUE
osx_NSGetCriticalAlertPanel(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3, VALUE a4, VALUE a5)
{
  rb_notimplement();
}

// void NSReleaseAlertPanel(id panel);
static VALUE
osx_NSReleaseAlertPanel(VALUE mdl, VALUE a0)
{

  id ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);

  NSReleaseAlertPanel(ns_a0);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

void init_NSPanel(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSAlertDefaultReturn", INT2NUM(NSAlertDefaultReturn));
  rb_define_const(mOSX, "NSAlertAlternateReturn", INT2NUM(NSAlertAlternateReturn));
  rb_define_const(mOSX, "NSAlertOtherReturn", INT2NUM(NSAlertOtherReturn));
  rb_define_const(mOSX, "NSAlertErrorReturn", INT2NUM(NSAlertErrorReturn));
  rb_define_const(mOSX, "NSOKButton", INT2NUM(NSOKButton));
  rb_define_const(mOSX, "NSCancelButton", INT2NUM(NSCancelButton));
  rb_define_const(mOSX, "NSUtilityWindowMask", INT2NUM(NSUtilityWindowMask));
  rb_define_const(mOSX, "NSDocModalWindowMask", INT2NUM(NSDocModalWindowMask));

  /**** functions ****/
  rb_define_module_function(mOSX, "NSRunAlertPanel", osx_NSRunAlertPanel, 6);
  rb_define_module_function(mOSX, "NSRunInformationalAlertPanel", osx_NSRunInformationalAlertPanel, 6);
  rb_define_module_function(mOSX, "NSRunCriticalAlertPanel", osx_NSRunCriticalAlertPanel, 6);
  rb_define_module_function(mOSX, "NSRunAlertPanelRelativeToWindow", osx_NSRunAlertPanelRelativeToWindow, 7);
  rb_define_module_function(mOSX, "NSRunInformationalAlertPanelRelativeToWindow", osx_NSRunInformationalAlertPanelRelativeToWindow, 7);
  rb_define_module_function(mOSX, "NSRunCriticalAlertPanelRelativeToWindow", osx_NSRunCriticalAlertPanelRelativeToWindow, 7);
  rb_define_module_function(mOSX, "NSBeginAlertSheet", osx_NSBeginAlertSheet, 11);
  rb_define_module_function(mOSX, "NSBeginInformationalAlertSheet", osx_NSBeginInformationalAlertSheet, 11);
  rb_define_module_function(mOSX, "NSBeginCriticalAlertSheet", osx_NSBeginCriticalAlertSheet, 11);
  rb_define_module_function(mOSX, "NSGetAlertPanel", osx_NSGetAlertPanel, 6);
  rb_define_module_function(mOSX, "NSGetInformationalAlertPanel", osx_NSGetInformationalAlertPanel, 6);
  rb_define_module_function(mOSX, "NSGetCriticalAlertPanel", osx_NSGetCriticalAlertPanel, 6);
  rb_define_module_function(mOSX, "NSReleaseAlertPanel", osx_NSReleaseAlertPanel, 1);
}
