#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
#define VA_MAX 4


  /**** constants ****/
// NSString *NSViewFrameDidChangeNotification;
static VALUE
osx_NSViewFrameDidChangeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSViewFrameDidChangeNotification, nil);
}

// NSString *NSViewFocusDidChangeNotification;
static VALUE
osx_NSViewFocusDidChangeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSViewFocusDidChangeNotification, nil);
}

// NSString *NSViewBoundsDidChangeNotification;
static VALUE
osx_NSViewBoundsDidChangeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSViewBoundsDidChangeNotification, nil);
}

// NSString *NSViewGlobalFrameDidChangeNotification;
static VALUE
osx_NSViewGlobalFrameDidChangeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSViewGlobalFrameDidChangeNotification, nil);
}

void init_NSView(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSViewNotSizable", INT2NUM(NSViewNotSizable));
  rb_define_const(mOSX, "NSViewMinXMargin", INT2NUM(NSViewMinXMargin));
  rb_define_const(mOSX, "NSViewWidthSizable", INT2NUM(NSViewWidthSizable));
  rb_define_const(mOSX, "NSViewMaxXMargin", INT2NUM(NSViewMaxXMargin));
  rb_define_const(mOSX, "NSViewMinYMargin", INT2NUM(NSViewMinYMargin));
  rb_define_const(mOSX, "NSViewHeightSizable", INT2NUM(NSViewHeightSizable));
  rb_define_const(mOSX, "NSViewMaxYMargin", INT2NUM(NSViewMaxYMargin));
  rb_define_const(mOSX, "NSNoBorder", INT2NUM(NSNoBorder));
  rb_define_const(mOSX, "NSLineBorder", INT2NUM(NSLineBorder));
  rb_define_const(mOSX, "NSBezelBorder", INT2NUM(NSBezelBorder));
  rb_define_const(mOSX, "NSGrooveBorder", INT2NUM(NSGrooveBorder));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSViewFrameDidChangeNotification", osx_NSViewFrameDidChangeNotification, 0);
  rb_define_module_function(mOSX, "NSViewFocusDidChangeNotification", osx_NSViewFocusDidChangeNotification, 0);
  rb_define_module_function(mOSX, "NSViewBoundsDidChangeNotification", osx_NSViewBoundsDidChangeNotification, 0);
  rb_define_module_function(mOSX, "NSViewGlobalFrameDidChangeNotification", osx_NSViewGlobalFrameDidChangeNotification, 0);
}
