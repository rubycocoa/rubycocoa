#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

void init_NSTextAttachment(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSAttachmentCharacter", INT2NUM(NSAttachmentCharacter));

}
