#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

static void
rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index)
{
  if (!rbobj_to_ocdata(rbarg, octype, nsarg)) {
    if (pool) [pool release];
    rb_raise(rb_eArgError, "arg #%d cannot convert to nsobj.", index);
  }
}

static VALUE
nsresult_to_rbresult(int octype, const void* nsresult, id pool)
{
  VALUE rbresult;
  if (octype == _C_ID) {
    rbresult = ocobj_new_with_ocid(*(id*)nsresult);
  }
  else {
    if (!ocdata_to_rbobj(octype, nsresult, &rbresult)) {
      if (pool) [pool release];
      rb_raise(rb_eRuntimeError, "result cannot convert to rbobj.");
    }
  }
  return rbresult;
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

}
