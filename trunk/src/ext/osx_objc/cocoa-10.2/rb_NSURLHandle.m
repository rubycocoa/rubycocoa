#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * NSHTTPPropertyStatusCodeKey;
static VALUE
osx_NSHTTPPropertyStatusCodeKey(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSHTTPPropertyStatusCodeKey, nil);
}

// NSString * NSHTTPPropertyStatusReasonKey;
static VALUE
osx_NSHTTPPropertyStatusReasonKey(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSHTTPPropertyStatusReasonKey, nil);
}

// NSString * NSHTTPPropertyServerHTTPVersionKey;
static VALUE
osx_NSHTTPPropertyServerHTTPVersionKey(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSHTTPPropertyServerHTTPVersionKey, nil);
}

// NSString * NSHTTPPropertyRedirectionHeadersKey;
static VALUE
osx_NSHTTPPropertyRedirectionHeadersKey(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSHTTPPropertyRedirectionHeadersKey, nil);
}

// NSString * NSHTTPPropertyErrorPageDataKey;
static VALUE
osx_NSHTTPPropertyErrorPageDataKey(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSHTTPPropertyErrorPageDataKey, nil);
}

// NSString * NSHTTPPropertyHTTPProxy;
static VALUE
osx_NSHTTPPropertyHTTPProxy(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSHTTPPropertyHTTPProxy, nil);
}

// NSString * NSFTPPropertyUserLoginKey;
static VALUE
osx_NSFTPPropertyUserLoginKey(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFTPPropertyUserLoginKey, nil);
}

// NSString * NSFTPPropertyUserPasswordKey;
static VALUE
osx_NSFTPPropertyUserPasswordKey(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFTPPropertyUserPasswordKey, nil);
}

// NSString * NSFTPPropertyActiveTransferModeKey;
static VALUE
osx_NSFTPPropertyActiveTransferModeKey(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFTPPropertyActiveTransferModeKey, nil);
}

// NSString * NSFTPPropertyFileOffsetKey;
static VALUE
osx_NSFTPPropertyFileOffsetKey(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFTPPropertyFileOffsetKey, nil);
}

void init_NSURLHandle(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSURLHandleNotLoaded", INT2NUM(NSURLHandleNotLoaded));
  rb_define_const(mOSX, "NSURLHandleLoadSucceeded", INT2NUM(NSURLHandleLoadSucceeded));
  rb_define_const(mOSX, "NSURLHandleLoadInProgress", INT2NUM(NSURLHandleLoadInProgress));
  rb_define_const(mOSX, "NSURLHandleLoadFailed", INT2NUM(NSURLHandleLoadFailed));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSHTTPPropertyStatusCodeKey", osx_NSHTTPPropertyStatusCodeKey, 0);
  rb_define_module_function(mOSX, "NSHTTPPropertyStatusReasonKey", osx_NSHTTPPropertyStatusReasonKey, 0);
  rb_define_module_function(mOSX, "NSHTTPPropertyServerHTTPVersionKey", osx_NSHTTPPropertyServerHTTPVersionKey, 0);
  rb_define_module_function(mOSX, "NSHTTPPropertyRedirectionHeadersKey", osx_NSHTTPPropertyRedirectionHeadersKey, 0);
  rb_define_module_function(mOSX, "NSHTTPPropertyErrorPageDataKey", osx_NSHTTPPropertyErrorPageDataKey, 0);
  rb_define_module_function(mOSX, "NSHTTPPropertyHTTPProxy", osx_NSHTTPPropertyHTTPProxy, 0);
  rb_define_module_function(mOSX, "NSFTPPropertyUserLoginKey", osx_NSFTPPropertyUserLoginKey, 0);
  rb_define_module_function(mOSX, "NSFTPPropertyUserPasswordKey", osx_NSFTPPropertyUserPasswordKey, 0);
  rb_define_module_function(mOSX, "NSFTPPropertyActiveTransferModeKey", osx_NSFTPPropertyActiveTransferModeKey, 0);
  rb_define_module_function(mOSX, "NSFTPPropertyFileOffsetKey", osx_NSFTPPropertyFileOffsetKey, 0);
}
