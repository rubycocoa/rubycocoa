#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** functions ****/
// void NSDecimalCopy ( NSDecimal * destination , const NSDecimal * source );
static VALUE
osx_NSDecimalCopy(VALUE mdl, VALUE a0, VALUE a1)
{

  NSDecimal * ns_a0;
  const NSDecimal * ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSDecimalCopy", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSDecimalCopy", pool, 1);

NS_DURING
  NSDecimalCopy(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSDecimalCopy", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSDecimalCompact ( NSDecimal * number );
static VALUE
osx_NSDecimalCompact(VALUE mdl, VALUE a0)
{

  NSDecimal * ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSDecimalCompact", pool, 0);

NS_DURING
  NSDecimalCompact(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSDecimalCompact", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// NSComparisonResult NSDecimalCompare ( const NSDecimal * leftOperand , const NSDecimal * rightOperand );
static VALUE
osx_NSDecimalCompare(VALUE mdl, VALUE a0, VALUE a1)
{
  NSComparisonResult ns_result;

  const NSDecimal * ns_a0;
  const NSDecimal * ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSDecimalCompare", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSDecimalCompare", pool, 1);

NS_DURING
  ns_result = NSDecimalCompare(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSDecimalCompare", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, "NSDecimalCompare", pool);
  [pool release];
  return rb_result;
}

// void NSDecimalRound ( NSDecimal * result , const NSDecimal * number , int scale , NSRoundingMode roundingMode );
static VALUE
osx_NSDecimalRound(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3)
{

  NSDecimal * ns_a0;
  const NSDecimal * ns_a1;
  int ns_a2;
  NSRoundingMode ns_a3;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSDecimalRound", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSDecimalRound", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_INT, &ns_a2, "NSDecimalRound", pool, 2);
  /* a3 */
  rbarg_to_nsarg(a3, _C_INT, &ns_a3, "NSDecimalRound", pool, 3);

NS_DURING
  NSDecimalRound(ns_a0, ns_a1, ns_a2, ns_a3);
NS_HANDLER
  excp = oc_err_new ("NSDecimalRound", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// NSCalculationError NSDecimalNormalize ( NSDecimal * number1 , NSDecimal * number2 , NSRoundingMode roundingMode );
static VALUE
osx_NSDecimalNormalize(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{
  NSCalculationError ns_result;

  NSDecimal * ns_a0;
  NSDecimal * ns_a1;
  NSRoundingMode ns_a2;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSDecimalNormalize", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSDecimalNormalize", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_INT, &ns_a2, "NSDecimalNormalize", pool, 2);

NS_DURING
  ns_result = NSDecimalNormalize(ns_a0, ns_a1, ns_a2);
NS_HANDLER
  excp = oc_err_new ("NSDecimalNormalize", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, "NSDecimalNormalize", pool);
  [pool release];
  return rb_result;
}

// NSCalculationError NSDecimalAdd ( NSDecimal * result , const NSDecimal * leftOperand , const NSDecimal * rightOperand , NSRoundingMode roundingMode );
static VALUE
osx_NSDecimalAdd(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3)
{
  NSCalculationError ns_result;

  NSDecimal * ns_a0;
  const NSDecimal * ns_a1;
  const NSDecimal * ns_a2;
  NSRoundingMode ns_a3;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSDecimalAdd", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSDecimalAdd", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _PRIV_C_PTR, &ns_a2, "NSDecimalAdd", pool, 2);
  /* a3 */
  rbarg_to_nsarg(a3, _C_INT, &ns_a3, "NSDecimalAdd", pool, 3);

NS_DURING
  ns_result = NSDecimalAdd(ns_a0, ns_a1, ns_a2, ns_a3);
NS_HANDLER
  excp = oc_err_new ("NSDecimalAdd", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, "NSDecimalAdd", pool);
  [pool release];
  return rb_result;
}

// NSCalculationError NSDecimalSubtract ( NSDecimal * result , const NSDecimal * leftOperand , const NSDecimal * rightOperand , NSRoundingMode roundingMode );
static VALUE
osx_NSDecimalSubtract(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3)
{
  NSCalculationError ns_result;

  NSDecimal * ns_a0;
  const NSDecimal * ns_a1;
  const NSDecimal * ns_a2;
  NSRoundingMode ns_a3;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSDecimalSubtract", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSDecimalSubtract", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _PRIV_C_PTR, &ns_a2, "NSDecimalSubtract", pool, 2);
  /* a3 */
  rbarg_to_nsarg(a3, _C_INT, &ns_a3, "NSDecimalSubtract", pool, 3);

NS_DURING
  ns_result = NSDecimalSubtract(ns_a0, ns_a1, ns_a2, ns_a3);
NS_HANDLER
  excp = oc_err_new ("NSDecimalSubtract", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, "NSDecimalSubtract", pool);
  [pool release];
  return rb_result;
}

// NSCalculationError NSDecimalMultiply ( NSDecimal * result , const NSDecimal * leftOperand , const NSDecimal * rightOperand , NSRoundingMode roundingMode );
static VALUE
osx_NSDecimalMultiply(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3)
{
  NSCalculationError ns_result;

  NSDecimal * ns_a0;
  const NSDecimal * ns_a1;
  const NSDecimal * ns_a2;
  NSRoundingMode ns_a3;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSDecimalMultiply", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSDecimalMultiply", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _PRIV_C_PTR, &ns_a2, "NSDecimalMultiply", pool, 2);
  /* a3 */
  rbarg_to_nsarg(a3, _C_INT, &ns_a3, "NSDecimalMultiply", pool, 3);

NS_DURING
  ns_result = NSDecimalMultiply(ns_a0, ns_a1, ns_a2, ns_a3);
NS_HANDLER
  excp = oc_err_new ("NSDecimalMultiply", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, "NSDecimalMultiply", pool);
  [pool release];
  return rb_result;
}

// NSCalculationError NSDecimalDivide ( NSDecimal * result , const NSDecimal * leftOperand , const NSDecimal * rightOperand , NSRoundingMode roundingMode );
static VALUE
osx_NSDecimalDivide(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3)
{
  NSCalculationError ns_result;

  NSDecimal * ns_a0;
  const NSDecimal * ns_a1;
  const NSDecimal * ns_a2;
  NSRoundingMode ns_a3;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSDecimalDivide", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSDecimalDivide", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _PRIV_C_PTR, &ns_a2, "NSDecimalDivide", pool, 2);
  /* a3 */
  rbarg_to_nsarg(a3, _C_INT, &ns_a3, "NSDecimalDivide", pool, 3);

NS_DURING
  ns_result = NSDecimalDivide(ns_a0, ns_a1, ns_a2, ns_a3);
NS_HANDLER
  excp = oc_err_new ("NSDecimalDivide", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, "NSDecimalDivide", pool);
  [pool release];
  return rb_result;
}

