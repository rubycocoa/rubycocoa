#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

void init_NSMovieView(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSQTMovieNormalPlayback", INT2NUM(NSQTMovieNormalPlayback));
  rb_define_const(mOSX, "NSQTMovieLoopingPlayback", INT2NUM(NSQTMovieLoopingPlayback));
  rb_define_const(mOSX, "NSQTMovieLoopingBackAndForthPlayback", INT2NUM(NSQTMovieLoopingBackAndForthPlayback));

}
