#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSGlobalDomain;
static VALUE
osx_NSGlobalDomain(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSGlobalDomain, "NSGlobalDomain", nil);
}

// NSString * const NSArgumentDomain;
static VALUE
osx_NSArgumentDomain(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSArgumentDomain, "NSArgumentDomain", nil);
}

// NSString * const NSRegistrationDomain;
static VALUE
osx_NSRegistrationDomain(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSRegistrationDomain, "NSRegistrationDomain", nil);
}

// NSString * const NSUserDefaultsDidChangeNotification;
static VALUE
osx_NSUserDefaultsDidChangeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSUserDefaultsDidChangeNotification, "NSUserDefaultsDidChangeNotification", nil);
}

// NSString * const NSWeekDayNameArray;
static VALUE
osx_NSWeekDayNameArray(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWeekDayNameArray, "NSWeekDayNameArray", nil);
}

// NSString * const NSShortWeekDayNameArray;
static VALUE
osx_NSShortWeekDayNameArray(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSShortWeekDayNameArray, "NSShortWeekDayNameArray", nil);
}

// NSString * const NSMonthNameArray;
static VALUE
osx_NSMonthNameArray(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSMonthNameArray, "NSMonthNameArray", nil);
}

// NSString * const NSShortMonthNameArray;
static VALUE
osx_NSShortMonthNameArray(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSShortMonthNameArray, "NSShortMonthNameArray", nil);
}

// NSString * const NSTimeFormatString;
static VALUE
osx_NSTimeFormatString(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSTimeFormatString, "NSTimeFormatString", nil);
}

// NSString * const NSDateFormatString;
static VALUE
osx_NSDateFormatString(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSDateFormatString, "NSDateFormatString", nil);
}

// NSString * const NSTimeDateFormatString;
static VALUE
osx_NSTimeDateFormatString(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSTimeDateFormatString, "NSTimeDateFormatString", nil);
}

// NSString * const NSShortTimeDateFormatString;
static VALUE
osx_NSShortTimeDateFormatString(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSShortTimeDateFormatString, "NSShortTimeDateFormatString", nil);
}

// NSString * const NSCurrencySymbol;
static VALUE
osx_NSCurrencySymbol(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSCurrencySymbol, "NSCurrencySymbol", nil);
}

// NSString * const NSDecimalSeparator;
static VALUE
osx_NSDecimalSeparator(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSDecimalSeparator, "NSDecimalSeparator", nil);
}

// NSString * const NSThousandsSeparator;
static VALUE
osx_NSThousandsSeparator(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSThousandsSeparator, "NSThousandsSeparator", nil);
}

// NSString * const NSDecimalDigits;
static VALUE
osx_NSDecimalDigits(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSDecimalDigits, "NSDecimalDigits", nil);
}

// NSString * const NSAMPMDesignation;
static VALUE
osx_NSAMPMDesignation(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAMPMDesignation, "NSAMPMDesignation", nil);
}

// NSString * const NSHourNameDesignations;
static VALUE
osx_NSHourNameDesignations(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSHourNameDesignations, "NSHourNameDesignations", nil);
}

// NSString * const NSYearMonthWeekDesignations;
static VALUE
osx_NSYearMonthWeekDesignations(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSYearMonthWeekDesignations, "NSYearMonthWeekDesignations", nil);
}

// NSString * const NSEarlierTimeDesignations;
static VALUE
osx_NSEarlierTimeDesignations(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSEarlierTimeDesignations, "NSEarlierTimeDesignations", nil);
}

// NSString * const NSLaterTimeDesignations;
static VALUE
osx_NSLaterTimeDesignations(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSLaterTimeDesignations, "NSLaterTimeDesignations", nil);
}

// NSString * const NSThisDayDesignations;
static VALUE
osx_NSThisDayDesignations(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSThisDayDesignations, "NSThisDayDesignations", nil);
}

// NSString * const NSNextDayDesignations;
static VALUE
osx_NSNextDayDesignations(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSNextDayDesignations, "NSNextDayDesignations", nil);
}

// NSString * const NSNextNextDayDesignations;
static VALUE
osx_NSNextNextDayDesignations(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSNextNextDayDesignations, "NSNextNextDayDesignations", nil);
}

// NSString * const NSPriorDayDesignations;
static VALUE
osx_NSPriorDayDesignations(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSPriorDayDesignations, "NSPriorDayDesignations", nil);
}

