#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSURLProtectionSpaceHTTPProxy;
static VALUE
osx_NSURLProtectionSpaceHTTPProxy(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSURLProtectionSpaceHTTPProxy, "NSURLProtectionSpaceHTTPProxy", nil);
}

// NSString * const NSURLProtectionSpaceHTTPSProxy;
static VALUE
osx_NSURLProtectionSpaceHTTPSProxy(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSURLProtectionSpaceHTTPSProxy, "NSURLProtectionSpaceHTTPSProxy", nil);
}

// NSString * const NSURLProtectionSpaceFTPProxy;
static VALUE
osx_NSURLProtectionSpaceFTPProxy(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSURLProtectionSpaceFTPProxy, "NSURLProtectionSpaceFTPProxy", nil);
}

// NSString * const NSURLProtectionSpaceSOCKSProxy;
static VALUE
osx_NSURLProtectionSpaceSOCKSProxy(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSURLProtectionSpaceSOCKSProxy, "NSURLProtectionSpaceSOCKSProxy", nil);
}

// NSString * const NSURLAuthenticationMethodDefault;
static VALUE
osx_NSURLAuthenticationMethodDefault(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSURLAuthenticationMethodDefault, "NSURLAuthenticationMethodDefault", nil);
}

// NSString * const NSURLAuthenticationMethodHTTPBasic;
static VALUE
osx_NSURLAuthenticationMethodHTTPBasic(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSURLAuthenticationMethodHTTPBasic, "NSURLAuthenticationMethodHTTPBasic", nil);
}

// NSString * const NSURLAuthenticationMethodHTTPDigest;
static VALUE
osx_NSURLAuthenticationMethodHTTPDigest(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSURLAuthenticationMethodHTTPDigest, "NSURLAuthenticationMethodHTTPDigest", nil);
}

// NSString * const NSURLAuthenticationMethodHTMLForm;
static VALUE
osx_NSURLAuthenticationMethodHTMLForm(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSURLAuthenticationMethodHTMLForm, "NSURLAuthenticationMethodHTMLForm", nil);
}

void init_NSURLProtectionSpace(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSURLProtectionSpaceHTTPProxy", osx_NSURLProtectionSpaceHTTPProxy, 0);
  rb_define_module_function(mOSX, "NSURLProtectionSpaceHTTPSProxy", osx_NSURLProtectionSpaceHTTPSProxy, 0);
  rb_define_module_function(mOSX, "NSURLProtectionSpaceFTPProxy", osx_NSURLProtectionSpaceFTPProxy, 0);
  rb_define_module_function(mOSX, "NSURLProtectionSpaceSOCKSProxy", osx_NSURLProtectionSpaceSOCKSProxy, 0);
  rb_define_module_function(mOSX, "NSURLAuthenticationMethodDefault", osx_NSURLAuthenticationMethodDefault, 0);
  rb_define_module_function(mOSX, "NSURLAuthenticationMethodHTTPBasic", osx_NSURLAuthenticationMethodHTTPBasic, 0);
  rb_define_module_function(mOSX, "NSURLAuthenticationMethodHTTPDigest", osx_NSURLAuthenticationMethodHTTPDigest, 0);
  rb_define_module_function(mOSX, "NSURLAuthenticationMethodHTMLForm", osx_NSURLAuthenticationMethodHTMLForm, 0);
}
