#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * NSFontAttributeName;
static VALUE
osx_NSFontAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFontAttributeName, "NSFontAttributeName", nil);
}

// NSString * NSParagraphStyleAttributeName;
static VALUE
osx_NSParagraphStyleAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSParagraphStyleAttributeName, "NSParagraphStyleAttributeName", nil);
}

// NSString * NSForegroundColorAttributeName;
static VALUE
osx_NSForegroundColorAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSForegroundColorAttributeName, "NSForegroundColorAttributeName", nil);
}

// NSString * NSUnderlineStyleAttributeName;
static VALUE
osx_NSUnderlineStyleAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSUnderlineStyleAttributeName, "NSUnderlineStyleAttributeName", nil);
}

// NSString * NSSuperscriptAttributeName;
static VALUE
osx_NSSuperscriptAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSSuperscriptAttributeName, "NSSuperscriptAttributeName", nil);
}

// NSString * NSBackgroundColorAttributeName;
static VALUE
osx_NSBackgroundColorAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSBackgroundColorAttributeName, "NSBackgroundColorAttributeName", nil);
}

// NSString * NSAttachmentAttributeName;
static VALUE
osx_NSAttachmentAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAttachmentAttributeName, "NSAttachmentAttributeName", nil);
}

// NSString * NSLigatureAttributeName;
static VALUE
osx_NSLigatureAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSLigatureAttributeName, "NSLigatureAttributeName", nil);
}

// NSString * NSBaselineOffsetAttributeName;
static VALUE
osx_NSBaselineOffsetAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSBaselineOffsetAttributeName, "NSBaselineOffsetAttributeName", nil);
}

// NSString * NSKernAttributeName;
static VALUE
osx_NSKernAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSKernAttributeName, "NSKernAttributeName", nil);
}

// NSString * NSLinkAttributeName;
static VALUE
osx_NSLinkAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSLinkAttributeName, "NSLinkAttributeName", nil);
}

// NSString * NSStrokeWidthAttributeName;
static VALUE
osx_NSStrokeWidthAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSStrokeWidthAttributeName, "NSStrokeWidthAttributeName", nil);
}

// NSString * NSStrokeColorAttributeName;
static VALUE
osx_NSStrokeColorAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSStrokeColorAttributeName, "NSStrokeColorAttributeName", nil);
}

// NSString * NSUnderlineColorAttributeName;
static VALUE
osx_NSUnderlineColorAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSUnderlineColorAttributeName, "NSUnderlineColorAttributeName", nil);
}

// NSString * NSStrikethroughStyleAttributeName;
static VALUE
osx_NSStrikethroughStyleAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSStrikethroughStyleAttributeName, "NSStrikethroughStyleAttributeName", nil);
}

// NSString * NSStrikethroughColorAttributeName;
static VALUE
osx_NSStrikethroughColorAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSStrikethroughColorAttributeName, "NSStrikethroughColorAttributeName", nil);
}

// NSString * NSShadowAttributeName;
static VALUE
osx_NSShadowAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSShadowAttributeName, "NSShadowAttributeName", nil);
}

// NSString * NSObliquenessAttributeName;
static VALUE
osx_NSObliquenessAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSObliquenessAttributeName, "NSObliquenessAttributeName", nil);
}

// NSString * NSExpansionAttributeName;
static VALUE
osx_NSExpansionAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSExpansionAttributeName, "NSExpansionAttributeName", nil);
}

// NSString * NSCursorAttributeName;
static VALUE
osx_NSCursorAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSCursorAttributeName, "NSCursorAttributeName", nil);
}

// NSString * NSToolTipAttributeName;
static VALUE
osx_NSToolTipAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSToolTipAttributeName, "NSToolTipAttributeName", nil);
}

// NSString * NSCharacterShapeAttributeName;
static VALUE
osx_NSCharacterShapeAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSCharacterShapeAttributeName, "NSCharacterShapeAttributeName", nil);
}

// NSString * NSGlyphInfoAttributeName;
static VALUE
osx_NSGlyphInfoAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSGlyphInfoAttributeName, "NSGlyphInfoAttributeName", nil);
}

// unsigned NSUnderlineByWordMask;
static VALUE
osx_NSUnderlineByWordMask(VALUE mdl)
{
  return nsresult_to_rbresult(_C_UINT, &NSUnderlineByWordMask, "NSUnderlineByWordMask", nil);
}

// NSString * NSPlainTextDocumentType;
static VALUE
osx_NSPlainTextDocumentType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSPlainTextDocumentType, "NSPlainTextDocumentType", nil);
}

// NSString * NSRTFTextDocumentType;
static VALUE
osx_NSRTFTextDocumentType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSRTFTextDocumentType, "NSRTFTextDocumentType", nil);
}

// NSString * NSRTFDTextDocumentType;
static VALUE
osx_NSRTFDTextDocumentType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSRTFDTextDocumentType, "NSRTFDTextDocumentType", nil);
}

// NSString * NSMacSimpleTextDocumentType;
static VALUE
osx_NSMacSimpleTextDocumentType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSMacSimpleTextDocumentType, "NSMacSimpleTextDocumentType", nil);
}

// NSString * NSHTMLTextDocumentType;
static VALUE
osx_NSHTMLTextDocumentType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSHTMLTextDocumentType, "NSHTMLTextDocumentType", nil);
}

// NSString * NSDocFormatTextDocumentType;
static VALUE
osx_NSDocFormatTextDocumentType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSDocFormatTextDocumentType, "NSDocFormatTextDocumentType", nil);
}

// NSString * NSWordMLTextDocumentType;
static VALUE
osx_NSWordMLTextDocumentType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWordMLTextDocumentType, "NSWordMLTextDocumentType", nil);
}

