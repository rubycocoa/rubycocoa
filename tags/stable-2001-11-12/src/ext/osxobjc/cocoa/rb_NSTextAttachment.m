#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);


void init_NSTextAttachment(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSAttachmentCharacter", INT2NUM(NSAttachmentCharacter));

}
