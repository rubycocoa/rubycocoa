#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


void init_NSSliderCell(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSTickMarkBelow", INT2NUM(NSTickMarkBelow));
  rb_define_const(mOSX, "NSTickMarkAbove", INT2NUM(NSTickMarkAbove));
  rb_define_const(mOSX, "NSTickMarkLeft", INT2NUM(NSTickMarkLeft));
  rb_define_const(mOSX, "NSTickMarkRight", INT2NUM(NSTickMarkRight));

}
