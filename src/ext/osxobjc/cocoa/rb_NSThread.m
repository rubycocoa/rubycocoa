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
