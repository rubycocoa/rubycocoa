#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


void init_NSTextContainer(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSLineSweepLeft", INT2NUM(NSLineSweepLeft));
  rb_define_const(mOSX, "NSLineSweepRight", INT2NUM(NSLineSweepRight));
  rb_define_const(mOSX, "NSLineSweepDown", INT2NUM(NSLineSweepDown));
  rb_define_const(mOSX, "NSLineSweepUp", INT2NUM(NSLineSweepUp));
  rb_define_const(mOSX, "NSLineDoesntMove", INT2NUM(NSLineDoesntMove));
  rb_define_const(mOSX, "NSLineMovesLeft", INT2NUM(NSLineMovesLeft));
  rb_define_const(mOSX, "NSLineMovesRight", INT2NUM(NSLineMovesRight));
  rb_define_const(mOSX, "NSLineMovesDown", INT2NUM(NSLineMovesDown));
  rb_define_const(mOSX, "NSLineMovesUp", INT2NUM(NSLineMovesUp));

}
