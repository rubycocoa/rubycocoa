#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <Foundation/Foundation.h>

  /**** constants ****/
// NSString *NSURLFileScheme;
static VALUE
osx_NSURLFileScheme(VALUE mdl)
{
  return ocobj_new_with_ocid(NSURLFileScheme);
}

void init_NSURL(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSURLFileScheme", osx_NSURLFileScheme, 0);
}
