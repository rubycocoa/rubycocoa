#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString *NSColorListDidChangeNotification;
static VALUE
osx_NSColorListDidChangeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSColorListDidChangeNotification, nil);
}

void init_NSColorList(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSColorListDidChangeNotification", osx_NSColorListDidChangeNotification, 0);
}
