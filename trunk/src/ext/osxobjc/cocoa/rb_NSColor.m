#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString *NSSystemColorsDidChangeNotification;
static VALUE
osx_NSSystemColorsDidChangeNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSSystemColorsDidChangeNotification);
}

void init_NSColor(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSSystemColorsDidChangeNotification", osx_NSSystemColorsDidChangeNotification, 0);
}
