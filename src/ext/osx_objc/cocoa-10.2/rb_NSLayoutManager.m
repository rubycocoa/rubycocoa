#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


void init_NSLayoutManager(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSGlyphAttributeSoft", INT2NUM(NSGlyphAttributeSoft));
  rb_define_const(mOSX, "NSGlyphAttributeElastic", INT2NUM(NSGlyphAttributeElastic));
  rb_define_const(mOSX, "NSGlyphAttributeBidiLevel", INT2NUM(NSGlyphAttributeBidiLevel));
  rb_define_const(mOSX, "NSGlyphAttributeInscribe", INT2NUM(NSGlyphAttributeInscribe));
  rb_define_const(mOSX, "NSGlyphInscribeBase", INT2NUM(NSGlyphInscribeBase));
  rb_define_const(mOSX, "NSGlyphInscribeBelow", INT2NUM(NSGlyphInscribeBelow));
  rb_define_const(mOSX, "NSGlyphInscribeAbove", INT2NUM(NSGlyphInscribeAbove));
  rb_define_const(mOSX, "NSGlyphInscribeOverstrike", INT2NUM(NSGlyphInscribeOverstrike));
  rb_define_const(mOSX, "NSGlyphInscribeOverBelow", INT2NUM(NSGlyphInscribeOverBelow));
  rb_define_const(mOSX, "NSTypesetterLatestBehavior", INT2NUM(NSTypesetterLatestBehavior));
  rb_define_const(mOSX, "NSTypesetterOriginalBehavior", INT2NUM(NSTypesetterOriginalBehavior));
  rb_define_const(mOSX, "NSTypesetterBehavior_10_2_WithCompatibility", INT2NUM(NSTypesetterBehavior_10_2_WithCompatibility));
  rb_define_const(mOSX, "NSTypesetterBehavior_10_2", INT2NUM(NSTypesetterBehavior_10_2));

}
