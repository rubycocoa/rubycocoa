#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSLocalNotificationCenterType;
static VALUE
osx_NSLocalNotificationCenterType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSLocalNotificationCenterType, "NSLocalNotificationCenterType", nil);
}

void init_NSDistributedNotificationCenter(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSNotificationSuspensionBehaviorDrop", INT2NUM(NSNotificationSuspensionBehaviorDrop));
  rb_define_const(mOSX, "NSNotificationSuspensionBehaviorCoalesce", INT2NUM(NSNotificationSuspensionBehaviorCoalesce));
  rb_define_const(mOSX, "NSNotificationSuspensionBehaviorHold", INT2NUM(NSNotificationSuspensionBehaviorHold));
  rb_define_const(mOSX, "NSNotificationSuspensionBehaviorDeliverImmediately", INT2NUM(NSNotificationSuspensionBehaviorDeliverImmediately));
  rb_define_const(mOSX, "NSNotificationDeliverImmediately", INT2NUM(NSNotificationDeliverImmediately));
  rb_define_const(mOSX, "NSNotificationPostToAllSessions", INT2NUM(NSNotificationPostToAllSessions));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSLocalNotificationCenterType", osx_NSLocalNotificationCenterType, 0);
}
