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
