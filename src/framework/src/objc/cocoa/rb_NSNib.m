#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * NSNibOwner;
static VALUE
osx_NSNibOwner(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSNibOwner, "NSNibOwner", nil);
}

// NSString * NSNibTopLevelObjects;
static VALUE
osx_NSNibTopLevelObjects(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSNibTopLevelObjects, "NSNibTopLevelObjects", nil);
}

void init_NSNib(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSNibOwner", osx_NSNibOwner, 0);
  rb_define_module_function(mOSX, "NSNibTopLevelObjects", osx_NSNibTopLevelObjects, 0);
}
