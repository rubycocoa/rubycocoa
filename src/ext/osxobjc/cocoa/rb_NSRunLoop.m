#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <Foundation/Foundation.h>

  /**** constants ****/
// NSString * __const NSDefaultRunLoopMode;
static VALUE
osx_NSDefaultRunLoopMode(VALUE mdl)
{
  rb_notimplement();
}

void init_NSRunLoop(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSDefaultRunLoopMode", osx_NSDefaultRunLoopMode, 0);
}
