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


void init_NSProcessInfo(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSWindowsNTOperatingSystem", INT2NUM(NSWindowsNTOperatingSystem));
  rb_define_const(mOSX, "NSWindows95OperatingSystem", INT2NUM(NSWindows95OperatingSystem));
  rb_define_const(mOSX, "NSSolarisOperatingSystem", INT2NUM(NSSolarisOperatingSystem));
  rb_define_const(mOSX, "NSHPUXOperatingSystem", INT2NUM(NSHPUXOperatingSystem));
  rb_define_const(mOSX, "NSMACHOperatingSystem", INT2NUM(NSMACHOperatingSystem));
  rb_define_const(mOSX, "NSSunOSOperatingSystem", INT2NUM(NSSunOSOperatingSystem));
  rb_define_const(mOSX, "NSOSF1OperatingSystem", INT2NUM(NSOSF1OperatingSystem));

}
