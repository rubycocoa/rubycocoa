#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSBundleDidLoadNotification;
static VALUE
osx_NSBundleDidLoadNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSBundleDidLoadNotification, "NSBundleDidLoadNotification", nil);
}

// NSString * const NSLoadedClasses;
static VALUE
osx_NSLoadedClasses(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSLoadedClasses, "NSLoadedClasses", nil);
}

void init_NSBundle(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSBundleDidLoadNotification", osx_NSBundleDidLoadNotification, 0);
  rb_define_module_function(mOSX, "NSLoadedClasses", osx_NSLoadedClasses, 0);
}
