#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSWillBecomeMultiThreadedNotification;
static VALUE
osx_NSWillBecomeMultiThreadedNotification(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSDidBecomeSingleThreadedNotification;
static VALUE
osx_NSDidBecomeSingleThreadedNotification(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSThreadWillExitNotification;
static VALUE
osx_NSThreadWillExitNotification(VALUE mdl)
{
  rb_notimplement();
}

void init_NSThread(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSWillBecomeMultiThreadedNotification", osx_NSWillBecomeMultiThreadedNotification, 0);
  rb_define_module_function(mOSX, "NSDidBecomeSingleThreadedNotification", osx_NSDidBecomeSingleThreadedNotification, 0);
  rb_define_module_function(mOSX, "NSThreadWillExitNotification", osx_NSThreadWillExitNotification, 0);
}
