#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

void init_NSSliderCell(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSTickMarkBelow", INT2NUM(NSTickMarkBelow));
  rb_define_const(mOSX, "NSTickMarkAbove", INT2NUM(NSTickMarkAbove));
  rb_define_const(mOSX, "NSTickMarkLeft", INT2NUM(NSTickMarkLeft));
  rb_define_const(mOSX, "NSTickMarkRight", INT2NUM(NSTickMarkRight));

}
