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
// NSString *NSInterfaceStyleDefault;
static VALUE
osx_NSInterfaceStyleDefault(VALUE mdl)
{
  NSString * ns_result = NSInterfaceStyleDefault;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

  /**** functions ****/
// NSInterfaceStyle NSInterfaceStyleForKey(NSString *key, NSResponder *responder);
static VALUE
osx_NSInterfaceStyleForKey(VALUE mdl, VALUE a0, VALUE a1)
{
  rb_notimplement();
}

void init_NSInterfaceStyle(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSNoInterfaceStyle", INT2NUM(NSNoInterfaceStyle));
  rb_define_const(mOSX, "NSNextStepInterfaceStyle", INT2NUM(NSNextStepInterfaceStyle));
  rb_define_const(mOSX, "NSWindows95InterfaceStyle", INT2NUM(NSWindows95InterfaceStyle));
  rb_define_const(mOSX, "NSMacintoshInterfaceStyle", INT2NUM(NSMacintoshInterfaceStyle));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSInterfaceStyleDefault", osx_NSInterfaceStyleDefault, 0);
  /**** functions ****/
  rb_define_module_function(mOSX, "NSInterfaceStyleForKey", osx_NSInterfaceStyleForKey, 2);
}
