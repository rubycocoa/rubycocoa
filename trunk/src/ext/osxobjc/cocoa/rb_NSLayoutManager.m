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


void init_NSLayoutManager(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSGlyphAttributeSoft", INT2NUM(NSGlyphAttributeSoft));
  rb_define_const(mOSX, "NSGlyphAttributeElastic", INT2NUM(NSGlyphAttributeElastic));
  rb_define_const(mOSX, "NSGlyphAttributeInscribe", INT2NUM(NSGlyphAttributeInscribe));
  rb_define_const(mOSX, "NSGlyphInscribeBase", INT2NUM(NSGlyphInscribeBase));
  rb_define_const(mOSX, "NSGlyphInscribeBelow", INT2NUM(NSGlyphInscribeBelow));
  rb_define_const(mOSX, "NSGlyphInscribeAbove", INT2NUM(NSGlyphInscribeAbove));
  rb_define_const(mOSX, "NSGlyphInscribeOverstrike", INT2NUM(NSGlyphInscribeOverstrike));
  rb_define_const(mOSX, "NSGlyphInscribeOverBelow", INT2NUM(NSGlyphInscribeOverBelow));

}
