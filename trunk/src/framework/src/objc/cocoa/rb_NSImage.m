#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


void init_NSImage(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSImageLoadStatusCompleted", INT2NUM(NSImageLoadStatusCompleted));
  rb_define_const(mOSX, "NSImageLoadStatusCancelled", INT2NUM(NSImageLoadStatusCancelled));
  rb_define_const(mOSX, "NSImageLoadStatusInvalidData", INT2NUM(NSImageLoadStatusInvalidData));
  rb_define_const(mOSX, "NSImageLoadStatusUnexpectedEOF", INT2NUM(NSImageLoadStatusUnexpectedEOF));
  rb_define_const(mOSX, "NSImageLoadStatusReadError", INT2NUM(NSImageLoadStatusReadError));
  rb_define_const(mOSX, "NSImageCacheDefault", INT2NUM(NSImageCacheDefault));
  rb_define_const(mOSX, "NSImageCacheAlways", INT2NUM(NSImageCacheAlways));
  rb_define_const(mOSX, "NSImageCacheBySize", INT2NUM(NSImageCacheBySize));
  rb_define_const(mOSX, "NSImageCacheNever", INT2NUM(NSImageCacheNever));

}
