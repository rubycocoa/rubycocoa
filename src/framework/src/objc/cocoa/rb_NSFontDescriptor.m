#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * NSFontFamilyAttribute;
static VALUE
osx_NSFontFamilyAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFontFamilyAttribute, "NSFontFamilyAttribute", nil);
}

// NSString * NSFontNameAttribute;
static VALUE
osx_NSFontNameAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFontNameAttribute, "NSFontNameAttribute", nil);
}

// NSString * NSFontFaceAttribute;
static VALUE
osx_NSFontFaceAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFontFaceAttribute, "NSFontFaceAttribute", nil);
}

// NSString * NSFontSizeAttribute;
static VALUE
osx_NSFontSizeAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFontSizeAttribute, "NSFontSizeAttribute", nil);
}

// NSString * NSFontVisibleNameAttribute;
static VALUE
osx_NSFontVisibleNameAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFontVisibleNameAttribute, "NSFontVisibleNameAttribute", nil);
}

// NSString * NSFontColorAttribute;
static VALUE
osx_NSFontColorAttribute(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFontColorAttribute, "NSFontColorAttribute", nil);
}

void init_NSFontDescriptor(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSFontFamilyAttribute", osx_NSFontFamilyAttribute, 0);
  rb_define_module_function(mOSX, "NSFontNameAttribute", osx_NSFontNameAttribute, 0);
  rb_define_module_function(mOSX, "NSFontFaceAttribute", osx_NSFontFaceAttribute, 0);
  rb_define_module_function(mOSX, "NSFontSizeAttribute", osx_NSFontSizeAttribute, 0);
  rb_define_module_function(mOSX, "NSFontVisibleNameAttribute", osx_NSFontVisibleNameAttribute, 0);
  rb_define_module_function(mOSX, "NSFontColorAttribute", osx_NSFontColorAttribute, 0);
}
