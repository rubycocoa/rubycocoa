#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


void init_NSGlyphInfo(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSIdentityMappingCharacterCollection", INT2NUM(NSIdentityMappingCharacterCollection));
  rb_define_const(mOSX, "NSAdobeCNS1CharacterCollection", INT2NUM(NSAdobeCNS1CharacterCollection));
  rb_define_const(mOSX, "NSAdobeGB1CharacterCollection", INT2NUM(NSAdobeGB1CharacterCollection));
  rb_define_const(mOSX, "NSAdobeJapan1CharacterCollection", INT2NUM(NSAdobeJapan1CharacterCollection));
  rb_define_const(mOSX, "NSAdobeJapan2CharacterCollection", INT2NUM(NSAdobeJapan2CharacterCollection));
  rb_define_const(mOSX, "NSAdobeKorea1CharacterCollection", INT2NUM(NSAdobeKorea1CharacterCollection));

}
