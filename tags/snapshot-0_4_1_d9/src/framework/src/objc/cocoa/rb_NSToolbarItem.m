#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * NSToolbarSeparatorItemIdentifier;
static VALUE
osx_NSToolbarSeparatorItemIdentifier(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSToolbarSeparatorItemIdentifier, "NSToolbarSeparatorItemIdentifier", nil);
}

// NSString * NSToolbarSpaceItemIdentifier;
static VALUE
osx_NSToolbarSpaceItemIdentifier(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSToolbarSpaceItemIdentifier, "NSToolbarSpaceItemIdentifier", nil);
}

// NSString * NSToolbarFlexibleSpaceItemIdentifier;
static VALUE
osx_NSToolbarFlexibleSpaceItemIdentifier(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSToolbarFlexibleSpaceItemIdentifier, "NSToolbarFlexibleSpaceItemIdentifier", nil);
}

// NSString * NSToolbarShowColorsItemIdentifier;
static VALUE
osx_NSToolbarShowColorsItemIdentifier(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSToolbarShowColorsItemIdentifier, "NSToolbarShowColorsItemIdentifier", nil);
}

// NSString * NSToolbarShowFontsItemIdentifier;
static VALUE
osx_NSToolbarShowFontsItemIdentifier(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSToolbarShowFontsItemIdentifier, "NSToolbarShowFontsItemIdentifier", nil);
}

// NSString * NSToolbarCustomizeToolbarItemIdentifier;
static VALUE
osx_NSToolbarCustomizeToolbarItemIdentifier(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSToolbarCustomizeToolbarItemIdentifier, "NSToolbarCustomizeToolbarItemIdentifier", nil);
}

// NSString * NSToolbarPrintItemIdentifier;
static VALUE
osx_NSToolbarPrintItemIdentifier(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSToolbarPrintItemIdentifier, "NSToolbarPrintItemIdentifier", nil);
}

void init_NSToolbarItem(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSToolbarSeparatorItemIdentifier", osx_NSToolbarSeparatorItemIdentifier, 0);
  rb_define_module_function(mOSX, "NSToolbarSpaceItemIdentifier", osx_NSToolbarSpaceItemIdentifier, 0);
  rb_define_module_function(mOSX, "NSToolbarFlexibleSpaceItemIdentifier", osx_NSToolbarFlexibleSpaceItemIdentifier, 0);
  rb_define_module_function(mOSX, "NSToolbarShowColorsItemIdentifier", osx_NSToolbarShowColorsItemIdentifier, 0);
  rb_define_module_function(mOSX, "NSToolbarShowFontsItemIdentifier", osx_NSToolbarShowFontsItemIdentifier, 0);
  rb_define_module_function(mOSX, "NSToolbarCustomizeToolbarItemIdentifier", osx_NSToolbarCustomizeToolbarItemIdentifier, 0);
  rb_define_module_function(mOSX, "NSToolbarPrintItemIdentifier", osx_NSToolbarPrintItemIdentifier, 0);
}
