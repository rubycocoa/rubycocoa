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


void init_NSButtonCell(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSMomentaryLightButton", INT2NUM(NSMomentaryLightButton));
  rb_define_const(mOSX, "NSPushOnPushOffButton", INT2NUM(NSPushOnPushOffButton));
  rb_define_const(mOSX, "NSToggleButton", INT2NUM(NSToggleButton));
  rb_define_const(mOSX, "NSSwitchButton", INT2NUM(NSSwitchButton));
  rb_define_const(mOSX, "NSRadioButton", INT2NUM(NSRadioButton));
  rb_define_const(mOSX, "NSMomentaryChangeButton", INT2NUM(NSMomentaryChangeButton));
  rb_define_const(mOSX, "NSOnOffButton", INT2NUM(NSOnOffButton));
  rb_define_const(mOSX, "NSMomentaryPushInButton", INT2NUM(NSMomentaryPushInButton));
  rb_define_const(mOSX, "NSMomentaryPushButton", INT2NUM(NSMomentaryPushButton));
  rb_define_const(mOSX, "NSMomentaryLight", INT2NUM(NSMomentaryLight));
  rb_define_const(mOSX, "NSRoundedBezelStyle", INT2NUM(NSRoundedBezelStyle));
  rb_define_const(mOSX, "NSRegularSquareBezelStyle", INT2NUM(NSRegularSquareBezelStyle));
  rb_define_const(mOSX, "NSThickSquareBezelStyle", INT2NUM(NSThickSquareBezelStyle));
  rb_define_const(mOSX, "NSThickerSquareBezelStyle", INT2NUM(NSThickerSquareBezelStyle));
  rb_define_const(mOSX, "NSShadowlessSquareBezelStyle", INT2NUM(NSShadowlessSquareBezelStyle));
  rb_define_const(mOSX, "NSCircularBezelStyle", INT2NUM(NSCircularBezelStyle));
  rb_define_const(mOSX, "NSSmallIconButtonBezelStyle", INT2NUM(NSSmallIconButtonBezelStyle));
  rb_define_const(mOSX, "NSGradientNone", INT2NUM(NSGradientNone));
  rb_define_const(mOSX, "NSGradientConcaveWeak", INT2NUM(NSGradientConcaveWeak));
  rb_define_const(mOSX, "NSGradientConcaveStrong", INT2NUM(NSGradientConcaveStrong));
  rb_define_const(mOSX, "NSGradientConvexWeak", INT2NUM(NSGradientConvexWeak));
  rb_define_const(mOSX, "NSGradientConvexStrong", INT2NUM(NSGradientConvexStrong));

}
