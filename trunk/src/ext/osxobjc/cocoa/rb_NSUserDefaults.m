#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSGlobalDomain;
static VALUE
osx_NSGlobalDomain(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSArgumentDomain;
static VALUE
osx_NSArgumentDomain(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSRegistrationDomain;
static VALUE
osx_NSRegistrationDomain(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSUserDefaultsDidChangeNotification;
static VALUE
osx_NSUserDefaultsDidChangeNotification(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSWeekDayNameArray;
static VALUE
osx_NSWeekDayNameArray(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSShortWeekDayNameArray;
static VALUE
osx_NSShortWeekDayNameArray(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSMonthNameArray;
static VALUE
osx_NSMonthNameArray(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSShortMonthNameArray;
static VALUE
osx_NSShortMonthNameArray(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSTimeFormatString;
static VALUE
osx_NSTimeFormatString(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSDateFormatString;
static VALUE
osx_NSDateFormatString(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSTimeDateFormatString;
static VALUE
osx_NSTimeDateFormatString(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSShortTimeDateFormatString;
static VALUE
osx_NSShortTimeDateFormatString(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSCurrencySymbol;
static VALUE
osx_NSCurrencySymbol(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSDecimalSeparator;
static VALUE
osx_NSDecimalSeparator(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSThousandsSeparator;
static VALUE
osx_NSThousandsSeparator(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSDecimalDigits;
static VALUE
osx_NSDecimalDigits(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSAMPMDesignation;
static VALUE
osx_NSAMPMDesignation(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSHourNameDesignations;
static VALUE
osx_NSHourNameDesignations(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSYearMonthWeekDesignations;
static VALUE
osx_NSYearMonthWeekDesignations(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSEarlierTimeDesignations;
static VALUE
osx_NSEarlierTimeDesignations(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSLaterTimeDesignations;
static VALUE
osx_NSLaterTimeDesignations(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSThisDayDesignations;
static VALUE
osx_NSThisDayDesignations(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSNextDayDesignations;
static VALUE
osx_NSNextDayDesignations(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSNextNextDayDesignations;
static VALUE
osx_NSNextNextDayDesignations(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSPriorDayDesignations;
static VALUE
osx_NSPriorDayDesignations(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSDateTimeOrdering;
static VALUE
osx_NSDateTimeOrdering(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSInternationalCurrencyString;
static VALUE
osx_NSInternationalCurrencyString(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSShortDateFormatString;
static VALUE
osx_NSShortDateFormatString(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSPositiveCurrencyFormatString;
static VALUE
osx_NSPositiveCurrencyFormatString(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSNegativeCurrencyFormatString;
static VALUE
osx_NSNegativeCurrencyFormatString(VALUE mdl)
{
  rb_notimplement();
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
