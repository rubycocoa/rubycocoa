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
// NSString *NSHTTPPropertyStatusCodeKey;
static VALUE
osx_NSHTTPPropertyStatusCodeKey(VALUE mdl)
{
  NSString * ns_result = NSHTTPPropertyStatusCodeKey;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSHTTPPropertyStatusReasonKey;
static VALUE
osx_NSHTTPPropertyStatusReasonKey(VALUE mdl)
{
  NSString * ns_result = NSHTTPPropertyStatusReasonKey;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSHTTPPropertyServerHTTPVersionKey;
static VALUE
osx_NSHTTPPropertyServerHTTPVersionKey(VALUE mdl)
{
  NSString * ns_result = NSHTTPPropertyServerHTTPVersionKey;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSHTTPPropertyRedirectionHeadersKey;
static VALUE
osx_NSHTTPPropertyRedirectionHeadersKey(VALUE mdl)
{
  NSString * ns_result = NSHTTPPropertyRedirectionHeadersKey;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSHTTPPropertyErrorPageDataKey;
static VALUE
osx_NSHTTPPropertyErrorPageDataKey(VALUE mdl)
{
  NSString * ns_result = NSHTTPPropertyErrorPageDataKey;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
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
