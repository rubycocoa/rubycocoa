#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// const float *NSFontIdentityMatrix;
static VALUE
osx_NSFontIdentityMatrix(VALUE mdl)
{
  rb_notimplement();
}

// NSString *NSAFMFamilyName;
static VALUE
osx_NSAFMFamilyName(VALUE mdl)
{
  return ocobj_new_with_ocid(NSAFMFamilyName);
}

// NSString *NSAFMFontName;
static VALUE
osx_NSAFMFontName(VALUE mdl)
{
  return ocobj_new_with_ocid(NSAFMFontName);
}

// NSString *NSAFMFormatVersion;
static VALUE
osx_NSAFMFormatVersion(VALUE mdl)
{
  return ocobj_new_with_ocid(NSAFMFormatVersion);
}

// NSString *NSAFMFullName;
static VALUE
osx_NSAFMFullName(VALUE mdl)
{
  return ocobj_new_with_ocid(NSAFMFullName);
}

// NSString *NSAFMNotice;
static VALUE
osx_NSAFMNotice(VALUE mdl)
{
  return ocobj_new_with_ocid(NSAFMNotice);
}

// NSString *NSAFMVersion;
static VALUE
osx_NSAFMVersion(VALUE mdl)
{
  return ocobj_new_with_ocid(NSAFMVersion);
}

// NSString *NSAFMWeight;
static VALUE
osx_NSAFMWeight(VALUE mdl)
{
  return ocobj_new_with_ocid(NSAFMWeight);
}

// NSString *NSAFMEncodingScheme;
static VALUE
osx_NSAFMEncodingScheme(VALUE mdl)
{
  return ocobj_new_with_ocid(NSAFMEncodingScheme);
}

// NSString *NSAFMCharacterSet;
static VALUE
osx_NSAFMCharacterSet(VALUE mdl)
{
  return ocobj_new_with_ocid(NSAFMCharacterSet);
}

// NSString *NSAFMCapHeight;
static VALUE
osx_NSAFMCapHeight(VALUE mdl)
{
  return ocobj_new_with_ocid(NSAFMCapHeight);
}

// NSString *NSAFMXHeight;
static VALUE
osx_NSAFMXHeight(VALUE mdl)
{
  return ocobj_new_with_ocid(NSAFMXHeight);
}

// NSString *NSAFMAscender;
static VALUE
osx_NSAFMAscender(VALUE mdl)
{
  return ocobj_new_with_ocid(NSAFMAscender);
}

// NSString *NSAFMDescender;
static VALUE
osx_NSAFMDescender(VALUE mdl)
{
  return ocobj_new_with_ocid(NSAFMDescender);
}

// NSString *NSAFMUnderlinePosition;
static VALUE
osx_NSAFMUnderlinePosition(VALUE mdl)
{
  return ocobj_new_with_ocid(NSAFMUnderlinePosition);
}

// NSString *NSAFMUnderlineThickness;
static VALUE
osx_NSAFMUnderlineThickness(VALUE mdl)
{
  return ocobj_new_with_ocid(NSAFMUnderlineThickness);
}

// NSString *NSAFMItalicAngle;
static VALUE
osx_NSAFMItalicAngle(VALUE mdl)
{
  return ocobj_new_with_ocid(NSAFMItalicAngle);
}

// NSString *NSAFMMappingScheme;
static VALUE
osx_NSAFMMappingScheme(VALUE mdl)
{
  return ocobj_new_with_ocid(NSAFMMappingScheme);
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
