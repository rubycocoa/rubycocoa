#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

void init_NSRulerView(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSHorizontalRuler", INT2NUM(NSHorizontalRuler));
  rb_define_const(mOSX, "NSVerticalRuler", INT2NUM(NSVerticalRuler));

}
