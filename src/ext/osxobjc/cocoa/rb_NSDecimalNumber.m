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
// NSString * const NSDecimalNumberExactnessException;
static VALUE
osx_NSDecimalNumberExactnessException(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSDecimalNumberOverflowException;
static VALUE
osx_NSDecimalNumberOverflowException(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSDecimalNumberUnderflowException;
static VALUE
osx_NSDecimalNumberUnderflowException(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSDecimalNumberDivideByZeroException;
static VALUE
osx_NSDecimalNumberDivideByZeroException(VALUE mdl)
{
  rb_notimplement();
}

void init_NSDecimalNumber(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSDecimalNumberExactnessException", osx_NSDecimalNumberExactnessException, 0);
  rb_define_module_function(mOSX, "NSDecimalNumberOverflowException", osx_NSDecimalNumberOverflowException, 0);
  rb_define_module_function(mOSX, "NSDecimalNumberUnderflowException", osx_NSDecimalNumberUnderflowException, 0);
  rb_define_module_function(mOSX, "NSDecimalNumberDivideByZeroException", osx_NSDecimalNumberDivideByZeroException, 0);
}
