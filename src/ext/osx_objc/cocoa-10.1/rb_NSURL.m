#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString *NSURLFileScheme;
static VALUE
osx_NSURLFileScheme(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSURLFileScheme, nil);
}

void init_NSURL(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSURLFileScheme", osx_NSURLFileScheme, 0);
}
