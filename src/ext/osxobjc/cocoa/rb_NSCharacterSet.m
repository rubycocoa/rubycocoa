#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


void init_NSCharacterSet(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSOpenStepUnicodeReservedBase", INT2NUM(NSOpenStepUnicodeReservedBase));

}
