#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

void init_NSFontManager(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSItalicFontMask", INT2NUM(NSItalicFontMask));
  rb_define_const(mOSX, "NSBoldFontMask", INT2NUM(NSBoldFontMask));
  rb_define_const(mOSX, "NSUnboldFontMask", INT2NUM(NSUnboldFontMask));
  rb_define_const(mOSX, "NSNonStandardCharacterSetFontMask", INT2NUM(NSNonStandardCharacterSetFontMask));
  rb_define_const(mOSX, "NSNarrowFontMask", INT2NUM(NSNarrowFontMask));
  rb_define_const(mOSX, "NSExpandedFontMask", INT2NUM(NSExpandedFontMask));
  rb_define_const(mOSX, "NSCondensedFontMask", INT2NUM(NSCondensedFontMask));
  rb_define_const(mOSX, "NSSmallCapsFontMask", INT2NUM(NSSmallCapsFontMask));
  rb_define_const(mOSX, "NSPosterFontMask", INT2NUM(NSPosterFontMask));
  rb_define_const(mOSX, "NSCompressedFontMask", INT2NUM(NSCompressedFontMask));
  rb_define_const(mOSX, "NSFixedPitchFontMask", INT2NUM(NSFixedPitchFontMask));
  rb_define_const(mOSX, "NSUnitalicFontMask", INT2NUM(NSUnitalicFontMask));
  rb_define_const(mOSX, "NSNoFontChangeAction", INT2NUM(NSNoFontChangeAction));
  rb_define_const(mOSX, "NSViaPanelFontAction", INT2NUM(NSViaPanelFontAction));
  rb_define_const(mOSX, "NSAddTraitFontAction", INT2NUM(NSAddTraitFontAction));
  rb_define_const(mOSX, "NSSizeUpFontAction", INT2NUM(NSSizeUpFontAction));
  rb_define_const(mOSX, "NSSizeDownFontAction", INT2NUM(NSSizeDownFontAction));
  rb_define_const(mOSX, "NSHeavierFontAction", INT2NUM(NSHeavierFontAction));
  rb_define_const(mOSX, "NSLighterFontAction", INT2NUM(NSLighterFontAction));
  rb_define_const(mOSX, "NSRemoveTraitFontAction", INT2NUM(NSRemoveTraitFontAction));

}
