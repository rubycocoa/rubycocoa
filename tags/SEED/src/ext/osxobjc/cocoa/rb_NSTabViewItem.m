#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

void init_NSTabViewItem(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSSelectedTab", INT2NUM(NSSelectedTab));
  rb_define_const(mOSX, "NSBackgroundTab", INT2NUM(NSBackgroundTab));
  rb_define_const(mOSX, "NSPressedTab", INT2NUM(NSPressedTab));

}