// unsigned NSUnderlineStrikethroughMask;
static VALUE
osx_NSUnderlineStrikethroughMask(VALUE mdl)
{
  return nsresult_to_rbresult(_C_UINT, &NSUnderlineStrikethroughMask, "NSUnderlineStrikethroughMask", nil);
}

void init_NSAttributedString(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSUnderlineStyleNone", INT2NUM(NSUnderlineStyleNone));
  rb_define_const(mOSX, "NSUnderlineStyleSingle", INT2NUM(NSUnderlineStyleSingle));
  rb_define_const(mOSX, "NSUnderlineStyleThick", INT2NUM(NSUnderlineStyleThick));
  rb_define_const(mOSX, "NSUnderlineStyleDouble", INT2NUM(NSUnderlineStyleDouble));
  rb_define_const(mOSX, "NSUnderlinePatternSolid", INT2NUM(NSUnderlinePatternSolid));
  rb_define_const(mOSX, "NSUnderlinePatternDot", INT2NUM(NSUnderlinePatternDot));
  rb_define_const(mOSX, "NSUnderlinePatternDash", INT2NUM(NSUnderlinePatternDash));
  rb_define_const(mOSX, "NSUnderlinePatternDashDot", INT2NUM(NSUnderlinePatternDashDot));
  rb_define_const(mOSX, "NSUnderlinePatternDashDotDot", INT2NUM(NSUnderlinePatternDashDotDot));
  rb_define_const(mOSX, "NSNoUnderlineStyle", INT2NUM(NSNoUnderlineStyle));
  rb_define_const(mOSX, "NSSingleUnderlineStyle", INT2NUM(NSSingleUnderlineStyle));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSFontAttributeName", osx_NSFontAttributeName, 0);
  rb_define_module_function(mOSX, "NSParagraphStyleAttributeName", osx_NSParagraphStyleAttributeName, 0);
  rb_define_module_function(mOSX, "NSForegroundColorAttributeName", osx_NSForegroundColorAttributeName, 0);
  rb_define_module_function(mOSX, "NSUnderlineStyleAttributeName", osx_NSUnderlineStyleAttributeName, 0);
  rb_define_module_function(mOSX, "NSSuperscriptAttributeName", osx_NSSuperscriptAttributeName, 0);
  rb_define_module_function(mOSX, "NSBackgroundColorAttributeName", osx_NSBackgroundColorAttributeName, 0);
  rb_define_module_function(mOSX, "NSAttachmentAttributeName", osx_NSAttachmentAttributeName, 0);
  rb_define_module_function(mOSX, "NSLigatureAttributeName", osx_NSLigatureAttributeName, 0);
  rb_define_module_function(mOSX, "NSBaselineOffsetAttributeName", osx_NSBaselineOffsetAttributeName, 0);
  rb_define_module_function(mOSX, "NSKernAttributeName", osx_NSKernAttributeName, 0);
  rb_define_module_function(mOSX, "NSLinkAttributeName", osx_NSLinkAttributeName, 0);
  rb_define_module_function(mOSX, "NSStrokeWidthAttributeName", osx_NSStrokeWidthAttributeName, 0);
  rb_define_module_function(mOSX, "NSStrokeColorAttributeName", osx_NSStrokeColorAttributeName, 0);
  rb_define_module_function(mOSX, "NSUnderlineColorAttributeName", osx_NSUnderlineColorAttributeName, 0);
  rb_define_module_function(mOSX, "NSStrikethroughStyleAttributeName", osx_NSStrikethroughStyleAttributeName, 0);
  rb_define_module_function(mOSX, "NSStrikethroughColorAttributeName", osx_NSStrikethroughColorAttributeName, 0);
  rb_define_module_function(mOSX, "NSShadowAttributeName", osx_NSShadowAttributeName, 0);
  rb_define_module_function(mOSX, "NSObliquenessAttributeName", osx_NSObliquenessAttributeName, 0);
  rb_define_module_function(mOSX, "NSExpansionAttributeName", osx_NSExpansionAttributeName, 0);
  rb_define_module_function(mOSX, "NSCursorAttributeName", osx_NSCursorAttributeName, 0);
  rb_define_module_function(mOSX, "NSToolTipAttributeName", osx_NSToolTipAttributeName, 0);
  rb_define_module_function(mOSX, "NSCharacterShapeAttributeName", osx_NSCharacterShapeAttributeName, 0);
  rb_define_module_function(mOSX, "NSGlyphInfoAttributeName", osx_NSGlyphInfoAttributeName, 0);
  rb_define_module_function(mOSX, "NSUnderlineByWordMask", osx_NSUnderlineByWordMask, 0);
  rb_define_module_function(mOSX, "NSPlainTextDocumentType", osx_NSPlainTextDocumentType, 0);
  rb_define_module_function(mOSX, "NSRTFTextDocumentType", osx_NSRTFTextDocumentType, 0);
  rb_define_module_function(mOSX, "NSRTFDTextDocumentType", osx_NSRTFDTextDocumentType, 0);
  rb_define_module_function(mOSX, "NSMacSimpleTextDocumentType", osx_NSMacSimpleTextDocumentType, 0);
  rb_define_module_function(mOSX, "NSHTMLTextDocumentType", osx_NSHTMLTextDocumentType, 0);
  rb_define_module_function(mOSX, "NSDocFormatTextDocumentType", osx_NSDocFormatTextDocumentType, 0);
  rb_define_module_function(mOSX, "NSWordMLTextDocumentType", osx_NSWordMLTextDocumentType, 0);
  rb_define_module_function(mOSX, "NSUnderlineStrikethroughMask", osx_NSUnderlineStrikethroughMask, 0);
}
