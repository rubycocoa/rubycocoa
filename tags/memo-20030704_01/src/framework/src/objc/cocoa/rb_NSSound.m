#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSSoundPboardType;
static VALUE
osx_NSSoundPboardType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSSoundPboardType, "NSSoundPboardType", nil);
}

void init_NSSound(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSSoundPboardType", osx_NSSoundPboardType, 0);
}
