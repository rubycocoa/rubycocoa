#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSLocalNotificationCenterType;
static VALUE
osx_NSLocalNotificationCenterType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSLocalNotificationCenterType, nil);
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
