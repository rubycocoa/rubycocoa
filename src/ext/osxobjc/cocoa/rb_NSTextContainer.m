#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

static void
rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index)
{
  if (!rbobj_to_ocdata(rbarg, octype, nsarg)) {
    if (pool) [pool release];
    rb_raise(rb_eArgError, "arg #%d cannot convert to nsobj.", index);
  }
}

static VALUE
nsresult_to_rbresult(int octype, const void* nsresult, id pool)
{
  VALUE rbresult;
  if (octype == _C_ID) {
    rbresult = ocobj_new_with_ocid(*(id*)nsresult);
  }
  else {
    if (!ocdata_to_rbobj(octype, nsresult, &rbresult)) {
      if (pool) [pool release];
      rb_raise(rb_eRuntimeError, "result cannot convert to rbobj.");
    }
  }
  return rbresult;
}


void init_NSTextContainer(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSLineSweepLeft", INT2NUM(NSLineSweepLeft));
  rb_define_const(mOSX, "NSLineSweepRight", INT2NUM(NSLineSweepRight));
  rb_define_const(mOSX, "NSLineSweepDown", INT2NUM(NSLineSweepDown));
  rb_define_const(mOSX, "NSLineSweepUp", INT2NUM(NSLineSweepUp));
  rb_define_const(mOSX, "NSLineDoesntMove", INT2NUM(NSLineDoesntMove));
  rb_define_const(mOSX, "NSLineMovesLeft", INT2NUM(NSLineMovesLeft));
  rb_define_const(mOSX, "NSLineMovesRight", INT2NUM(NSLineMovesRight));
  rb_define_const(mOSX, "NSLineMovesDown", INT2NUM(NSLineMovesDown));
  rb_define_const(mOSX, "NSLineMovesUp", INT2NUM(NSLineMovesUp));

}
