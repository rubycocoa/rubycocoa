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


void init_NSScriptStandardSuiteCommands(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSSaveOptionsYes", INT2NUM(NSSaveOptionsYes));
  rb_define_const(mOSX, "NSSaveOptionsNo", INT2NUM(NSSaveOptionsNo));
  rb_define_const(mOSX, "NSSaveOptionsAsk", INT2NUM(NSSaveOptionsAsk));

}
