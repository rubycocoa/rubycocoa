#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString *NSPopUpButtonWillPopUpNotification;
static VALUE
osx_NSPopUpButtonWillPopUpNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSPopUpButtonWillPopUpNotification, nil);
}

void init_NSPopUpButton(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSPopUpButtonWillPopUpNotification", osx_NSPopUpButtonWillPopUpNotification, 0);
}
