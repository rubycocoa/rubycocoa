#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);


void init_NSProgressIndicator(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSProgressIndicatorPreferredThickness", INT2NUM(NSProgressIndicatorPreferredThickness));
  rb_define_const(mOSX, "NSProgressIndicatorPreferredSmallThickness", INT2NUM(NSProgressIndicatorPreferredSmallThickness));
  rb_define_const(mOSX, "NSProgressIndicatorPreferredLargeThickness", INT2NUM(NSProgressIndicatorPreferredLargeThickness));
  rb_define_const(mOSX, "NSProgressIndicatorPreferredAquaThickness", INT2NUM(NSProgressIndicatorPreferredAquaThickness));

}
