#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSWillBecomeMultiThreadedNotification;
static VALUE
osx_NSWillBecomeMultiThreadedNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWillBecomeMultiThreadedNotification, "NSWillBecomeMultiThreadedNotification", nil);
}

// NSString * const NSDidBecomeSingleThreadedNotification;
static VALUE
osx_NSDidBecomeSingleThreadedNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSDidBecomeSingleThreadedNotification, "NSDidBecomeSingleThreadedNotification", nil);
}

// NSString * const NSThreadWillExitNotification;
static VALUE
osx_NSThreadWillExitNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSThreadWillExitNotification, "NSThreadWillExitNotification", nil);
}

void init_NSThread(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSWillBecomeMultiThreadedNotification", osx_NSWillBecomeMultiThreadedNotification, 0);
  rb_define_module_function(mOSX, "NSDidBecomeSingleThreadedNotification", osx_NSDidBecomeSingleThreadedNotification, 0);
  rb_define_module_function(mOSX, "NSThreadWillExitNotification", osx_NSThreadWillExitNotification, 0);
}
