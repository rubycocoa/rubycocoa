#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString *NSImageRepRegistryDidChangeNotification;
static VALUE
osx_NSImageRepRegistryDidChangeNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSImageRepRegistryDidChangeNotification);
}

void init_NSImageRep(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSImageRepMatchesDevice", INT2NUM(NSImageRepMatchesDevice));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSImageRepRegistryDidChangeNotification", osx_NSImageRepRegistryDidChangeNotification, 0);
}
