#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


void init_NSAlert(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSWarningAlertStyle", INT2NUM(NSWarningAlertStyle));
  rb_define_const(mOSX, "NSInformationalAlertStyle", INT2NUM(NSInformationalAlertStyle));
  rb_define_const(mOSX, "NSCriticalAlertStyle", INT2NUM(NSCriticalAlertStyle));
  rb_define_const(mOSX, "NSAlertFirstButtonReturn", INT2NUM(NSAlertFirstButtonReturn));
  rb_define_const(mOSX, "NSAlertSecondButtonReturn", INT2NUM(NSAlertSecondButtonReturn));
  rb_define_const(mOSX, "NSAlertThirdButtonReturn", INT2NUM(NSAlertThirdButtonReturn));

}
