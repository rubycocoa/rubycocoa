#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

void init_NSFontPanel(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSFPPreviewButton", INT2NUM(NSFPPreviewButton));
  rb_define_const(mOSX, "NSFPRevertButton", INT2NUM(NSFPRevertButton));
  rb_define_const(mOSX, "NSFPSetButton", INT2NUM(NSFPSetButton));
  rb_define_const(mOSX, "NSFPPreviewField", INT2NUM(NSFPPreviewField));
  rb_define_const(mOSX, "NSFPSizeField", INT2NUM(NSFPSizeField));
  rb_define_const(mOSX, "NSFPSizeTitle", INT2NUM(NSFPSizeTitle));
  rb_define_const(mOSX, "NSFPCurrentField", INT2NUM(NSFPCurrentField));

}
