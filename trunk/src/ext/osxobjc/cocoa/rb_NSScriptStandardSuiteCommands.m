#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


void init_NSScriptStandardSuiteCommands(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSSaveOptionsYes", INT2NUM(NSSaveOptionsYes));
  rb_define_const(mOSX, "NSSaveOptionsNo", INT2NUM(NSSaveOptionsNo));
  rb_define_const(mOSX, "NSSaveOptionsAsk", INT2NUM(NSSaveOptionsAsk));

}
