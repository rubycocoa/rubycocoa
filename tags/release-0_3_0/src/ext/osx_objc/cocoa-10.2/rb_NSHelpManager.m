#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * NSContextHelpModeDidActivateNotification;
static VALUE
osx_NSContextHelpModeDidActivateNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSContextHelpModeDidActivateNotification, nil);
}

// NSString * NSContextHelpModeDidDeactivateNotification;
static VALUE
osx_NSContextHelpModeDidDeactivateNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSContextHelpModeDidDeactivateNotification, nil);
}

void init_NSHelpManager(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSContextHelpModeDidActivateNotification", osx_NSContextHelpModeDidActivateNotification, 0);
  rb_define_module_function(mOSX, "NSContextHelpModeDidDeactivateNotification", osx_NSContextHelpModeDidDeactivateNotification, 0);
}
