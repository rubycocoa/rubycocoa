#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);


  /**** constants ****/
// NSString *NSSplitViewDidResizeSubviewsNotification;
static VALUE
osx_NSSplitViewDidResizeSubviewsNotification(VALUE mdl)
{
  NSString * ns_result = NSSplitViewDidResizeSubviewsNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSSplitViewWillResizeSubviewsNotification;
static VALUE
osx_NSSplitViewWillResizeSubviewsNotification(VALUE mdl)
{
  NSString * ns_result = NSSplitViewWillResizeSubviewsNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

void init_NSSplitView(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSSplitViewDidResizeSubviewsNotification", osx_NSSplitViewDidResizeSubviewsNotification, 0);
  rb_define_module_function(mOSX, "NSSplitViewWillResizeSubviewsNotification", osx_NSSplitViewWillResizeSubviewsNotification, 0);
}
