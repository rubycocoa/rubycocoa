#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


void init_NSScriptWhoseTests(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSEqualToComparison", INT2NUM(NSEqualToComparison));
  rb_define_const(mOSX, "NSLessThanOrEqualToComparison", INT2NUM(NSLessThanOrEqualToComparison));
  rb_define_const(mOSX, "NSLessThanComparison", INT2NUM(NSLessThanComparison));
  rb_define_const(mOSX, "NSGreaterThanOrEqualToComparison", INT2NUM(NSGreaterThanOrEqualToComparison));
  rb_define_const(mOSX, "NSGreaterThanComparison", INT2NUM(NSGreaterThanComparison));
  rb_define_const(mOSX, "NSBeginsWithComparison", INT2NUM(NSBeginsWithComparison));
  rb_define_const(mOSX, "NSEndsWithComparison", INT2NUM(NSEndsWithComparison));
  rb_define_const(mOSX, "NSContainsComparison", INT2NUM(NSContainsComparison));

}
