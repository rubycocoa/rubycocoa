#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
#define VA_MAX 4


  /**** constants ****/
// NSString *NSFontAttributeName;
static VALUE
osx_NSFontAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFontAttributeName, nil);
}

// NSString *NSParagraphStyleAttributeName;
static VALUE
osx_NSParagraphStyleAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSParagraphStyleAttributeName, nil);
}

// NSString *NSForegroundColorAttributeName;
static VALUE
osx_NSForegroundColorAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSForegroundColorAttributeName, nil);
}

// NSString *NSUnderlineStyleAttributeName;
static VALUE
osx_NSUnderlineStyleAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSUnderlineStyleAttributeName, nil);
}

// NSString *NSSuperscriptAttributeName;
static VALUE
osx_NSSuperscriptAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSSuperscriptAttributeName, nil);
}

// NSString *NSBackgroundColorAttributeName;
static VALUE
osx_NSBackgroundColorAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSBackgroundColorAttributeName, nil);
}

// NSString *NSAttachmentAttributeName;
static VALUE
osx_NSAttachmentAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAttachmentAttributeName, nil);
}

// NSString *NSLigatureAttributeName;
static VALUE
osx_NSLigatureAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSLigatureAttributeName, nil);
}

// NSString *NSBaselineOffsetAttributeName;
static VALUE
osx_NSBaselineOffsetAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSBaselineOffsetAttributeName, nil);
}

// NSString *NSKernAttributeName;
static VALUE
osx_NSKernAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSKernAttributeName, nil);
}

// NSString *NSLinkAttributeName;
static VALUE
osx_NSLinkAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSLinkAttributeName, nil);
}

// NSString *NSCharacterShapeAttributeName;
static VALUE
osx_NSCharacterShapeAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSCharacterShapeAttributeName, nil);
}

// unsigned NSUnderlineByWordMask;
static VALUE
osx_NSUnderlineByWordMask(VALUE mdl)
{
  return nsresult_to_rbresult(_C_UINT, &NSUnderlineByWordMask, nil);
}

// unsigned NSUnderlineStrikethroughMask;
static VALUE
osx_NSUnderlineStrikethroughMask(VALUE mdl)
{
  return nsresult_to_rbresult(_C_UINT, &NSUnderlineStrikethroughMask, nil);
}

// NSString *NSPlainTextDocumentType;
static VALUE
osx_NSPlainTextDocumentType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSPlainTextDocumentType, nil);
}

// NSString *NSRTFTextDocumentType;
static VALUE
osx_NSRTFTextDocumentType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSRTFTextDocumentType, nil);
}

// NSString *NSRTFDTextDocumentType;
static VALUE
osx_NSRTFDTextDocumentType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSRTFDTextDocumentType, nil);
}

// NSString *NSMacSimpleTextDocumentType;
static VALUE
osx_NSMacSimpleTextDocumentType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSMacSimpleTextDocumentType, nil);
}

// NSString *NSHTMLTextDocumentType;
static VALUE
osx_NSHTMLTextDocumentType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSHTMLTextDocumentType, nil);
}

void init_NSAttributedString(VALUE mOSX)
{
  /**** enums ****/
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
  rb_define_module_function(mOSX, "NSCharacterShapeAttributeName", osx_NSCharacterShapeAttributeName, 0);
  rb_define_module_function(mOSX, "NSUnderlineByWordMask", osx_NSUnderlineByWordMask, 0);
  rb_define_module_function(mOSX, "NSUnderlineStrikethroughMask", osx_NSUnderlineStrikethroughMask, 0);
  rb_define_module_function(mOSX, "NSPlainTextDocumentType", osx_NSPlainTextDocumentType, 0);
  rb_define_module_function(mOSX, "NSRTFTextDocumentType", osx_NSRTFTextDocumentType, 0);
  rb_define_module_function(mOSX, "NSRTFDTextDocumentType", osx_NSRTFDTextDocumentType, 0);
  rb_define_module_function(mOSX, "NSMacSimpleTextDocumentType", osx_NSMacSimpleTextDocumentType, 0);
  rb_define_module_function(mOSX, "NSHTMLTextDocumentType", osx_NSHTMLTextDocumentType, 0);
}
