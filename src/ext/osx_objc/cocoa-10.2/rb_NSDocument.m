#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


void init_NSDocument(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSChangeDone", INT2NUM(NSChangeDone));
  rb_define_const(mOSX, "NSChangeUndone", INT2NUM(NSChangeUndone));
  rb_define_const(mOSX, "NSChangeCleared", INT2NUM(NSChangeCleared));
  rb_define_const(mOSX, "NSSaveOperation", INT2NUM(NSSaveOperation));
  rb_define_const(mOSX, "NSSaveAsOperation", INT2NUM(NSSaveAsOperation));
  rb_define_const(mOSX, "NSSaveToOperation", INT2NUM(NSSaveToOperation));

}
