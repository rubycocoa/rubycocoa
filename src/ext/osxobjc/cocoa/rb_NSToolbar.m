#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);


  /**** constants ****/
// NSString *NSToolbarWillAddItemNotification;
static VALUE
osx_NSToolbarWillAddItemNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSToolbarWillAddItemNotification, nil);
}

// NSString *NSToolbarDidRemoveItemNotification;
static VALUE
osx_NSToolbarDidRemoveItemNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSToolbarDidRemoveItemNotification, nil);
}

void init_NSToolbar(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSToolbarDisplayModeDefault", INT2NUM(NSToolbarDisplayModeDefault));
  rb_define_const(mOSX, "NSToolbarDisplayModeIconAndLabel", INT2NUM(NSToolbarDisplayModeIconAndLabel));
  rb_define_const(mOSX, "NSToolbarDisplayModeIconOnly", INT2NUM(NSToolbarDisplayModeIconOnly));
  rb_define_const(mOSX, "NSToolbarDisplayModeLabelOnly", INT2NUM(NSToolbarDisplayModeLabelOnly));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSToolbarWillAddItemNotification", osx_NSToolbarWillAddItemNotification, 0);
  rb_define_module_function(mOSX, "NSToolbarDidRemoveItemNotification", osx_NSToolbarDidRemoveItemNotification, 0);
}
