#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * NSTabColumnTerminatorsAttributeName;
static VALUE
osx_NSTabColumnTerminatorsAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSTabColumnTerminatorsAttributeName, "NSTabColumnTerminatorsAttributeName", nil);
}

void init_NSParagraphStyle(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSLeftTabStopType", INT2NUM(NSLeftTabStopType));
  rb_define_const(mOSX, "NSRightTabStopType", INT2NUM(NSRightTabStopType));
  rb_define_const(mOSX, "NSCenterTabStopType", INT2NUM(NSCenterTabStopType));
  rb_define_const(mOSX, "NSDecimalTabStopType", INT2NUM(NSDecimalTabStopType));
  rb_define_const(mOSX, "NSLineBreakByWordWrapping", INT2NUM(NSLineBreakByWordWrapping));
  rb_define_const(mOSX, "NSLineBreakByCharWrapping", INT2NUM(NSLineBreakByCharWrapping));
  rb_define_const(mOSX, "NSLineBreakByClipping", INT2NUM(NSLineBreakByClipping));
  rb_define_const(mOSX, "NSLineBreakByTruncatingHead", INT2NUM(NSLineBreakByTruncatingHead));
  rb_define_const(mOSX, "NSLineBreakByTruncatingTail", INT2NUM(NSLineBreakByTruncatingTail));
  rb_define_const(mOSX, "NSLineBreakByTruncatingMiddle", INT2NUM(NSLineBreakByTruncatingMiddle));
  rb_define_const(mOSX, "NSWritingDirectionLeftToRight", INT2NUM(NSWritingDirectionLeftToRight));
  rb_define_const(mOSX, "NSWritingDirectionRightToLeft", INT2NUM(NSWritingDirectionRightToLeft));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSTabColumnTerminatorsAttributeName", osx_NSTabColumnTerminatorsAttributeName, 0);
}
