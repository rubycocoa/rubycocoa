#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


void init_NSNotificationQueue(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSPostWhenIdle", INT2NUM(NSPostWhenIdle));
  rb_define_const(mOSX, "NSPostASAP", INT2NUM(NSPostASAP));
  rb_define_const(mOSX, "NSPostNow", INT2NUM(NSPostNow));
  rb_define_const(mOSX, "NSNotificationNoCoalescing", INT2NUM(NSNotificationNoCoalescing));
  rb_define_const(mOSX, "NSNotificationCoalescingOnName", INT2NUM(NSNotificationCoalescingOnName));
  rb_define_const(mOSX, "NSNotificationCoalescingOnSender", INT2NUM(NSNotificationCoalescingOnSender));

}
