#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSConnectionReplyMode;
static VALUE
osx_NSConnectionReplyMode(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSConnectionReplyMode, "NSConnectionReplyMode", nil);
}

// NSString * const NSConnectionDidDieNotification;
static VALUE
osx_NSConnectionDidDieNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSConnectionDidDieNotification, "NSConnectionDidDieNotification", nil);
}

// NSString * const NSFailedAuthenticationException;
static VALUE
osx_NSFailedAuthenticationException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFailedAuthenticationException, "NSFailedAuthenticationException", nil);
}

// NSString * const NSConnectionDidInitializeNotification;
static VALUE
osx_NSConnectionDidInitializeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSConnectionDidInitializeNotification, "NSConnectionDidInitializeNotification", nil);
}

void init_NSConnection(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSConnectionReplyMode", osx_NSConnectionReplyMode, 0);
  rb_define_module_function(mOSX, "NSConnectionDidDieNotification", osx_NSConnectionDidDieNotification, 0);
  rb_define_module_function(mOSX, "NSFailedAuthenticationException", osx_NSFailedAuthenticationException, 0);
  rb_define_module_function(mOSX, "NSConnectionDidInitializeNotification", osx_NSConnectionDidInitializeNotification, 0);
}
