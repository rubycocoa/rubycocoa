#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSHTTPCookieName;
static VALUE
osx_NSHTTPCookieName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSHTTPCookieName, "NSHTTPCookieName", nil);
}

// NSString * const NSHTTPCookieValue;
static VALUE
osx_NSHTTPCookieValue(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSHTTPCookieValue, "NSHTTPCookieValue", nil);
}

// NSString * const NSHTTPCookieOriginURL;
static VALUE
osx_NSHTTPCookieOriginURL(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSHTTPCookieOriginURL, "NSHTTPCookieOriginURL", nil);
}

// NSString * const NSHTTPCookieVersion;
static VALUE
osx_NSHTTPCookieVersion(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSHTTPCookieVersion, "NSHTTPCookieVersion", nil);
}

// NSString * const NSHTTPCookieDomain;
static VALUE
osx_NSHTTPCookieDomain(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSHTTPCookieDomain, "NSHTTPCookieDomain", nil);
}

// NSString * const NSHTTPCookiePath;
static VALUE
osx_NSHTTPCookiePath(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSHTTPCookiePath, "NSHTTPCookiePath", nil);
}

// NSString * const NSHTTPCookieSecure;
static VALUE
osx_NSHTTPCookieSecure(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSHTTPCookieSecure, "NSHTTPCookieSecure", nil);
}

// NSString * const NSHTTPCookieExpires;
static VALUE
osx_NSHTTPCookieExpires(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSHTTPCookieExpires, "NSHTTPCookieExpires", nil);
}

// NSString * const NSHTTPCookieComment;
static VALUE
osx_NSHTTPCookieComment(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSHTTPCookieComment, "NSHTTPCookieComment", nil);
}

// NSString * const NSHTTPCookieCommentURL;
static VALUE
osx_NSHTTPCookieCommentURL(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSHTTPCookieCommentURL, "NSHTTPCookieCommentURL", nil);
}

// NSString * const NSHTTPCookieDiscard;
static VALUE
osx_NSHTTPCookieDiscard(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSHTTPCookieDiscard, "NSHTTPCookieDiscard", nil);
}

// NSString * const NSHTTPCookieMaximumAge;
static VALUE
osx_NSHTTPCookieMaximumAge(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSHTTPCookieMaximumAge, "NSHTTPCookieMaximumAge", nil);
}

// NSString * const NSHTTPCookiePort;
static VALUE
osx_NSHTTPCookiePort(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSHTTPCookiePort, "NSHTTPCookiePort", nil);
}

void init_NSHTTPCookie(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSHTTPCookieName", osx_NSHTTPCookieName, 0);
  rb_define_module_function(mOSX, "NSHTTPCookieValue", osx_NSHTTPCookieValue, 0);
  rb_define_module_function(mOSX, "NSHTTPCookieOriginURL", osx_NSHTTPCookieOriginURL, 0);
  rb_define_module_function(mOSX, "NSHTTPCookieVersion", osx_NSHTTPCookieVersion, 0);
  rb_define_module_function(mOSX, "NSHTTPCookieDomain", osx_NSHTTPCookieDomain, 0);
  rb_define_module_function(mOSX, "NSHTTPCookiePath", osx_NSHTTPCookiePath, 0);
  rb_define_module_function(mOSX, "NSHTTPCookieSecure", osx_NSHTTPCookieSecure, 0);
  rb_define_module_function(mOSX, "NSHTTPCookieExpires", osx_NSHTTPCookieExpires, 0);
  rb_define_module_function(mOSX, "NSHTTPCookieComment", osx_NSHTTPCookieComment, 0);
  rb_define_module_function(mOSX, "NSHTTPCookieCommentURL", osx_NSHTTPCookieCommentURL, 0);
  rb_define_module_function(mOSX, "NSHTTPCookieDiscard", osx_NSHTTPCookieDiscard, 0);
  rb_define_module_function(mOSX, "NSHTTPCookieMaximumAge", osx_NSHTTPCookieMaximumAge, 0);
  rb_define_module_function(mOSX, "NSHTTPCookiePort", osx_NSHTTPCookiePort, 0);
}
