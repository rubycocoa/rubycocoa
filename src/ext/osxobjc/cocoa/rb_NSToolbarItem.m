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
// NSString *NSToolbarSeparatorItemIdentifier;
static VALUE
osx_NSToolbarSeparatorItemIdentifier(VALUE mdl)
{
  NSString * ns_result = NSToolbarSeparatorItemIdentifier;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSToolbarSpaceItemIdentifier;
static VALUE
osx_NSToolbarSpaceItemIdentifier(VALUE mdl)
{
  NSString * ns_result = NSToolbarSpaceItemIdentifier;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSToolbarFlexibleSpaceItemIdentifier;
static VALUE
osx_NSToolbarFlexibleSpaceItemIdentifier(VALUE mdl)
{
  NSString * ns_result = NSToolbarFlexibleSpaceItemIdentifier;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSToolbarShowColorsItemIdentifier;
static VALUE
osx_NSToolbarShowColorsItemIdentifier(VALUE mdl)
{
  NSString * ns_result = NSToolbarShowColorsItemIdentifier;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSToolbarShowFontsItemIdentifier;
static VALUE
osx_NSToolbarShowFontsItemIdentifier(VALUE mdl)
{
  NSString * ns_result = NSToolbarShowFontsItemIdentifier;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSToolbarCustomizeToolbarItemIdentifier;
static VALUE
osx_NSToolbarCustomizeToolbarItemIdentifier(VALUE mdl)
{
  NSString * ns_result = NSToolbarCustomizeToolbarItemIdentifier;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSToolbarPrintItemIdentifier;
static VALUE
osx_NSToolbarPrintItemIdentifier(VALUE mdl)
{
  NSString * ns_result = NSToolbarPrintItemIdentifier;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
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
