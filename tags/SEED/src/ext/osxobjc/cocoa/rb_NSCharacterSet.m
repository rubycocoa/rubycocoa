#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <Foundation/Foundation.h>

void init_NSCharacterSet(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSOpenStepUnicodeReservedBase", INT2NUM(NSOpenStepUnicodeReservedBase));

}
