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
