#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);


  /**** constants ****/
// NSString *NSColorListDidChangeNotification;
static VALUE
osx_NSColorListDidChangeNotification(VALUE mdl)
{
  NSString * ns_result = NSColorListDidChangeNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

void init_NSColorList(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSColorListDidChangeNotification", osx_NSColorListDidChangeNotification, 0);
}
