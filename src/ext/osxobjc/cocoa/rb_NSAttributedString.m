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
// NSString *NSFontAttributeName;
static VALUE
osx_NSFontAttributeName(VALUE mdl)
{
  NSString * ns_result = NSFontAttributeName;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSParagraphStyleAttributeName;
static VALUE
osx_NSParagraphStyleAttributeName(VALUE mdl)
{
  NSString * ns_result = NSParagraphStyleAttributeName;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSForegroundColorAttributeName;
static VALUE
osx_NSForegroundColorAttributeName(VALUE mdl)
{
  NSString * ns_result = NSForegroundColorAttributeName;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSUnderlineStyleAttributeName;
static VALUE
osx_NSUnderlineStyleAttributeName(VALUE mdl)
{
  NSString * ns_result = NSUnderlineStyleAttributeName;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSSuperscriptAttributeName;
static VALUE
osx_NSSuperscriptAttributeName(VALUE mdl)
{
  NSString * ns_result = NSSuperscriptAttributeName;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSBackgroundColorAttributeName;
static VALUE
osx_NSBackgroundColorAttributeName(VALUE mdl)
{
  NSString * ns_result = NSBackgroundColorAttributeName;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSAttachmentAttributeName;
static VALUE
osx_NSAttachmentAttributeName(VALUE mdl)
{
  NSString * ns_result = NSAttachmentAttributeName;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSLigatureAttributeName;
static VALUE
osx_NSLigatureAttributeName(VALUE mdl)
{
  NSString * ns_result = NSLigatureAttributeName;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSBaselineOffsetAttributeName;
static VALUE
osx_NSBaselineOffsetAttributeName(VALUE mdl)
{
  NSString * ns_result = NSBaselineOffsetAttributeName;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSKernAttributeName;
static VALUE
osx_NSKernAttributeName(VALUE mdl)
{
  NSString * ns_result = NSKernAttributeName;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSLinkAttributeName;
static VALUE
osx_NSLinkAttributeName(VALUE mdl)
{
  NSString * ns_result = NSLinkAttributeName;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSCharacterShapeAttributeName;
static VALUE
osx_NSCharacterShapeAttributeName(VALUE mdl)
{
  NSString * ns_result = NSCharacterShapeAttributeName;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
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
  NSString * ns_result = NSPlainTextDocumentType;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSRTFTextDocumentType;
static VALUE
osx_NSRTFTextDocumentType(VALUE mdl)
{
  NSString * ns_result = NSRTFTextDocumentType;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSRTFDTextDocumentType;
static VALUE
osx_NSRTFDTextDocumentType(VALUE mdl)
{
  NSString * ns_result = NSRTFDTextDocumentType;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSMacSimpleTextDocumentType;
static VALUE
osx_NSMacSimpleTextDocumentType(VALUE mdl)
{
  NSString * ns_result = NSMacSimpleTextDocumentType;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSHTMLTextDocumentType;
static VALUE
osx_NSHTMLTextDocumentType(VALUE mdl)
{
  NSString * ns_result = NSHTMLTextDocumentType;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
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
