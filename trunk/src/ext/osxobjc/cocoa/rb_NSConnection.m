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
// NSString * const NSConnectionReplyMode;
static VALUE
osx_NSConnectionReplyMode(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSConnectionDidDieNotification;
static VALUE
osx_NSConnectionDidDieNotification(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSFailedAuthenticationException;
static VALUE
osx_NSFailedAuthenticationException(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSConnectionDidInitializeNotification;
static VALUE
osx_NSConnectionDidInitializeNotification(VALUE mdl)
{
  rb_notimplement();
}

void init_NSConnection(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSConnectionReplyMode", osx_NSConnectionReplyMode, 0);
  rb_define_module_function(mOSX, "NSConnectionDidDieNotification", osx_NSConnectionDidDieNotification, 0);
  rb_define_module_function(mOSX, "NSFailedAuthenticationException", osx_NSFailedAuthenticationException, 0);
  rb_define_module_function(mOSX, "NSConnectionDidInitializeNotification", osx_NSConnectionDidInitializeNotification, 0);
}
