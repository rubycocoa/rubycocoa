#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

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
