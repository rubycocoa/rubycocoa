#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString *NSContextHelpModeDidActivateNotification;
static VALUE
osx_NSContextHelpModeDidActivateNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSContextHelpModeDidActivateNotification);
}

// NSString *NSContextHelpModeDidDeactivateNotification;
static VALUE
osx_NSContextHelpModeDidDeactivateNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSContextHelpModeDidDeactivateNotification);
}

void init_NSHelpManager(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSContextHelpModeDidActivateNotification", osx_NSContextHelpModeDidActivateNotification, 0);
  rb_define_module_function(mOSX, "NSContextHelpModeDidDeactivateNotification", osx_NSContextHelpModeDidDeactivateNotification, 0);
}
