#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <Foundation/Foundation.h>

  /**** constants ****/
// NSString * const NSLocalNotificationCenterType;
static VALUE
osx_NSLocalNotificationCenterType(VALUE mdl)
{
  rb_notimplement();
}

void init_NSDistributedNotificationCenter(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSNotificationSuspensionBehaviorDrop", INT2NUM(NSNotificationSuspensionBehaviorDrop));
  rb_define_const(mOSX, "NSNotificationSuspensionBehaviorCoalesce", INT2NUM(NSNotificationSuspensionBehaviorCoalesce));
  rb_define_const(mOSX, "NSNotificationSuspensionBehaviorHold", INT2NUM(NSNotificationSuspensionBehaviorHold));
  rb_define_const(mOSX, "NSNotificationSuspensionBehaviorDeliverImmediately", INT2NUM(NSNotificationSuspensionBehaviorDeliverImmediately));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSLocalNotificationCenterType", osx_NSLocalNotificationCenterType, 0);
}