// NSCalculationError NSDecimalPower ( NSDecimal * result , const NSDecimal * number , unsigned power , NSRoundingMode roundingMode );
static VALUE
osx_NSDecimalPower(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3)
{
  NSCalculationError ns_result;

  NSDecimal * ns_a0;
  const NSDecimal * ns_a1;
  unsigned ns_a2;
  NSRoundingMode ns_a3;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSDecimalPower", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSDecimalPower", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_UINT, &ns_a2, "NSDecimalPower", pool, 2);
  /* a3 */
  rbarg_to_nsarg(a3, _C_INT, &ns_a3, "NSDecimalPower", pool, 3);

NS_DURING
  ns_result = NSDecimalPower(ns_a0, ns_a1, ns_a2, ns_a3);
NS_HANDLER
  excp = oc_err_new ("NSDecimalPower", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, "NSDecimalPower", pool);
  [pool release];
  return rb_result;
}

// NSCalculationError NSDecimalMultiplyByPowerOf10 ( NSDecimal * result , const NSDecimal * number , short power , NSRoundingMode roundingMode );
static VALUE
osx_NSDecimalMultiplyByPowerOf10(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3)
{
  NSCalculationError ns_result;

  NSDecimal * ns_a0;
  const NSDecimal * ns_a1;
  short ns_a2;
  NSRoundingMode ns_a3;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSDecimalMultiplyByPowerOf10", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSDecimalMultiplyByPowerOf10", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_SHT, &ns_a2, "NSDecimalMultiplyByPowerOf10", pool, 2);
  /* a3 */
  rbarg_to_nsarg(a3, _C_INT, &ns_a3, "NSDecimalMultiplyByPowerOf10", pool, 3);

