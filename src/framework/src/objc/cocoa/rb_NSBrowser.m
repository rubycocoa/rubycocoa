#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * NSBrowserColumnConfigurationDidChangeNotification;
static VALUE
osx_NSBrowserColumnConfigurationDidChangeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSBrowserColumnConfigurationDidChangeNotification, "NSBrowserColumnConfigurationDidChangeNotification", nil);
}

void init_NSBrowser(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSBrowserNoColumnResizing", INT2NUM(NSBrowserNoColumnResizing));
  rb_define_const(mOSX, "NSBrowserAutoColumnResizing", INT2NUM(NSBrowserAutoColumnResizing));
  rb_define_const(mOSX, "NSBrowserUserColumnResizing", INT2NUM(NSBrowserUserColumnResizing));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSBrowserColumnConfigurationDidChangeNotification", osx_NSBrowserColumnConfigurationDidChangeNotification, 0);
}
