#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString *NSFontAttributeName;
static VALUE
osx_NSFontAttributeName(VALUE mdl)
{
  return ocobj_new_with_ocid(NSFontAttributeName);
}

// NSString *NSParagraphStyleAttributeName;
static VALUE
osx_NSParagraphStyleAttributeName(VALUE mdl)
{
  return ocobj_new_with_ocid(NSParagraphStyleAttributeName);
}

// NSString *NSForegroundColorAttributeName;
static VALUE
osx_NSForegroundColorAttributeName(VALUE mdl)
{
  return ocobj_new_with_ocid(NSForegroundColorAttributeName);
}

// NSString *NSUnderlineStyleAttributeName;
static VALUE
osx_NSUnderlineStyleAttributeName(VALUE mdl)
{
  return ocobj_new_with_ocid(NSUnderlineStyleAttributeName);
}

// NSString *NSSuperscriptAttributeName;
static VALUE
osx_NSSuperscriptAttributeName(VALUE mdl)
{
  return ocobj_new_with_ocid(NSSuperscriptAttributeName);
}

// NSString *NSBackgroundColorAttributeName;
static VALUE
osx_NSBackgroundColorAttributeName(VALUE mdl)
{
  return ocobj_new_with_ocid(NSBackgroundColorAttributeName);
}

// NSString *NSAttachmentAttributeName;
static VALUE
osx_NSAttachmentAttributeName(VALUE mdl)
{
  return ocobj_new_with_ocid(NSAttachmentAttributeName);
}

// NSString *NSLigatureAttributeName;
static VALUE
osx_NSLigatureAttributeName(VALUE mdl)
{
  return ocobj_new_with_ocid(NSLigatureAttributeName);
}

// NSString *NSBaselineOffsetAttributeName;
static VALUE
osx_NSBaselineOffsetAttributeName(VALUE mdl)
{
  return ocobj_new_with_ocid(NSBaselineOffsetAttributeName);
}

// NSString *NSKernAttributeName;
static VALUE
osx_NSKernAttributeName(VALUE mdl)
{
  return ocobj_new_with_ocid(NSKernAttributeName);
}

// NSString *NSLinkAttributeName;
static VALUE
osx_NSLinkAttributeName(VALUE mdl)
{
  return ocobj_new_with_ocid(NSLinkAttributeName);
}

// NSString *NSCharacterShapeAttributeName;
static VALUE
osx_NSCharacterShapeAttributeName(VALUE mdl)
{
  return ocobj_new_with_ocid(NSCharacterShapeAttributeName);
}

// unsigned NSUnderlineByWordMask;
static VALUE
osx_NSUnderlineByWordMask(VALUE mdl)
{
  rb_notimplement();
}

// unsigned NSUnderlineStrikethroughMask;
static VALUE
osx_NSUnderlineStrikethroughMask(VALUE mdl)
{
  rb_notimplement();
}

// NSString *NSPlainTextDocumentType;
static VALUE
osx_NSPlainTextDocumentType(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPlainTextDocumentType);
}

// NSString *NSRTFTextDocumentType;
static VALUE
osx_NSRTFTextDocumentType(VALUE mdl)
{
  return ocobj_new_with_ocid(NSRTFTextDocumentType);
}

// NSString *NSRTFDTextDocumentType;
static VALUE
osx_NSRTFDTextDocumentType(VALUE mdl)
{
  return ocobj_new_with_ocid(NSRTFDTextDocumentType);
}

// NSString *NSMacSimpleTextDocumentType;
static VALUE
osx_NSMacSimpleTextDocumentType(VALUE mdl)
{
  return ocobj_new_with_ocid(NSMacSimpleTextDocumentType);
}

// NSString *NSHTMLTextDocumentType;
static VALUE
osx_NSHTMLTextDocumentType(VALUE mdl)
{
  return ocobj_new_with_ocid(NSHTMLTextDocumentType);
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
