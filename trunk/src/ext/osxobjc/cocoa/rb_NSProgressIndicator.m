#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

void init_NSProgressIndicator(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSProgressIndicatorPreferredThickness", INT2NUM(NSProgressIndicatorPreferredThickness));
  rb_define_const(mOSX, "NSProgressIndicatorPreferredSmallThickness", INT2NUM(NSProgressIndicatorPreferredSmallThickness));
  rb_define_const(mOSX, "NSProgressIndicatorPreferredLargeThickness", INT2NUM(NSProgressIndicatorPreferredLargeThickness));
  rb_define_const(mOSX, "NSProgressIndicatorPreferredAquaThickness", INT2NUM(NSProgressIndicatorPreferredAquaThickness));

}
