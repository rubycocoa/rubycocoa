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


void init_NSInvocation(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSObjCNoType", INT2NUM(NSObjCNoType));
  rb_define_const(mOSX, "NSObjCVoidType", INT2NUM(NSObjCVoidType));
  rb_define_const(mOSX, "NSObjCCharType", INT2NUM(NSObjCCharType));
  rb_define_const(mOSX, "NSObjCShortType", INT2NUM(NSObjCShortType));
  rb_define_const(mOSX, "NSObjCLongType", INT2NUM(NSObjCLongType));
  rb_define_const(mOSX, "NSObjCLonglongType", INT2NUM(NSObjCLonglongType));
  rb_define_const(mOSX, "NSObjCFloatType", INT2NUM(NSObjCFloatType));
  rb_define_const(mOSX, "NSObjCDoubleType", INT2NUM(NSObjCDoubleType));
  rb_define_const(mOSX, "NSObjCSelectorType", INT2NUM(NSObjCSelectorType));
  rb_define_const(mOSX, "NSObjCObjectType", INT2NUM(NSObjCObjectType));
  rb_define_const(mOSX, "NSObjCStructType", INT2NUM(NSObjCStructType));
  rb_define_const(mOSX, "NSObjCPointerType", INT2NUM(NSObjCPointerType));
  rb_define_const(mOSX, "NSObjCStringType", INT2NUM(NSObjCStringType));
  rb_define_const(mOSX, "NSObjCArrayType", INT2NUM(NSObjCArrayType));
  rb_define_const(mOSX, "NSObjCUnionType", INT2NUM(NSObjCUnionType));
  rb_define_const(mOSX, "NSObjCBitfield", INT2NUM(NSObjCBitfield));

}
