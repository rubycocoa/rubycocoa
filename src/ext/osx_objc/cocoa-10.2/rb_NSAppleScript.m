#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSAppleScriptErrorMessage;
static VALUE
osx_NSAppleScriptErrorMessage(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAppleScriptErrorMessage, nil);
}

// NSString * const NSAppleScriptErrorNumber;
static VALUE
osx_NSAppleScriptErrorNumber(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAppleScriptErrorNumber, nil);
}

// NSString * const NSAppleScriptErrorAppName;
static VALUE
osx_NSAppleScriptErrorAppName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAppleScriptErrorAppName, nil);
}

// NSString * const NSAppleScriptErrorBriefMessage;
static VALUE
osx_NSAppleScriptErrorBriefMessage(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAppleScriptErrorBriefMessage, nil);
}

// NSString * const NSAppleScriptErrorRange;
static VALUE
osx_NSAppleScriptErrorRange(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAppleScriptErrorRange, nil);
}

void init_NSAppleScript(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSAppleScriptErrorMessage", osx_NSAppleScriptErrorMessage, 0);
  rb_define_module_function(mOSX, "NSAppleScriptErrorNumber", osx_NSAppleScriptErrorNumber, 0);
  rb_define_module_function(mOSX, "NSAppleScriptErrorAppName", osx_NSAppleScriptErrorAppName, 0);
  rb_define_module_function(mOSX, "NSAppleScriptErrorBriefMessage", osx_NSAppleScriptErrorBriefMessage, 0);
  rb_define_module_function(mOSX, "NSAppleScriptErrorRange", osx_NSAppleScriptErrorRange, 0);
}
