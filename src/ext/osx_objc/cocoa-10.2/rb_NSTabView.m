#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


void init_NSTabView(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSTopTabsBezelBorder", INT2NUM(NSTopTabsBezelBorder));
  rb_define_const(mOSX, "NSLeftTabsBezelBorder", INT2NUM(NSLeftTabsBezelBorder));
  rb_define_const(mOSX, "NSBottomTabsBezelBorder", INT2NUM(NSBottomTabsBezelBorder));
  rb_define_const(mOSX, "NSRightTabsBezelBorder", INT2NUM(NSRightTabsBezelBorder));
  rb_define_const(mOSX, "NSNoTabsBezelBorder", INT2NUM(NSNoTabsBezelBorder));
  rb_define_const(mOSX, "NSNoTabsLineBorder", INT2NUM(NSNoTabsLineBorder));
  rb_define_const(mOSX, "NSNoTabsNoBorder", INT2NUM(NSNoTabsNoBorder));

}
