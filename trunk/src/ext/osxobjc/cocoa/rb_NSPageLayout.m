#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

void init_NSPageLayout(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSPLImageButton", INT2NUM(NSPLImageButton));
  rb_define_const(mOSX, "NSPLTitleField", INT2NUM(NSPLTitleField));
  rb_define_const(mOSX, "NSPLPaperNameButton", INT2NUM(NSPLPaperNameButton));
  rb_define_const(mOSX, "NSPLUnitsButton", INT2NUM(NSPLUnitsButton));
  rb_define_const(mOSX, "NSPLWidthForm", INT2NUM(NSPLWidthForm));
  rb_define_const(mOSX, "NSPLHeightForm", INT2NUM(NSPLHeightForm));
  rb_define_const(mOSX, "NSPLOrientationMatrix", INT2NUM(NSPLOrientationMatrix));
  rb_define_const(mOSX, "NSPLCancelButton", INT2NUM(NSPLCancelButton));
  rb_define_const(mOSX, "NSPLOKButton", INT2NUM(NSPLOKButton));

}
