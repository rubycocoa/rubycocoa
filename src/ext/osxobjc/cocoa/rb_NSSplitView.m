#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString *NSSplitViewDidResizeSubviewsNotification;
static VALUE
osx_NSSplitViewDidResizeSubviewsNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSSplitViewDidResizeSubviewsNotification);
}

// NSString *NSSplitViewWillResizeSubviewsNotification;
static VALUE
osx_NSSplitViewWillResizeSubviewsNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSSplitViewWillResizeSubviewsNotification);
}

void init_NSSplitView(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSSplitViewDidResizeSubviewsNotification", osx_NSSplitViewDidResizeSubviewsNotification, 0);
  rb_define_module_function(mOSX, "NSSplitViewWillResizeSubviewsNotification", osx_NSSplitViewWillResizeSubviewsNotification, 0);
}
