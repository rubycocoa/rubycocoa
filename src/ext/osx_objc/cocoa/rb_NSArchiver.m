#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
#define VA_MAX 4


  /**** constants ****/
// NSString * const NSInconsistentArchiveException;
static VALUE
osx_NSInconsistentArchiveException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSInconsistentArchiveException, nil);
}

void init_NSArchiver(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSInconsistentArchiveException", osx_NSInconsistentArchiveException, 0);
}
