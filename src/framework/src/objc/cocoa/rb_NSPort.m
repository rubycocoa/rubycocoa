#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSPortDidBecomeInvalidNotification;
static VALUE
osx_NSPortDidBecomeInvalidNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSPortDidBecomeInvalidNotification, "NSPortDidBecomeInvalidNotification", nil);
}

void init_NSPort(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSPortDidBecomeInvalidNotification", osx_NSPortDidBecomeInvalidNotification, 0);
}
