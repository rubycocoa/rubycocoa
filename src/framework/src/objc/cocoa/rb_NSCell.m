#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * NSControlTintDidChangeNotification;
static VALUE
osx_NSControlTintDidChangeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSControlTintDidChangeNotification, "NSControlTintDidChangeNotification", nil);
}

void init_NSCell(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSAnyType", INT2NUM(NSAnyType));
  rb_define_const(mOSX, "NSIntType", INT2NUM(NSIntType));
  rb_define_const(mOSX, "NSPositiveIntType", INT2NUM(NSPositiveIntType));
  rb_define_const(mOSX, "NSFloatType", INT2NUM(NSFloatType));
  rb_define_const(mOSX, "NSPositiveFloatType", INT2NUM(NSPositiveFloatType));
  rb_define_const(mOSX, "NSDoubleType", INT2NUM(NSDoubleType));
  rb_define_const(mOSX, "NSPositiveDoubleType", INT2NUM(NSPositiveDoubleType));
  rb_define_const(mOSX, "NSNullCellType", INT2NUM(NSNullCellType));
  rb_define_const(mOSX, "NSTextCellType", INT2NUM(NSTextCellType));
  rb_define_const(mOSX, "NSImageCellType", INT2NUM(NSImageCellType));
  rb_define_const(mOSX, "NSCellDisabled", INT2NUM(NSCellDisabled));
  rb_define_const(mOSX, "NSCellState", INT2NUM(NSCellState));
  rb_define_const(mOSX, "NSPushInCell", INT2NUM(NSPushInCell));
  rb_define_const(mOSX, "NSCellEditable", INT2NUM(NSCellEditable));
  rb_define_const(mOSX, "NSChangeGrayCell", INT2NUM(NSChangeGrayCell));
  rb_define_const(mOSX, "NSCellHighlighted", INT2NUM(NSCellHighlighted));
  rb_define_const(mOSX, "NSCellLightsByContents", INT2NUM(NSCellLightsByContents));
  rb_define_const(mOSX, "NSCellLightsByGray", INT2NUM(NSCellLightsByGray));
  rb_define_const(mOSX, "NSChangeBackgroundCell", INT2NUM(NSChangeBackgroundCell));
  rb_define_const(mOSX, "NSCellLightsByBackground", INT2NUM(NSCellLightsByBackground));
  rb_define_const(mOSX, "NSCellIsBordered", INT2NUM(NSCellIsBordered));
  rb_define_const(mOSX, "NSCellHasOverlappingImage", INT2NUM(NSCellHasOverlappingImage));
  rb_define_const(mOSX, "NSCellHasImageHorizontal", INT2NUM(NSCellHasImageHorizontal));
  rb_define_const(mOSX, "NSCellHasImageOnLeftOrBottom", INT2NUM(NSCellHasImageOnLeftOrBottom));
  rb_define_const(mOSX, "NSCellChangesContents", INT2NUM(NSCellChangesContents));
  rb_define_const(mOSX, "NSCellIsInsetButton", INT2NUM(NSCellIsInsetButton));
  rb_define_const(mOSX, "NSCellAllowsMixedState", INT2NUM(NSCellAllowsMixedState));
  rb_define_const(mOSX, "NSNoImage", INT2NUM(NSNoImage));
  rb_define_const(mOSX, "NSImageOnly", INT2NUM(NSImageOnly));
  rb_define_const(mOSX, "NSImageLeft", INT2NUM(NSImageLeft));
  rb_define_const(mOSX, "NSImageRight", INT2NUM(NSImageRight));
  rb_define_const(mOSX, "NSImageBelow", INT2NUM(NSImageBelow));
  rb_define_const(mOSX, "NSImageAbove", INT2NUM(NSImageAbove));
  rb_define_const(mOSX, "NSImageOverlaps", INT2NUM(NSImageOverlaps));
  rb_define_const(mOSX, "NSMixedState", INT2NUM(NSMixedState));
  rb_define_const(mOSX, "NSOffState", INT2NUM(NSOffState));
  rb_define_const(mOSX, "NSOnState", INT2NUM(NSOnState));
  rb_define_const(mOSX, "NSNoCellMask", INT2NUM(NSNoCellMask));
  rb_define_const(mOSX, "NSContentsCellMask", INT2NUM(NSContentsCellMask));
  rb_define_const(mOSX, "NSPushInCellMask", INT2NUM(NSPushInCellMask));
  rb_define_const(mOSX, "NSChangeGrayCellMask", INT2NUM(NSChangeGrayCellMask));
  rb_define_const(mOSX, "NSChangeBackgroundCellMask", INT2NUM(NSChangeBackgroundCellMask));
  rb_define_const(mOSX, "NSDefaultControlTint", INT2NUM(NSDefaultControlTint));
  rb_define_const(mOSX, "NSBlueControlTint", INT2NUM(NSBlueControlTint));
  rb_define_const(mOSX, "NSGraphiteControlTint", INT2NUM(NSGraphiteControlTint));
  rb_define_const(mOSX, "NSClearControlTint", INT2NUM(NSClearControlTint));
  rb_define_const(mOSX, "NSRegularControlSize", INT2NUM(NSRegularControlSize));
  rb_define_const(mOSX, "NSSmallControlSize", INT2NUM(NSSmallControlSize));
  rb_define_const(mOSX, "NSMiniControlSize", INT2NUM(NSMiniControlSize));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSControlTintDidChangeNotification", osx_NSControlTintDidChangeNotification, 0);
}
