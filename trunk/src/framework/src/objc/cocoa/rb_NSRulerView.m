#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


void init_NSRulerView(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSHorizontalRuler", INT2NUM(NSHorizontalRuler));
  rb_define_const(mOSX, "NSVerticalRuler", INT2NUM(NSVerticalRuler));

}
