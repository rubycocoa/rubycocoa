#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString *NSInterfaceStyleDefault;
static VALUE
osx_NSInterfaceStyleDefault(VALUE mdl)
{
  return ocobj_new_with_ocid(NSInterfaceStyleDefault);
}

  /**** functions ****/
// NSInterfaceStyle NSInterfaceStyleForKey(NSString *key, NSResponder *responder);
static VALUE
osx_NSInterfaceStyleForKey(int argc, VALUE* argv, VALUE mdl)
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
  rb_define_module_function(mOSX, "NSInterfaceStyleForKey", osx_NSInterfaceStyleForKey, -1);
}
