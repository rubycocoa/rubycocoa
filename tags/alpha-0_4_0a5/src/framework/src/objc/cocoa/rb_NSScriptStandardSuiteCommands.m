#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


void init_NSScriptStandardSuiteCommands(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSSaveOptionsYes", INT2NUM(NSSaveOptionsYes));
  rb_define_const(mOSX, "NSSaveOptionsNo", INT2NUM(NSSaveOptionsNo));
  rb_define_const(mOSX, "NSSaveOptionsAsk", INT2NUM(NSSaveOptionsAsk));

}
