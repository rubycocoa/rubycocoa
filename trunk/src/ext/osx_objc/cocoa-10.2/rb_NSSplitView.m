#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * NSSplitViewDidResizeSubviewsNotification;
static VALUE
osx_NSSplitViewDidResizeSubviewsNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSSplitViewDidResizeSubviewsNotification, "NSSplitViewDidResizeSubviewsNotification", nil);
}

// NSString * NSSplitViewWillResizeSubviewsNotification;
static VALUE
osx_NSSplitViewWillResizeSubviewsNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSSplitViewWillResizeSubviewsNotification, "NSSplitViewWillResizeSubviewsNotification", nil);
}

void init_NSSplitView(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSSplitViewDidResizeSubviewsNotification", osx_NSSplitViewDidResizeSubviewsNotification, 0);
  rb_define_module_function(mOSX, "NSSplitViewWillResizeSubviewsNotification", osx_NSSplitViewWillResizeSubviewsNotification, 0);
}