// NSString * const NSDateTimeOrdering;
static VALUE
osx_NSDateTimeOrdering(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSDateTimeOrdering, "NSDateTimeOrdering", nil);
}

// NSString * const NSInternationalCurrencyString;
static VALUE
osx_NSInternationalCurrencyString(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSInternationalCurrencyString, "NSInternationalCurrencyString", nil);
}

// NSString * const NSShortDateFormatString;
static VALUE
osx_NSShortDateFormatString(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSShortDateFormatString, "NSShortDateFormatString", nil);
}

// NSString * const NSPositiveCurrencyFormatString;
static VALUE
osx_NSPositiveCurrencyFormatString(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSPositiveCurrencyFormatString, "NSPositiveCurrencyFormatString", nil);
}

// NSString * const NSNegativeCurrencyFormatString;
static VALUE
osx_NSNegativeCurrencyFormatString(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSNegativeCurrencyFormatString, "NSNegativeCurrencyFormatString", nil);
}

void init_NSUserDefaults(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSGlobalDomain", osx_NSGlobalDomain, 0);
  rb_define_module_function(mOSX, "NSArgumentDomain", osx_NSArgumentDomain, 0);
  rb_define_module_function(mOSX, "NSRegistrationDomain", osx_NSRegistrationDomain, 0);
  rb_define_module_function(mOSX, "NSUserDefaultsDidChangeNotification", osx_NSUserDefaultsDidChangeNotification, 0);
  rb_define_module_function(mOSX, "NSWeekDayNameArray", osx_NSWeekDayNameArray, 0);
  rb_define_module_function(mOSX, "NSShortWeekDayNameArray", osx_NSShortWeekDayNameArray, 0);
  rb_define_module_function(mOSX, "NSMonthNameArray", osx_NSMonthNameArray, 0);
  rb_define_module_function(mOSX, "NSShortMonthNameArray", osx_NSShortMonthNameArray, 0);
  rb_define_module_function(mOSX, "NSTimeFormatString", osx_NSTimeFormatString, 0);
  rb_define_module_function(mOSX, "NSDateFormatString", osx_NSDateFormatString, 0);
  rb_define_module_function(mOSX, "NSTimeDateFormatString", osx_NSTimeDateFormatString, 0);
  rb_define_module_function(mOSX, "NSShortTimeDateFormatString", osx_NSShortTimeDateFormatString, 0);
  rb_define_module_function(mOSX, "NSCurrencySymbol", osx_NSCurrencySymbol, 0);
  rb_define_module_function(mOSX, "NSDecimalSeparator", osx_NSDecimalSeparator, 0);
  rb_define_module_function(mOSX, "NSThousandsSeparator", osx_NSThousandsSeparator, 0);
  rb_define_module_function(mOSX, "NSDecimalDigits", osx_NSDecimalDigits, 0);
  rb_define_module_function(mOSX, "NSAMPMDesignation", osx_NSAMPMDesignation, 0);
  rb_define_module_function(mOSX, "NSHourNameDesignations", osx_NSHourNameDesignations, 0);
  rb_define_module_function(mOSX, "NSYearMonthWeekDesignations", osx_NSYearMonthWeekDesignations, 0);
  rb_define_module_function(mOSX, "NSEarlierTimeDesignations", osx_NSEarlierTimeDesignations, 0);
  rb_define_module_function(mOSX, "NSLaterTimeDesignations", osx_NSLaterTimeDesignations, 0);
  rb_define_module_function(mOSX, "NSThisDayDesignations", osx_NSThisDayDesignations, 0);
  rb_define_module_function(mOSX, "NSNextDayDesignations", osx_NSNextDayDesignations, 0);
  rb_define_module_function(mOSX, "NSNextNextDayDesignations", osx_NSNextNextDayDesignations, 0);
  rb_define_module_function(mOSX, "NSPriorDayDesignations", osx_NSPriorDayDesignations, 0);
  rb_define_module_function(mOSX, "NSDateTimeOrdering", osx_NSDateTimeOrdering, 0);
  rb_define_module_function(mOSX, "NSInternationalCurrencyString", osx_NSInternationalCurrencyString, 0);
  rb_define_module_function(mOSX, "NSShortDateFormatString", osx_NSShortDateFormatString, 0);
  rb_define_module_function(mOSX, "NSPositiveCurrencyFormatString", osx_NSPositiveCurrencyFormatString, 0);
  rb_define_module_function(mOSX, "NSNegativeCurrencyFormatString", osx_NSNegativeCurrencyFormatString, 0);
}
