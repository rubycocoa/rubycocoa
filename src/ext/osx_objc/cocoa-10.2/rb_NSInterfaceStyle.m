#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * NSInterfaceStyleDefault;
static VALUE
osx_NSInterfaceStyleDefault(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSInterfaceStyleDefault, nil);
}

  /**** functions ****/
// NSInterfaceStyle NSInterfaceStyleForKey ( NSString * key , NSResponder * responder );
static VALUE
osx_NSInterfaceStyleForKey(VALUE mdl, VALUE a0, VALUE a1)
{
  NSInterfaceStyle ns_result;

  NSString * ns_a0;
  NSResponder * ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_ID, &ns_a1, pool, 1);

  ns_result = NSInterfaceStyleForKey(ns_a0, ns_a1);

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, pool);
  [pool release];
  return rb_result;
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
