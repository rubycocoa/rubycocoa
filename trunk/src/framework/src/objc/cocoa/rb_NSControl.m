#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * NSControlTextDidBeginEditingNotification;
static VALUE
osx_NSControlTextDidBeginEditingNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSControlTextDidBeginEditingNotification, "NSControlTextDidBeginEditingNotification", nil);
}

// NSString * NSControlTextDidEndEditingNotification;
static VALUE
osx_NSControlTextDidEndEditingNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSControlTextDidEndEditingNotification, "NSControlTextDidEndEditingNotification", nil);
}

// NSString * NSControlTextDidChangeNotification;
static VALUE
osx_NSControlTextDidChangeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSControlTextDidChangeNotification, "NSControlTextDidChangeNotification", nil);
}

void init_NSControl(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSControlTextDidBeginEditingNotification", osx_NSControlTextDidBeginEditingNotification, 0);
  rb_define_module_function(mOSX, "NSControlTextDidEndEditingNotification", osx_NSControlTextDidEndEditingNotification, 0);
  rb_define_module_function(mOSX, "NSControlTextDidChangeNotification", osx_NSControlTextDidChangeNotification, 0);
}
