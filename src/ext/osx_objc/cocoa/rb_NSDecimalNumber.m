#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
#define VA_MAX 4


  /**** constants ****/
// NSString * const NSDecimalNumberExactnessException;
static VALUE
osx_NSDecimalNumberExactnessException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSDecimalNumberExactnessException, nil);
}

// NSString * const NSDecimalNumberOverflowException;
static VALUE
osx_NSDecimalNumberOverflowException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSDecimalNumberOverflowException, nil);
}

// NSString * const NSDecimalNumberUnderflowException;
static VALUE
osx_NSDecimalNumberUnderflowException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSDecimalNumberUnderflowException, nil);
}

// NSString * const NSDecimalNumberDivideByZeroException;
static VALUE
osx_NSDecimalNumberDivideByZeroException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSDecimalNumberDivideByZeroException, nil);
}

void init_NSDecimalNumber(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSDecimalNumberExactnessException", osx_NSDecimalNumberExactnessException, 0);
  rb_define_module_function(mOSX, "NSDecimalNumberOverflowException", osx_NSDecimalNumberOverflowException, 0);
  rb_define_module_function(mOSX, "NSDecimalNumberUnderflowException", osx_NSDecimalNumberUnderflowException, 0);
  rb_define_module_function(mOSX, "NSDecimalNumberDivideByZeroException", osx_NSDecimalNumberDivideByZeroException, 0);
}
