#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <Foundation/Foundation.h>

  /**** constants ****/
// NSString *NSClassDescriptionNeededForClassNotification;
static VALUE
osx_NSClassDescriptionNeededForClassNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSClassDescriptionNeededForClassNotification);
}

void init_NSClassDescription(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSClassDescriptionNeededForClassNotification", osx_NSClassDescriptionNeededForClassNotification, 0);
}
