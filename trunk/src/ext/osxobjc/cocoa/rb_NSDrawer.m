#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);


  /**** constants ****/
// NSString *NSDrawerWillOpenNotification;
static VALUE
osx_NSDrawerWillOpenNotification(VALUE mdl)
{
  NSString * ns_result = NSDrawerWillOpenNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSDrawerDidOpenNotification;
static VALUE
osx_NSDrawerDidOpenNotification(VALUE mdl)
{
  NSString * ns_result = NSDrawerDidOpenNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSDrawerWillCloseNotification;
static VALUE
osx_NSDrawerWillCloseNotification(VALUE mdl)
{
  NSString * ns_result = NSDrawerWillCloseNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSDrawerDidCloseNotification;
static VALUE
osx_NSDrawerDidCloseNotification(VALUE mdl)
{
  NSString * ns_result = NSDrawerDidCloseNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
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
