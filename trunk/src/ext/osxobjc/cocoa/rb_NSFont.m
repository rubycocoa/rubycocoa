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


  /**** constants ****/
// const float *NSFontIdentityMatrix;
static VALUE
osx_NSFontIdentityMatrix(VALUE mdl)
{
  const float * ns_result = NSFontIdentityMatrix;
  return nsresult_to_rbresult(_C_PTR, &ns_result, nil);
}

// NSString *NSAFMFamilyName;
static VALUE
osx_NSAFMFamilyName(VALUE mdl)
{
  NSString * ns_result = NSAFMFamilyName;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSAFMFontName;
static VALUE
osx_NSAFMFontName(VALUE mdl)
{
  NSString * ns_result = NSAFMFontName;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSAFMFormatVersion;
static VALUE
osx_NSAFMFormatVersion(VALUE mdl)
{
  NSString * ns_result = NSAFMFormatVersion;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSAFMFullName;
static VALUE
osx_NSAFMFullName(VALUE mdl)
{
  NSString * ns_result = NSAFMFullName;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSAFMNotice;
static VALUE
osx_NSAFMNotice(VALUE mdl)
{
  NSString * ns_result = NSAFMNotice;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSAFMVersion;
static VALUE
osx_NSAFMVersion(VALUE mdl)
{
  NSString * ns_result = NSAFMVersion;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSAFMWeight;
static VALUE
osx_NSAFMWeight(VALUE mdl)
{
  NSString * ns_result = NSAFMWeight;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSAFMEncodingScheme;
static VALUE
osx_NSAFMEncodingScheme(VALUE mdl)
{
  NSString * ns_result = NSAFMEncodingScheme;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSAFMCharacterSet;
static VALUE
osx_NSAFMCharacterSet(VALUE mdl)
{
  NSString * ns_result = NSAFMCharacterSet;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSAFMCapHeight;
static VALUE
osx_NSAFMCapHeight(VALUE mdl)
{
  NSString * ns_result = NSAFMCapHeight;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSAFMXHeight;
static VALUE
osx_NSAFMXHeight(VALUE mdl)
{
  NSString * ns_result = NSAFMXHeight;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSAFMAscender;
static VALUE
osx_NSAFMAscender(VALUE mdl)
{
  NSString * ns_result = NSAFMAscender;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSAFMDescender;
static VALUE
osx_NSAFMDescender(VALUE mdl)
{
  NSString * ns_result = NSAFMDescender;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSAFMUnderlinePosition;
static VALUE
osx_NSAFMUnderlinePosition(VALUE mdl)
{
  NSString * ns_result = NSAFMUnderlinePosition;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSAFMUnderlineThickness;
static VALUE
osx_NSAFMUnderlineThickness(VALUE mdl)
{
  NSString * ns_result = NSAFMUnderlineThickness;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSAFMItalicAngle;
static VALUE
osx_NSAFMItalicAngle(VALUE mdl)
{
  NSString * ns_result = NSAFMItalicAngle;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSAFMMappingScheme;
static VALUE
osx_NSAFMMappingScheme(VALUE mdl)
{
  NSString * ns_result = NSAFMMappingScheme;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
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
