#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSHTTPCookieManagerAcceptPolicyChangedNotification;
static VALUE
osx_NSHTTPCookieManagerAcceptPolicyChangedNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSHTTPCookieManagerAcceptPolicyChangedNotification, "NSHTTPCookieManagerAcceptPolicyChangedNotification", nil);
}

// NSString * const NSHTTPCookieManagerCookiesChangedNotification;
static VALUE
osx_NSHTTPCookieManagerCookiesChangedNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSHTTPCookieManagerCookiesChangedNotification, "NSHTTPCookieManagerCookiesChangedNotification", nil);
}

void init_NSHTTPCookieStorage(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSHTTPCookieAcceptPolicyAlways", INT2NUM(NSHTTPCookieAcceptPolicyAlways));
  rb_define_const(mOSX, "NSHTTPCookieAcceptPolicyNever", INT2NUM(NSHTTPCookieAcceptPolicyNever));
  rb_define_const(mOSX, "NSHTTPCookieAcceptPolicyOnlyFromMainDocumentDomain", INT2NUM(NSHTTPCookieAcceptPolicyOnlyFromMainDocumentDomain));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSHTTPCookieManagerAcceptPolicyChangedNotification", osx_NSHTTPCookieManagerAcceptPolicyChangedNotification, 0);
  rb_define_module_function(mOSX, "NSHTTPCookieManagerCookiesChangedNotification", osx_NSHTTPCookieManagerCookiesChangedNotification, 0);
}
