#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);


  /**** constants ****/
// NSString *NSPopUpButtonCellWillPopUpNotification;
static VALUE
osx_NSPopUpButtonCellWillPopUpNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSPopUpButtonCellWillPopUpNotification, nil);
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
