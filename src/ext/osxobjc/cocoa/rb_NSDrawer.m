#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString *NSDrawerWillOpenNotification;
static VALUE
osx_NSDrawerWillOpenNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSDrawerWillOpenNotification);
}

// NSString *NSDrawerDidOpenNotification;
static VALUE
osx_NSDrawerDidOpenNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSDrawerDidOpenNotification);
}

// NSString *NSDrawerWillCloseNotification;
static VALUE
osx_NSDrawerWillCloseNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSDrawerWillCloseNotification);
}

// NSString *NSDrawerDidCloseNotification;
static VALUE
osx_NSDrawerDidCloseNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSDrawerDidCloseNotification);
}

void init_NSDrawer(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSDrawerClosedState", INT2NUM(NSDrawerClosedState));
  rb_define_const(mOSX, "NSDrawerOpeningState", INT2NUM(NSDrawerOpeningState));
  rb_define_const(mOSX, "NSDrawerOpenState", INT2NUM(NSDrawerOpenState));
  rb_define_const(mOSX, "NSDrawerClosingState", INT2NUM(NSDrawerClosingState));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSDrawerWillOpenNotification", osx_NSDrawerWillOpenNotification, 0);
  rb_define_module_function(mOSX, "NSDrawerDidOpenNotification", osx_NSDrawerDidOpenNotification, 0);
  rb_define_module_function(mOSX, "NSDrawerWillCloseNotification", osx_NSDrawerWillCloseNotification, 0);
  rb_define_module_function(mOSX, "NSDrawerDidCloseNotification", osx_NSDrawerDidCloseNotification, 0);
}
