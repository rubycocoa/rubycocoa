#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSInvalidArchiveOperationException;
static VALUE
osx_NSInvalidArchiveOperationException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSInvalidArchiveOperationException, "NSInvalidArchiveOperationException", nil);
}

// NSString * const NSInvalidUnarchiveOperationException;
static VALUE
osx_NSInvalidUnarchiveOperationException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSInvalidUnarchiveOperationException, "NSInvalidUnarchiveOperationException", nil);
}

void init_NSKeyedArchiver(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSInvalidArchiveOperationException", osx_NSInvalidArchiveOperationException, 0);
  rb_define_module_function(mOSX, "NSInvalidUnarchiveOperationException", osx_NSInvalidUnarchiveOperationException, 0);
}
