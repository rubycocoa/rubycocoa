#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString *NSToolbarSeparatorItemIdentifier;
static VALUE
osx_NSToolbarSeparatorItemIdentifier(VALUE mdl)
{
  return ocobj_new_with_ocid(NSToolbarSeparatorItemIdentifier);
}

// NSString *NSToolbarSpaceItemIdentifier;
static VALUE
osx_NSToolbarSpaceItemIdentifier(VALUE mdl)
{
  return ocobj_new_with_ocid(NSToolbarSpaceItemIdentifier);
}

// NSString *NSToolbarFlexibleSpaceItemIdentifier;
static VALUE
osx_NSToolbarFlexibleSpaceItemIdentifier(VALUE mdl)
{
  return ocobj_new_with_ocid(NSToolbarFlexibleSpaceItemIdentifier);
}

// NSString *NSToolbarShowColorsItemIdentifier;
static VALUE
osx_NSToolbarShowColorsItemIdentifier(VALUE mdl)
{
  return ocobj_new_with_ocid(NSToolbarShowColorsItemIdentifier);
}

// NSString *NSToolbarShowFontsItemIdentifier;
static VALUE
osx_NSToolbarShowFontsItemIdentifier(VALUE mdl)
{
  return ocobj_new_with_ocid(NSToolbarShowFontsItemIdentifier);
}

// NSString *NSToolbarCustomizeToolbarItemIdentifier;
static VALUE
osx_NSToolbarCustomizeToolbarItemIdentifier(VALUE mdl)
{
  return ocobj_new_with_ocid(NSToolbarCustomizeToolbarItemIdentifier);
}

// NSString *NSToolbarPrintItemIdentifier;
static VALUE
osx_NSToolbarPrintItemIdentifier(VALUE mdl)
{
  return ocobj_new_with_ocid(NSToolbarPrintItemIdentifier);
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
