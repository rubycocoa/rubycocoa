#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <Foundation/Foundation.h>

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
