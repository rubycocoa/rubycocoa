#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSBundleDidLoadNotification;
static VALUE
osx_NSBundleDidLoadNotification(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSLoadedClasses;
static VALUE
osx_NSLoadedClasses(VALUE mdl)
{
  rb_notimplement();
}

void init_NSBundle(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSBundleDidLoadNotification", osx_NSBundleDidLoadNotification, 0);
  rb_define_module_function(mOSX, "NSLoadedClasses", osx_NSLoadedClasses, 0);
}
