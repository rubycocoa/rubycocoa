#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


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
  rb_define_const(mOSX, "NSFontPanelFaceModeMask", INT2NUM(NSFontPanelFaceModeMask));
  rb_define_const(mOSX, "NSFontPanelSizeModeMask", INT2NUM(NSFontPanelSizeModeMask));
  rb_define_const(mOSX, "NSFontPanelCollectionModeMask", INT2NUM(NSFontPanelCollectionModeMask));
  rb_define_const(mOSX, "NSFontPanelStandardModesMask", INT2NUM(NSFontPanelStandardModesMask));
  rb_define_const(mOSX, "NSFontPanelAllModesMask", INT2NUM(NSFontPanelAllModesMask));

}
