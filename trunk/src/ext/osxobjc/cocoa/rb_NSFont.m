#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);


  /**** constants ****/
// const float *NSFontIdentityMatrix;
static VALUE
osx_NSFontIdentityMatrix(VALUE mdl)
{
  return nsresult_to_rbresult(_C_PTR, &NSFontIdentityMatrix, nil);
}

// NSString *NSAFMFamilyName;
static VALUE
osx_NSAFMFamilyName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAFMFamilyName, nil);
}

// NSString *NSAFMFontName;
static VALUE
osx_NSAFMFontName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAFMFontName, nil);
}

// NSString *NSAFMFormatVersion;
static VALUE
osx_NSAFMFormatVersion(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAFMFormatVersion, nil);
}

// NSString *NSAFMFullName;
static VALUE
osx_NSAFMFullName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAFMFullName, nil);
}

// NSString *NSAFMNotice;
static VALUE
osx_NSAFMNotice(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAFMNotice, nil);
}

// NSString *NSAFMVersion;
static VALUE
osx_NSAFMVersion(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAFMVersion, nil);
}

// NSString *NSAFMWeight;
static VALUE
osx_NSAFMWeight(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAFMWeight, nil);
}

// NSString *NSAFMEncodingScheme;
static VALUE
osx_NSAFMEncodingScheme(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAFMEncodingScheme, nil);
}

// NSString *NSAFMCharacterSet;
static VALUE
osx_NSAFMCharacterSet(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAFMCharacterSet, nil);
}

// NSString *NSAFMCapHeight;
static VALUE
osx_NSAFMCapHeight(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAFMCapHeight, nil);
}

// NSString *NSAFMXHeight;
static VALUE
osx_NSAFMXHeight(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAFMXHeight, nil);
}

// NSString *NSAFMAscender;
static VALUE
osx_NSAFMAscender(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAFMAscender, nil);
}

// NSString *NSAFMDescender;
static VALUE
osx_NSAFMDescender(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAFMDescender, nil);
}

// NSString *NSAFMUnderlinePosition;
static VALUE
osx_NSAFMUnderlinePosition(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAFMUnderlinePosition, nil);
}

// NSString *NSAFMUnderlineThickness;
static VALUE
osx_NSAFMUnderlineThickness(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAFMUnderlineThickness, nil);
}

// NSString *NSAFMItalicAngle;
static VALUE
osx_NSAFMItalicAngle(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAFMItalicAngle, nil);
}

// NSString *NSAFMMappingScheme;
static VALUE
osx_NSAFMMappingScheme(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAFMMappingScheme, nil);
}

void init_NSFont(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSControlGlyph", INT2NUM(NSControlGlyph));
  rb_define_const(mOSX, "NSNullGlyph", INT2NUM(NSNullGlyph));
  rb_define_const(mOSX, "NSGlyphBelow", INT2NUM(NSGlyphBelow));
  rb_define_const(mOSX, "NSGlyphAbove", INT2NUM(NSGlyphAbove));
  rb_define_const(mOSX, "NSOneByteGlyphPacking", INT2NUM(NSOneByteGlyphPacking));
  rb_define_const(mOSX, "NSJapaneseEUCGlyphPacking", INT2NUM(NSJapaneseEUCGlyphPacking));
  rb_define_const(mOSX, "NSAsciiWithDoubleByteEUCGlyphPacking", INT2NUM(NSAsciiWithDoubleByteEUCGlyphPacking));
  rb_define_const(mOSX, "NSTwoByteGlyphPacking", INT2NUM(NSTwoByteGlyphPacking));
  rb_define_const(mOSX, "NSFourByteGlyphPacking", INT2NUM(NSFourByteGlyphPacking));
  rb_define_const(mOSX, "NSNativeShortGlyphPacking", INT2NUM(NSNativeShortGlyphPacking));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSFontIdentityMatrix", osx_NSFontIdentityMatrix, 0);
  rb_define_module_function(mOSX, "NSAFMFamilyName", osx_NSAFMFamilyName, 0);
  rb_define_module_function(mOSX, "NSAFMFontName", osx_NSAFMFontName, 0);
  rb_define_module_function(mOSX, "NSAFMFormatVersion", osx_NSAFMFormatVersion, 0);
  rb_define_module_function(mOSX, "NSAFMFullName", osx_NSAFMFullName, 0);
  rb_define_module_function(mOSX, "NSAFMNotice", osx_NSAFMNotice, 0);
  rb_define_module_function(mOSX, "NSAFMVersion", osx_NSAFMVersion, 0);
  rb_define_module_function(mOSX, "NSAFMWeight", osx_NSAFMWeight, 0);
  rb_define_module_function(mOSX, "NSAFMEncodingScheme", osx_NSAFMEncodingScheme, 0);
  rb_define_module_function(mOSX, "NSAFMCharacterSet", osx_NSAFMCharacterSet, 0);
  rb_define_module_function(mOSX, "NSAFMCapHeight", osx_NSAFMCapHeight, 0);
  rb_define_module_function(mOSX, "NSAFMXHeight", osx_NSAFMXHeight, 0);
  rb_define_module_function(mOSX, "NSAFMAscender", osx_NSAFMAscender, 0);
  rb_define_module_function(mOSX, "NSAFMDescender", osx_NSAFMDescender, 0);
  rb_define_module_function(mOSX, "NSAFMUnderlinePosition", osx_NSAFMUnderlinePosition, 0);
  rb_define_module_function(mOSX, "NSAFMUnderlineThickness", osx_NSAFMUnderlineThickness, 0);
  rb_define_module_function(mOSX, "NSAFMItalicAngle", osx_NSAFMItalicAngle, 0);
  rb_define_module_function(mOSX, "NSAFMMappingScheme", osx_NSAFMMappingScheme, 0);
}
