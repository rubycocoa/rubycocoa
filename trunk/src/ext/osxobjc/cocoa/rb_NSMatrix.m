#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

void init_NSMatrix(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSRadioModeMatrix", INT2NUM(NSRadioModeMatrix));
  rb_define_const(mOSX, "NSHighlightModeMatrix", INT2NUM(NSHighlightModeMatrix));
  rb_define_const(mOSX, "NSListModeMatrix", INT2NUM(NSListModeMatrix));
  rb_define_const(mOSX, "NSTrackModeMatrix", INT2NUM(NSTrackModeMatrix));

}
