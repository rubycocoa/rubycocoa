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


void init_NSDragging(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSDragOperationNone", INT2NUM(NSDragOperationNone));
  rb_define_const(mOSX, "NSDragOperationCopy", INT2NUM(NSDragOperationCopy));
  rb_define_const(mOSX, "NSDragOperationLink", INT2NUM(NSDragOperationLink));
  rb_define_const(mOSX, "NSDragOperationGeneric", INT2NUM(NSDragOperationGeneric));
  rb_define_const(mOSX, "NSDragOperationPrivate", INT2NUM(NSDragOperationPrivate));
  rb_define_const(mOSX, "NSDragOperationAll_Obsolete", INT2NUM(NSDragOperationAll_Obsolete));
  rb_define_const(mOSX, "NSDragOperationMove", INT2NUM(NSDragOperationMove));
  rb_define_const(mOSX, "NSDragOperationDelete", INT2NUM(NSDragOperationDelete));
  rb_define_const(mOSX, "NSDragOperationEvery", INT2NUM(NSDragOperationEvery));

}
