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
