#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// const double NSAppleEventTimeOutDefault;
static VALUE
osx_NSAppleEventTimeOutDefault(VALUE mdl)
{
  return nsresult_to_rbresult(_C_DBL, &NSAppleEventTimeOutDefault, nil);
}

// const double NSAppleEventTimeOutNone;
static VALUE
osx_NSAppleEventTimeOutNone(VALUE mdl)
{
  return nsresult_to_rbresult(_C_DBL, &NSAppleEventTimeOutNone, nil);
}

// NSString * NSAppleEventManagerWillProcessFirstEventNotification;
static VALUE
osx_NSAppleEventManagerWillProcessFirstEventNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAppleEventManagerWillProcessFirstEventNotification, nil);
}

void init_NSAppleEventManager(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSAppleEventTimeOutDefault", osx_NSAppleEventTimeOutDefault, 0);
  rb_define_module_function(mOSX, "NSAppleEventTimeOutNone", osx_NSAppleEventTimeOutNone, 0);
  rb_define_module_function(mOSX, "NSAppleEventManagerWillProcessFirstEventNotification", osx_NSAppleEventManagerWillProcessFirstEventNotification, 0);
}
