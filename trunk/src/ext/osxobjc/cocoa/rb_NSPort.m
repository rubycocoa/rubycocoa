#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);


  /**** constants ****/
// NSString * const NSPortDidBecomeInvalidNotification;
static VALUE
osx_NSPortDidBecomeInvalidNotification(VALUE mdl)
{
  rb_notimplement();
}

void init_NSPort(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSPortDidBecomeInvalidNotification", osx_NSPortDidBecomeInvalidNotification, 0);
}
