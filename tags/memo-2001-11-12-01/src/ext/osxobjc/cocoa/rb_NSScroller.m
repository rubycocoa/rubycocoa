#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);


void init_NSScroller(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSScrollerArrowsMaxEnd", INT2NUM(NSScrollerArrowsMaxEnd));
  rb_define_const(mOSX, "NSScrollerArrowsMinEnd", INT2NUM(NSScrollerArrowsMinEnd));
  rb_define_const(mOSX, "NSScrollerArrowsDefaultSetting", INT2NUM(NSScrollerArrowsDefaultSetting));
  rb_define_const(mOSX, "NSScrollerArrowsNone", INT2NUM(NSScrollerArrowsNone));
  rb_define_const(mOSX, "NSNoScrollerParts", INT2NUM(NSNoScrollerParts));
  rb_define_const(mOSX, "NSOnlyScrollerArrows", INT2NUM(NSOnlyScrollerArrows));
  rb_define_const(mOSX, "NSAllScrollerParts", INT2NUM(NSAllScrollerParts));
  rb_define_const(mOSX, "NSScrollerNoPart", INT2NUM(NSScrollerNoPart));
  rb_define_const(mOSX, "NSScrollerDecrementPage", INT2NUM(NSScrollerDecrementPage));
  rb_define_const(mOSX, "NSScrollerKnob", INT2NUM(NSScrollerKnob));
  rb_define_const(mOSX, "NSScrollerIncrementPage", INT2NUM(NSScrollerIncrementPage));
  rb_define_const(mOSX, "NSScrollerDecrementLine", INT2NUM(NSScrollerDecrementLine));
  rb_define_const(mOSX, "NSScrollerIncrementLine", INT2NUM(NSScrollerIncrementLine));
  rb_define_const(mOSX, "NSScrollerKnobSlot", INT2NUM(NSScrollerKnobSlot));
  rb_define_const(mOSX, "NSScrollerIncrementArrow", INT2NUM(NSScrollerIncrementArrow));
  rb_define_const(mOSX, "NSScrollerDecrementArrow", INT2NUM(NSScrollerDecrementArrow));

}
