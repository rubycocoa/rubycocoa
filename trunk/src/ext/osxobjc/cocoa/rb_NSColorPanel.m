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
// NSString *NSColorPanelColorDidChangeNotification;
static VALUE
osx_NSColorPanelColorDidChangeNotification(VALUE mdl)
{
  NSString * ns_result = NSColorPanelColorDidChangeNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

void init_NSColorPanel(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSGrayModeColorPanel", INT2NUM(NSGrayModeColorPanel));
  rb_define_const(mOSX, "NSRGBModeColorPanel", INT2NUM(NSRGBModeColorPanel));
  rb_define_const(mOSX, "NSCMYKModeColorPanel", INT2NUM(NSCMYKModeColorPanel));
  rb_define_const(mOSX, "NSHSBModeColorPanel", INT2NUM(NSHSBModeColorPanel));
  rb_define_const(mOSX, "NSCustomPaletteModeColorPanel", INT2NUM(NSCustomPaletteModeColorPanel));
  rb_define_const(mOSX, "NSColorListModeColorPanel", INT2NUM(NSColorListModeColorPanel));
  rb_define_const(mOSX, "NSWheelModeColorPanel", INT2NUM(NSWheelModeColorPanel));
  rb_define_const(mOSX, "NSColorPanelGrayModeMask", INT2NUM(NSColorPanelGrayModeMask));
  rb_define_const(mOSX, "NSColorPanelRGBModeMask", INT2NUM(NSColorPanelRGBModeMask));
  rb_define_const(mOSX, "NSColorPanelCMYKModeMask", INT2NUM(NSColorPanelCMYKModeMask));
  rb_define_const(mOSX, "NSColorPanelHSBModeMask", INT2NUM(NSColorPanelHSBModeMask));
  rb_define_const(mOSX, "NSColorPanelCustomPaletteModeMask", INT2NUM(NSColorPanelCustomPaletteModeMask));
  rb_define_const(mOSX, "NSColorPanelColorListModeMask", INT2NUM(NSColorPanelColorListModeMask));
  rb_define_const(mOSX, "NSColorPanelWheelModeMask", INT2NUM(NSColorPanelWheelModeMask));
  rb_define_const(mOSX, "NSColorPanelAllModesMask", INT2NUM(NSColorPanelAllModesMask));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSColorPanelColorDidChangeNotification", osx_NSColorPanelColorDidChangeNotification, 0);
}
