#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


void init_NSDragging(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSDragOperationNone", INT2NUM(NSDragOperationNone));
  rb_define_const(mOSX, "NSDragOperationCopy", INT2NUM(NSDragOperationCopy));
  rb_define_const(mOSX, "NSDragOperationLink", INT2NUM(NSDragOperationLink));
  rb_define_const(mOSX, "NSDragOperationGeneric", INT2NUM(NSDragOperationGeneric));
  rb_define_const(mOSX, "NSDragOperationPrivate", INT2NUM(NSDragOperationPrivate));
  rb_define_const(mOSX, "NSDragOperationAll_Obsolete", INT2NUM(NSDragOperationAll_Obsolete));
  rb_define_const(mOSX, "NSDragOperationMove", INT2NUM(NSDragOperationMove));
  rb_define_const(mOSX, "NSDragOperationDelete", INT2NUM(NSDragOperationDelete));
  rb_define_const(mOSX, "NSDragOperationEvery", INT2NUM(NSDragOperationEvery));

}
