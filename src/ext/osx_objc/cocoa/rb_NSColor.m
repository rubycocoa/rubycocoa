#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
#define VA_MAX 4


  /**** constants ****/
// NSString *NSSystemColorsDidChangeNotification;
static VALUE
osx_NSSystemColorsDidChangeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSSystemColorsDidChangeNotification, nil);
}

void init_NSColor(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSSystemColorsDidChangeNotification", osx_NSSystemColorsDidChangeNotification, 0);
}
