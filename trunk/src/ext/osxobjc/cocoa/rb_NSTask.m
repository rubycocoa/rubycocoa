#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSTaskDidTerminateNotification;
static VALUE
osx_NSTaskDidTerminateNotification(VALUE mdl)
{
  rb_notimplement();
}

void init_NSTask(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSTaskDidTerminateNotification", osx_NSTaskDidTerminateNotification, 0);
}
