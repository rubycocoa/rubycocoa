#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <Foundation/Foundation.h>

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
