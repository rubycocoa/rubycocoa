#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * NSPrintPhotoJobStyleHint;
static VALUE
osx_NSPrintPhotoJobStyleHint(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSPrintPhotoJobStyleHint, nil);
}

void init_NSPrintPanel(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSPPSaveButton", INT2NUM(NSPPSaveButton));
  rb_define_const(mOSX, "NSPPPreviewButton", INT2NUM(NSPPPreviewButton));
  rb_define_const(mOSX, "NSFaxButton", INT2NUM(NSFaxButton));
  rb_define_const(mOSX, "NSPPTitleField", INT2NUM(NSPPTitleField));
  rb_define_const(mOSX, "NSPPImageButton", INT2NUM(NSPPImageButton));
  rb_define_const(mOSX, "NSPPNameTitle", INT2NUM(NSPPNameTitle));
  rb_define_const(mOSX, "NSPPNameField", INT2NUM(NSPPNameField));
  rb_define_const(mOSX, "NSPPNoteTitle", INT2NUM(NSPPNoteTitle));
  rb_define_const(mOSX, "NSPPNoteField", INT2NUM(NSPPNoteField));
  rb_define_const(mOSX, "NSPPStatusTitle", INT2NUM(NSPPStatusTitle));
  rb_define_const(mOSX, "NSPPStatusField", INT2NUM(NSPPStatusField));
  rb_define_const(mOSX, "NSPPCopiesField", INT2NUM(NSPPCopiesField));
  rb_define_const(mOSX, "NSPPPageChoiceMatrix", INT2NUM(NSPPPageChoiceMatrix));
  rb_define_const(mOSX, "NSPPPageRangeFrom", INT2NUM(NSPPPageRangeFrom));
  rb_define_const(mOSX, "NSPPPageRangeTo", INT2NUM(NSPPPageRangeTo));
  rb_define_const(mOSX, "NSPPScaleField", INT2NUM(NSPPScaleField));
  rb_define_const(mOSX, "NSPPOptionsButton", INT2NUM(NSPPOptionsButton));
  rb_define_const(mOSX, "NSPPPaperFeedButton", INT2NUM(NSPPPaperFeedButton));
  rb_define_const(mOSX, "NSPPLayoutButton", INT2NUM(NSPPLayoutButton));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSPrintPhotoJobStyleHint", osx_NSPrintPhotoJobStyleHint, 0);
}
