#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);


  /**** constants ****/
// NSString *NSContextHelpModeDidActivateNotification;
static VALUE
osx_NSContextHelpModeDidActivateNotification(VALUE mdl)
{
  NSString * ns_result = NSContextHelpModeDidActivateNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSContextHelpModeDidDeactivateNotification;
static VALUE
osx_NSContextHelpModeDidDeactivateNotification(VALUE mdl)
{
  NSString * ns_result = NSContextHelpModeDidDeactivateNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

void init_NSHelpManager(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSContextHelpModeDidActivateNotification", osx_NSContextHelpModeDidActivateNotification, 0);
  rb_define_module_function(mOSX, "NSContextHelpModeDidDeactivateNotification", osx_NSContextHelpModeDidDeactivateNotification, 0);
}
