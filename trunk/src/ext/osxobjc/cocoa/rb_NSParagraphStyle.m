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


void init_NSParagraphStyle(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSLeftTabStopType", INT2NUM(NSLeftTabStopType));
  rb_define_const(mOSX, "NSRightTabStopType", INT2NUM(NSRightTabStopType));
  rb_define_const(mOSX, "NSCenterTabStopType", INT2NUM(NSCenterTabStopType));
  rb_define_const(mOSX, "NSDecimalTabStopType", INT2NUM(NSDecimalTabStopType));
  rb_define_const(mOSX, "NSLineBreakByWordWrapping", INT2NUM(NSLineBreakByWordWrapping));
  rb_define_const(mOSX, "NSLineBreakByCharWrapping", INT2NUM(NSLineBreakByCharWrapping));
  rb_define_const(mOSX, "NSLineBreakByClipping", INT2NUM(NSLineBreakByClipping));
  rb_define_const(mOSX, "NSLineBreakByTruncatingHead", INT2NUM(NSLineBreakByTruncatingHead));
  rb_define_const(mOSX, "NSLineBreakByTruncatingTail", INT2NUM(NSLineBreakByTruncatingTail));
  rb_define_const(mOSX, "NSLineBreakByTruncatingMiddle", INT2NUM(NSLineBreakByTruncatingMiddle));

}
