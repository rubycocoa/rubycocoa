#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSURLErrorDomain;
static VALUE
osx_NSURLErrorDomain(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSURLErrorDomain, "NSURLErrorDomain", nil);
}

// NSString * const NSErrorFailingURLStringKey;
static VALUE
osx_NSErrorFailingURLStringKey(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSErrorFailingURLStringKey, "NSErrorFailingURLStringKey", nil);
}

void init_NSURLError(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSURLErrorDomain", osx_NSURLErrorDomain, 0);
  rb_define_module_function(mOSX, "NSErrorFailingURLStringKey", osx_NSErrorFailingURLStringKey, 0);
}
