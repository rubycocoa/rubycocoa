#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

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


void init_NSScriptWhoseTests(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSEqualToComparison", INT2NUM(NSEqualToComparison));
  rb_define_const(mOSX, "NSLessThanOrEqualToComparison", INT2NUM(NSLessThanOrEqualToComparison));
  rb_define_const(mOSX, "NSLessThanComparison", INT2NUM(NSLessThanComparison));
  rb_define_const(mOSX, "NSGreaterThanOrEqualToComparison", INT2NUM(NSGreaterThanOrEqualToComparison));
  rb_define_const(mOSX, "NSGreaterThanComparison", INT2NUM(NSGreaterThanComparison));
  rb_define_const(mOSX, "NSBeginsWithComparison", INT2NUM(NSBeginsWithComparison));
  rb_define_const(mOSX, "NSEndsWithComparison", INT2NUM(NSEndsWithComparison));
  rb_define_const(mOSX, "NSContainsComparison", INT2NUM(NSContainsComparison));

}
