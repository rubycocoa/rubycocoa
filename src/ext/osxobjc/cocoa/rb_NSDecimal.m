#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <Foundation/Foundation.h>

  /**** functions ****/
// void NSDecimalCopy(NSDecimal *destination, const NSDecimal *source);
static VALUE
osx_NSDecimalCopy(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSDecimalCompact(NSDecimal *number);
static VALUE
osx_NSDecimalCompact(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSComparisonResult NSDecimalCompare(const NSDecimal *leftOperand, const NSDecimal *rightOperand);
static VALUE
osx_NSDecimalCompare(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSDecimalRound(NSDecimal *result, const NSDecimal *number, int scale, NSRoundingMode roundingMode);
static VALUE
osx_NSDecimalRound(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSCalculationError NSDecimalNormalize(NSDecimal *number1, NSDecimal *number2, NSRoundingMode roundingMode);
static VALUE
osx_NSDecimalNormalize(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSCalculationError NSDecimalAdd(NSDecimal *result, const NSDecimal *leftOperand, const NSDecimal *rightOperand, NSRoundingMode roundingMode);
static VALUE
osx_NSDecimalAdd(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSCalculationError NSDecimalSubtract(NSDecimal *result, const NSDecimal *leftOperand, const NSDecimal *rightOperand, NSRoundingMode roundingMode);
static VALUE
osx_NSDecimalSubtract(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSCalculationError NSDecimalMultiply(NSDecimal *result, const NSDecimal *leftOperand, const NSDecimal *rightOperand, NSRoundingMode roundingMode);
static VALUE
osx_NSDecimalMultiply(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSCalculationError NSDecimalDivide(NSDecimal *result, const NSDecimal *leftOperand, const NSDecimal *rightOperand, NSRoundingMode roundingMode);
static VALUE
osx_NSDecimalDivide(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSCalculationError NSDecimalPower(NSDecimal *result, const NSDecimal *number, unsigned power, NSRoundingMode roundingMode);
static VALUE
osx_NSDecimalPower(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSCalculationError NSDecimalMultiplyByPowerOf10(NSDecimal *result, const NSDecimal *number, short power, NSRoundingMode roundingMode);
static VALUE
osx_NSDecimalMultiplyByPowerOf10(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSString *NSDecimalString(const NSDecimal *dcm, NSDictionary *locale);
static VALUE
osx_NSDecimalString(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
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
  rb_define_module_function(mOSX, "NSDecimalCopy", osx_NSDecimalCopy, -1);
  rb_define_module_function(mOSX, "NSDecimalCompact", osx_NSDecimalCompact, -1);
  rb_define_module_function(mOSX, "NSDecimalCompare", osx_NSDecimalCompare, -1);
  rb_define_module_function(mOSX, "NSDecimalRound", osx_NSDecimalRound, -1);
  rb_define_module_function(mOSX, "NSDecimalNormalize", osx_NSDecimalNormalize, -1);
  rb_define_module_function(mOSX, "NSDecimalAdd", osx_NSDecimalAdd, -1);
  rb_define_module_function(mOSX, "NSDecimalSubtract", osx_NSDecimalSubtract, -1);
  rb_define_module_function(mOSX, "NSDecimalMultiply", osx_NSDecimalMultiply, -1);
  rb_define_module_function(mOSX, "NSDecimalDivide", osx_NSDecimalDivide, -1);
  rb_define_module_function(mOSX, "NSDecimalPower", osx_NSDecimalPower, -1);
  rb_define_module_function(mOSX, "NSDecimalMultiplyByPowerOf10", osx_NSDecimalMultiplyByPowerOf10, -1);
  rb_define_module_function(mOSX, "NSDecimalString", osx_NSDecimalString, -1);
}
