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


void init_NSImageCell(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSScaleProportionally", INT2NUM(NSScaleProportionally));
  rb_define_const(mOSX, "NSScaleToFit", INT2NUM(NSScaleToFit));
  rb_define_const(mOSX, "NSScaleNone", INT2NUM(NSScaleNone));
  rb_define_const(mOSX, "NSImageAlignCenter", INT2NUM(NSImageAlignCenter));
  rb_define_const(mOSX, "NSImageAlignTop", INT2NUM(NSImageAlignTop));
  rb_define_const(mOSX, "NSImageAlignTopLeft", INT2NUM(NSImageAlignTopLeft));
  rb_define_const(mOSX, "NSImageAlignTopRight", INT2NUM(NSImageAlignTopRight));
  rb_define_const(mOSX, "NSImageAlignLeft", INT2NUM(NSImageAlignLeft));
  rb_define_const(mOSX, "NSImageAlignBottom", INT2NUM(NSImageAlignBottom));
  rb_define_const(mOSX, "NSImageAlignBottomLeft", INT2NUM(NSImageAlignBottomLeft));
  rb_define_const(mOSX, "NSImageAlignBottomRight", INT2NUM(NSImageAlignBottomRight));
  rb_define_const(mOSX, "NSImageAlignRight", INT2NUM(NSImageAlignRight));
  rb_define_const(mOSX, "NSImageFrameNone", INT2NUM(NSImageFrameNone));
  rb_define_const(mOSX, "NSImageFramePhoto", INT2NUM(NSImageFramePhoto));
  rb_define_const(mOSX, "NSImageFrameGrayBezel", INT2NUM(NSImageFrameGrayBezel));
  rb_define_const(mOSX, "NSImageFrameGroove", INT2NUM(NSImageFrameGroove));
  rb_define_const(mOSX, "NSImageFrameButton", INT2NUM(NSImageFrameButton));

}
