#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString *NSPopUpButtonWillPopUpNotification;
static VALUE
osx_NSPopUpButtonWillPopUpNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPopUpButtonWillPopUpNotification);
}

void init_NSPopUpButton(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSPopUpButtonWillPopUpNotification", osx_NSPopUpButtonWillPopUpNotification, 0);
}
