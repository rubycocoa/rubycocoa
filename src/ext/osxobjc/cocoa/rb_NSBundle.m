#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

static void
rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index)
{
  if (!rbobj_to_ocdata(rbarg, octype, nsarg)) {
    if (pool) [pool release];
    rb_raise(rb_eArgError, "arg #%d cannot convert to nsobj.", index);
  }
}

static VALUE
nsresult_to_rbresult(int octype, const void* nsresult, id pool)
{
  VALUE rbresult;
  if (octype == _C_ID) {
    rbresult = ocobj_new_with_ocid(*(id*)nsresult);
  }
  else {
    if (!ocdata_to_rbobj(octype, nsresult, &rbresult)) {
      if (pool) [pool release];
      rb_raise(rb_eRuntimeError, "result cannot convert to rbobj.");
    }
  }
  return rbresult;
}


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
