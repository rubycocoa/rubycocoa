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


void init_NSTabView(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSTopTabsBezelBorder", INT2NUM(NSTopTabsBezelBorder));
  rb_define_const(mOSX, "NSLeftTabsBezelBorder", INT2NUM(NSLeftTabsBezelBorder));
  rb_define_const(mOSX, "NSBottomTabsBezelBorder", INT2NUM(NSBottomTabsBezelBorder));
  rb_define_const(mOSX, "NSRightTabsBezelBorder", INT2NUM(NSRightTabsBezelBorder));
  rb_define_const(mOSX, "NSNoTabsBezelBorder", INT2NUM(NSNoTabsBezelBorder));
  rb_define_const(mOSX, "NSNoTabsLineBorder", INT2NUM(NSNoTabsLineBorder));
  rb_define_const(mOSX, "NSNoTabsNoBorder", INT2NUM(NSNoTabsNoBorder));

}
