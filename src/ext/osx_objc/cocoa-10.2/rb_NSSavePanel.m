#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


void init_NSSavePanel(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSFileHandlingPanelImageButton", INT2NUM(NSFileHandlingPanelImageButton));
  rb_define_const(mOSX, "NSFileHandlingPanelTitleField", INT2NUM(NSFileHandlingPanelTitleField));
  rb_define_const(mOSX, "NSFileHandlingPanelBrowser", INT2NUM(NSFileHandlingPanelBrowser));
  rb_define_const(mOSX, "NSFileHandlingPanelCancelButton", INT2NUM(NSFileHandlingPanelCancelButton));
  rb_define_const(mOSX, "NSFileHandlingPanelOKButton", INT2NUM(NSFileHandlingPanelOKButton));
  rb_define_const(mOSX, "NSFileHandlingPanelForm", INT2NUM(NSFileHandlingPanelForm));
  rb_define_const(mOSX, "NSFileHandlingPanelHomeButton", INT2NUM(NSFileHandlingPanelHomeButton));
  rb_define_const(mOSX, "NSFileHandlingPanelDiskButton", INT2NUM(NSFileHandlingPanelDiskButton));
  rb_define_const(mOSX, "NSFileHandlingPanelDiskEjectButton", INT2NUM(NSFileHandlingPanelDiskEjectButton));

}
