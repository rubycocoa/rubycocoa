#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <Foundation/Foundation.h>

  /**** constants ****/
// NSString *NSHTTPPropertyStatusCodeKey;
static VALUE
osx_NSHTTPPropertyStatusCodeKey(VALUE mdl)
{
  return ocobj_new_with_ocid(NSHTTPPropertyStatusCodeKey);
}

// NSString *NSHTTPPropertyStatusReasonKey;
static VALUE
osx_NSHTTPPropertyStatusReasonKey(VALUE mdl)
{
  return ocobj_new_with_ocid(NSHTTPPropertyStatusReasonKey);
}

// NSString *NSHTTPPropertyServerHTTPVersionKey;
static VALUE
osx_NSHTTPPropertyServerHTTPVersionKey(VALUE mdl)
{
  return ocobj_new_with_ocid(NSHTTPPropertyServerHTTPVersionKey);
}

// NSString *NSHTTPPropertyRedirectionHeadersKey;
static VALUE
osx_NSHTTPPropertyRedirectionHeadersKey(VALUE mdl)
{
  return ocobj_new_with_ocid(NSHTTPPropertyRedirectionHeadersKey);
}

// NSString *NSHTTPPropertyErrorPageDataKey;
static VALUE
osx_NSHTTPPropertyErrorPageDataKey(VALUE mdl)
{
  return ocobj_new_with_ocid(NSHTTPPropertyErrorPageDataKey);
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
}
