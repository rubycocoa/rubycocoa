#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSDecimalNumberExactnessException;
static VALUE
osx_NSDecimalNumberExactnessException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSDecimalNumberExactnessException, "NSDecimalNumberExactnessException", nil);
}

// NSString * const NSDecimalNumberOverflowException;
static VALUE
osx_NSDecimalNumberOverflowException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSDecimalNumberOverflowException, "NSDecimalNumberOverflowException", nil);
}

// NSString * const NSDecimalNumberUnderflowException;
static VALUE
osx_NSDecimalNumberUnderflowException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSDecimalNumberUnderflowException, "NSDecimalNumberUnderflowException", nil);
}

// NSString * const NSDecimalNumberDivideByZeroException;
static VALUE
osx_NSDecimalNumberDivideByZeroException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSDecimalNumberDivideByZeroException, "NSDecimalNumberDivideByZeroException", nil);
}

void init_NSDecimalNumber(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSDecimalNumberExactnessException", osx_NSDecimalNumberExactnessException, 0);
  rb_define_module_function(mOSX, "NSDecimalNumberOverflowException", osx_NSDecimalNumberOverflowException, 0);
  rb_define_module_function(mOSX, "NSDecimalNumberUnderflowException", osx_NSDecimalNumberUnderflowException, 0);
  rb_define_module_function(mOSX, "NSDecimalNumberDivideByZeroException", osx_NSDecimalNumberDivideByZeroException, 0);
}
