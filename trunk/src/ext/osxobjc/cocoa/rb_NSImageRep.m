#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);


  /**** constants ****/
// NSString *NSImageRepRegistryDidChangeNotification;
static VALUE
osx_NSImageRepRegistryDidChangeNotification(VALUE mdl)
{
  NSString * ns_result = NSImageRepRegistryDidChangeNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

void init_NSImageRep(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSImageRepMatchesDevice", INT2NUM(NSImageRepMatchesDevice));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSImageRepRegistryDidChangeNotification", osx_NSImageRepRegistryDidChangeNotification, 0);
}