NS_DURING
  ns_result = NSDecimalMultiplyByPowerOf10(ns_a0, ns_a1, ns_a2, ns_a3);
NS_HANDLER
  excp = oc_err_new ("NSDecimalMultiplyByPowerOf10", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, "NSDecimalMultiplyByPowerOf10", pool);
  [pool release];
  return rb_result;
}

// NSString * NSDecimalString ( const NSDecimal * dcm , NSDictionary * locale );
static VALUE
osx_NSDecimalString(VALUE mdl, VALUE a0, VALUE a1)
{
  NSString * ns_result;

  const NSDecimal * ns_a0;
  NSDictionary * ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSDecimalString", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_ID, &ns_a1, "NSDecimalString", pool, 1);

NS_DURING
  ns_result = NSDecimalString(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSDecimalString", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, "NSDecimalString", pool);
  [pool release];
  return rb_result;
}

void init_NSDecimal(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSRoundPlain", INT2NUM(NSRoundPlain));
  rb_define_const(mOSX, "NSRoundDown", INT2NUM(NSRoundDown));
  rb_define_const(mOSX, "NSRoundUp", INT2NUM(NSRoundUp));
  rb_define_const(mOSX, "NSRoundBankers", INT2NUM(NSRoundBankers));
  rb_define_const(mOSX, "NSCalculationNoError", INT2NUM(NSCalculationNoError));
  rb_define_const(mOSX, "NSCalculationLossOfPrecision", INT2NUM(NSCalculationLossOfPrecision));
  rb_define_const(mOSX, "NSCalculationUnderflow", INT2NUM(NSCalculationUnderflow));
  rb_define_const(mOSX, "NSCalculationOverflow", INT2NUM(NSCalculationOverflow));
  rb_define_const(mOSX, "NSCalculationDivideByZero", INT2NUM(NSCalculationDivideByZero));

  /**** functions ****/
  rb_define_module_function(mOSX, "NSDecimalCopy", osx_NSDecimalCopy, 2);
  rb_define_module_function(mOSX, "NSDecimalCompact", osx_NSDecimalCompact, 1);
  rb_define_module_function(mOSX, "NSDecimalCompare", osx_NSDecimalCompare, 2);
  rb_define_module_function(mOSX, "NSDecimalRound", osx_NSDecimalRound, 4);
  rb_define_module_function(mOSX, "NSDecimalNormalize", osx_NSDecimalNormalize, 3);
  rb_define_module_function(mOSX, "NSDecimalAdd", osx_NSDecimalAdd, 4);
  rb_define_module_function(mOSX, "NSDecimalSubtract", osx_NSDecimalSubtract, 4);
  rb_define_module_function(mOSX, "NSDecimalMultiply", osx_NSDecimalMultiply, 4);
  rb_define_module_function(mOSX, "NSDecimalDivide", osx_NSDecimalDivide, 4);
  rb_define_module_function(mOSX, "NSDecimalPower", osx_NSDecimalPower, 4);
  rb_define_module_function(mOSX, "NSDecimalMultiplyByPowerOf10", osx_NSDecimalMultiplyByPowerOf10, 4);
  rb_define_module_function(mOSX, "NSDecimalString", osx_NSDecimalString, 2);
}
