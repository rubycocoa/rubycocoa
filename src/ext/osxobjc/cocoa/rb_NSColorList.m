#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString *NSColorListDidChangeNotification;
static VALUE
osx_NSColorListDidChangeNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSColorListDidChangeNotification);
}

void init_NSColorList(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSColorListDidChangeNotification", osx_NSColorListDidChangeNotification, 0);
}
