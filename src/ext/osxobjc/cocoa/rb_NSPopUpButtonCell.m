#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString *NSPopUpButtonCellWillPopUpNotification;
static VALUE
osx_NSPopUpButtonCellWillPopUpNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPopUpButtonCellWillPopUpNotification);
}

void init_NSPopUpButtonCell(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSPopUpNoArrow", INT2NUM(NSPopUpNoArrow));
  rb_define_const(mOSX, "NSPopUpArrowAtCenter", INT2NUM(NSPopUpArrowAtCenter));
  rb_define_const(mOSX, "NSPopUpArrowAtBottom", INT2NUM(NSPopUpArrowAtBottom));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSPopUpButtonCellWillPopUpNotification", osx_NSPopUpButtonCellWillPopUpNotification, 0);
}
