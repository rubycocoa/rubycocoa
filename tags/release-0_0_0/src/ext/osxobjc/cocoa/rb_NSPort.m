#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <Foundation/Foundation.h>

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
