#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

static void
rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index)
{
  if (!rbobj_to_ocdata(rbarg, octype, nsarg)) {
    if (pool) [pool release];
    rb_raise(rb_eArgError, "arg #%d cannot convert to nsobj.", index);
  }
}

static VALUE
nsresult_to_rbresult(int octype, const void* nsresult, id pool)
{
  VALUE rbresult;
  if (octype == _C_ID) {
    rbresult = ocobj_new_with_ocid(*(id*)nsresult);
  }
  else {
    if (!ocdata_to_rbobj(octype, nsresult, &rbresult)) {
      if (pool) [pool release];
      rb_raise(rb_eRuntimeError, "result cannot convert to rbobj.");
    }
  }
  return rbresult;
}


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
