#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** functions ****/
// void NSDecimalCopy ( NSDecimal * destination , const NSDecimal * source );
static VALUE
osx_NSDecimalCopy(VALUE mdl, VALUE a0, VALUE a1)
{

  NSDecimal * ns_a0;
  const NSDecimal * ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, pool, 1);

  NSDecimalCopy(ns_a0, ns_a1);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSDecimalCompact ( NSDecimal * number );
static VALUE
osx_NSDecimalCompact(VALUE mdl, VALUE a0)
{

  NSDecimal * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, pool, 0);

  NSDecimalCompact(ns_a0);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// NSComparisonResult NSDecimalCompare ( const NSDecimal * leftOperand , const NSDecimal * rightOperand );
static VALUE
osx_NSDecimalCompare(VALUE mdl, VALUE a0, VALUE a1)
{
  rb_notimplement();
}

// void NSDecimalRound ( NSDecimal * result , const NSDecimal * number , int scale , NSRoundingMode roundingMode );
static VALUE
osx_NSDecimalRound(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3)
{

  NSDecimal * ns_a0;
  const NSDecimal * ns_a1;
  int ns_a2;
  NSRoundingMode ns_a3;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_INT, &ns_a2, pool, 2);
  /* a3 */
  rbarg_to_nsarg(a3, _C_INT, &ns_a3, pool, 3);

  NSDecimalRound(ns_a0, ns_a1, ns_a2, ns_a3);

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

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_INT, &ns_a2, pool, 2);

  ns_result = NSDecimalNormalize(ns_a0, ns_a1, ns_a2);

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, pool);
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

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _PRIV_C_PTR, &ns_a2, pool, 2);
  /* a3 */
  rbarg_to_nsarg(a3, _C_INT, &ns_a3, pool, 3);

  ns_result = NSDecimalAdd(ns_a0, ns_a1, ns_a2, ns_a3);

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, pool);
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

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _PRIV_C_PTR, &ns_a2, pool, 2);
  /* a3 */
  rbarg_to_nsarg(a3, _C_INT, &ns_a3, pool, 3);

  ns_result = NSDecimalSubtract(ns_a0, ns_a1, ns_a2, ns_a3);

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, pool);
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

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _PRIV_C_PTR, &ns_a2, pool, 2);
  /* a3 */
  rbarg_to_nsarg(a3, _C_INT, &ns_a3, pool, 3);

  ns_result = NSDecimalMultiply(ns_a0, ns_a1, ns_a2, ns_a3);

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, pool);
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

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _PRIV_C_PTR, &ns_a2, pool, 2);
  /* a3 */
  rbarg_to_nsarg(a3, _C_INT, &ns_a3, pool, 3);

  ns_result = NSDecimalDivide(ns_a0, ns_a1, ns_a2, ns_a3);

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, pool);
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

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_UINT, &ns_a2, pool, 2);
  /* a3 */
  rbarg_to_nsarg(a3, _C_INT, &ns_a3, pool, 3);

  ns_result = NSDecimalPower(ns_a0, ns_a1, ns_a2, ns_a3);

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, pool);
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

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_SHT, &ns_a2, pool, 2);
  /* a3 */
  rbarg_to_nsarg(a3, _C_INT, &ns_a3, pool, 3);

  ns_result = NSDecimalMultiplyByPowerOf10(ns_a0, ns_a1, ns_a2, ns_a3);

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, pool);
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

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_ID, &ns_a1, pool, 1);

  ns_result = NSDecimalString(ns_a0, ns_a1);

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, pool);
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
