#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** functions ****/
// int NSRunAlertPanel(NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, ...);
static VALUE
osx_NSRunAlertPanel(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// int NSRunInformationalAlertPanel(NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, ...);
static VALUE
osx_NSRunInformationalAlertPanel(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// int NSRunCriticalAlertPanel(NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, ...);
static VALUE
osx_NSRunCriticalAlertPanel(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// int NSRunAlertPanelRelativeToWindow(NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, NSWindow *docWindow, ...);
static VALUE
osx_NSRunAlertPanelRelativeToWindow(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// int NSRunInformationalAlertPanelRelativeToWindow(NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, NSWindow *docWindow, ...);
static VALUE
osx_NSRunInformationalAlertPanelRelativeToWindow(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// int NSRunCriticalAlertPanelRelativeToWindow(NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, NSWindow *docWindow, ...);
static VALUE
osx_NSRunCriticalAlertPanelRelativeToWindow(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSBeginAlertSheet(NSString *title, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, NSWindow *docWindow, id modalDelegate, SEL didEndSelector, SEL didDismissSelector, void *contextInfo, NSString *msg, ...);
static VALUE
osx_NSBeginAlertSheet(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSBeginInformationalAlertSheet(NSString *title, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, NSWindow *docWindow, id modalDelegate, SEL didEndSelector, SEL didDismissSelector, void *contextInfo, NSString *msg, ...);
static VALUE
osx_NSBeginInformationalAlertSheet(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSBeginCriticalAlertSheet(NSString *title, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, NSWindow *docWindow, id modalDelegate, SEL didEndSelector, SEL didDismissSelector, void *contextInfo, NSString *msg, ...);
static VALUE
osx_NSBeginCriticalAlertSheet(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// id NSGetAlertPanel(NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, ...);
static VALUE
osx_NSGetAlertPanel(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// id NSGetInformationalAlertPanel(NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, ...);
static VALUE
osx_NSGetInformationalAlertPanel(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// id NSGetCriticalAlertPanel(NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton, NSString *otherButton, ...);
static VALUE
osx_NSGetCriticalAlertPanel(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSReleaseAlertPanel(id panel);
static VALUE
osx_NSReleaseAlertPanel(int argc, VALUE* argv, VALUE mdl)
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

   NSReleaseAlertPanel(oc_args[0]);
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
  rb_define_module_function(mOSX, "NSRunAlertPanel", osx_NSRunAlertPanel, -1);
  rb_define_module_function(mOSX, "NSRunInformationalAlertPanel", osx_NSRunInformationalAlertPanel, -1);
  rb_define_module_function(mOSX, "NSRunCriticalAlertPanel", osx_NSRunCriticalAlertPanel, -1);
  rb_define_module_function(mOSX, "NSRunAlertPanelRelativeToWindow", osx_NSRunAlertPanelRelativeToWindow, -1);
  rb_define_module_function(mOSX, "NSRunInformationalAlertPanelRelativeToWindow", osx_NSRunInformationalAlertPanelRelativeToWindow, -1);
  rb_define_module_function(mOSX, "NSRunCriticalAlertPanelRelativeToWindow", osx_NSRunCriticalAlertPanelRelativeToWindow, -1);
  rb_define_module_function(mOSX, "NSBeginAlertSheet", osx_NSBeginAlertSheet, -1);
  rb_define_module_function(mOSX, "NSBeginInformationalAlertSheet", osx_NSBeginInformationalAlertSheet, -1);
  rb_define_module_function(mOSX, "NSBeginCriticalAlertSheet", osx_NSBeginCriticalAlertSheet, -1);
  rb_define_module_function(mOSX, "NSGetAlertPanel", osx_NSGetAlertPanel, -1);
  rb_define_module_function(mOSX, "NSGetInformationalAlertPanel", osx_NSGetInformationalAlertPanel, -1);
  rb_define_module_function(mOSX, "NSGetCriticalAlertPanel", osx_NSGetCriticalAlertPanel, -1);
  rb_define_module_function(mOSX, "NSReleaseAlertPanel", osx_NSReleaseAlertPanel, -1);
}
