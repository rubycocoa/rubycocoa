#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSSoundPboardType;
static VALUE
osx_NSSoundPboardType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSSoundPboardType, nil);
}

void init_NSSound(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSSoundPboardType", osx_NSSoundPboardType, 0);
}
