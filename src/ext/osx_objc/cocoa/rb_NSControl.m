#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
#define VA_MAX 4


  /**** constants ****/
// NSString *NSControlTextDidBeginEditingNotification;
static VALUE
osx_NSControlTextDidBeginEditingNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSControlTextDidBeginEditingNotification, nil);
}

// NSString *NSControlTextDidEndEditingNotification;
static VALUE
osx_NSControlTextDidEndEditingNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSControlTextDidEndEditingNotification, nil);
}

// NSString *NSControlTextDidChangeNotification;
static VALUE
osx_NSControlTextDidChangeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSControlTextDidChangeNotification, nil);
}

void init_NSControl(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSControlTextDidBeginEditingNotification", osx_NSControlTextDidBeginEditingNotification, 0);
  rb_define_module_function(mOSX, "NSControlTextDidEndEditingNotification", osx_NSControlTextDidEndEditingNotification, 0);
  rb_define_module_function(mOSX, "NSControlTextDidChangeNotification", osx_NSControlTextDidChangeNotification, 0);
}
