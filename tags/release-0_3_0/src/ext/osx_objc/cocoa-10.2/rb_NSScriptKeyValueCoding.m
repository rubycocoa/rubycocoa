#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * NSOperationNotSupportedForKeyException;
static VALUE
osx_NSOperationNotSupportedForKeyException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSOperationNotSupportedForKeyException, nil);
}

void init_NSScriptKeyValueCoding(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSOperationNotSupportedForKeyException", osx_NSOperationNotSupportedForKeyException, 0);
}
