#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString *NSToolbarSeparatorItemIdentifier;
static VALUE
osx_NSToolbarSeparatorItemIdentifier(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSToolbarSeparatorItemIdentifier, nil);
}

// NSString *NSToolbarSpaceItemIdentifier;
static VALUE
osx_NSToolbarSpaceItemIdentifier(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSToolbarSpaceItemIdentifier, nil);
}

// NSString *NSToolbarFlexibleSpaceItemIdentifier;
static VALUE
osx_NSToolbarFlexibleSpaceItemIdentifier(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSToolbarFlexibleSpaceItemIdentifier, nil);
}

// NSString *NSToolbarShowColorsItemIdentifier;
static VALUE
osx_NSToolbarShowColorsItemIdentifier(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSToolbarShowColorsItemIdentifier, nil);
}

// NSString *NSToolbarShowFontsItemIdentifier;
static VALUE
osx_NSToolbarShowFontsItemIdentifier(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSToolbarShowFontsItemIdentifier, nil);
}

// NSString *NSToolbarCustomizeToolbarItemIdentifier;
static VALUE
osx_NSToolbarCustomizeToolbarItemIdentifier(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSToolbarCustomizeToolbarItemIdentifier, nil);
}

// NSString *NSToolbarPrintItemIdentifier;
static VALUE
osx_NSToolbarPrintItemIdentifier(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSToolbarPrintItemIdentifier, nil);
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
