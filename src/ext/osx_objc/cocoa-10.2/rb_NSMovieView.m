#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


void init_NSMovieView(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSQTMovieNormalPlayback", INT2NUM(NSQTMovieNormalPlayback));
  rb_define_const(mOSX, "NSQTMovieLoopingPlayback", INT2NUM(NSQTMovieLoopingPlayback));
  rb_define_const(mOSX, "NSQTMovieLoopingBackAndForthPlayback", INT2NUM(NSQTMovieLoopingBackAndForthPlayback));

}
