#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSSize NSIconSize;
static VALUE
osx_NSIconSize(VALUE mdl)
{
  return nsresult_to_rbresult(_PRIV_C_NSSIZE, &NSIconSize, "NSIconSize", nil);
}

// NSSize NSTokenSize;
static VALUE
osx_NSTokenSize(VALUE mdl)
{
  return nsresult_to_rbresult(_PRIV_C_NSSIZE, &NSTokenSize, "NSTokenSize", nil);
}

// NSString * NSWindowDidBecomeKeyNotification;
static VALUE
osx_NSWindowDidBecomeKeyNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowDidBecomeKeyNotification, "NSWindowDidBecomeKeyNotification", nil);
}

// NSString * NSWindowDidBecomeMainNotification;
static VALUE
osx_NSWindowDidBecomeMainNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowDidBecomeMainNotification, "NSWindowDidBecomeMainNotification", nil);
}

// NSString * NSWindowDidChangeScreenNotification;
static VALUE
osx_NSWindowDidChangeScreenNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowDidChangeScreenNotification, "NSWindowDidChangeScreenNotification", nil);
}

// NSString * NSWindowDidDeminiaturizeNotification;
static VALUE
osx_NSWindowDidDeminiaturizeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowDidDeminiaturizeNotification, "NSWindowDidDeminiaturizeNotification", nil);
}

// NSString * NSWindowDidExposeNotification;
static VALUE
osx_NSWindowDidExposeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowDidExposeNotification, "NSWindowDidExposeNotification", nil);
}

// NSString * NSWindowDidMiniaturizeNotification;
static VALUE
osx_NSWindowDidMiniaturizeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowDidMiniaturizeNotification, "NSWindowDidMiniaturizeNotification", nil);
}

// NSString * NSWindowDidMoveNotification;
static VALUE
osx_NSWindowDidMoveNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowDidMoveNotification, "NSWindowDidMoveNotification", nil);
}

// NSString * NSWindowDidResignKeyNotification;
static VALUE
osx_NSWindowDidResignKeyNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowDidResignKeyNotification, "NSWindowDidResignKeyNotification", nil);
}

// NSString * NSWindowDidResignMainNotification;
static VALUE
osx_NSWindowDidResignMainNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowDidResignMainNotification, "NSWindowDidResignMainNotification", nil);
}

// NSString * NSWindowDidResizeNotification;
static VALUE
osx_NSWindowDidResizeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowDidResizeNotification, "NSWindowDidResizeNotification", nil);
}

// NSString * NSWindowDidUpdateNotification;
static VALUE
osx_NSWindowDidUpdateNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowDidUpdateNotification, "NSWindowDidUpdateNotification", nil);
}

// NSString * NSWindowWillCloseNotification;
static VALUE
osx_NSWindowWillCloseNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowWillCloseNotification, "NSWindowWillCloseNotification", nil);
}

// NSString * NSWindowWillMiniaturizeNotification;
static VALUE
osx_NSWindowWillMiniaturizeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowWillMiniaturizeNotification, "NSWindowWillMiniaturizeNotification", nil);
}

// NSString * NSWindowWillMoveNotification;
static VALUE
osx_NSWindowWillMoveNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowWillMoveNotification, "NSWindowWillMoveNotification", nil);
}

// NSString * NSWindowWillBeginSheetNotification;
static VALUE
osx_NSWindowWillBeginSheetNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowWillBeginSheetNotification, "NSWindowWillBeginSheetNotification", nil);
}

// NSString * NSWindowDidEndSheetNotification;
static VALUE
osx_NSWindowDidEndSheetNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowDidEndSheetNotification, "NSWindowDidEndSheetNotification", nil);
}

void init_NSWindow(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSBorderlessWindowMask", INT2NUM(NSBorderlessWindowMask));
  rb_define_const(mOSX, "NSTitledWindowMask", INT2NUM(NSTitledWindowMask));
  rb_define_const(mOSX, "NSClosableWindowMask", INT2NUM(NSClosableWindowMask));
  rb_define_const(mOSX, "NSMiniaturizableWindowMask", INT2NUM(NSMiniaturizableWindowMask));
  rb_define_const(mOSX, "NSResizableWindowMask", INT2NUM(NSResizableWindowMask));
  rb_define_const(mOSX, "NSTexturedBackgroundWindowMask", INT2NUM(NSTexturedBackgroundWindowMask));
  rb_define_const(mOSX, "NSDisplayWindowRunLoopOrdering", INT2NUM(NSDisplayWindowRunLoopOrdering));
  rb_define_const(mOSX, "NSResetCursorRectsRunLoopOrdering", INT2NUM(NSResetCursorRectsRunLoopOrdering));
  rb_define_const(mOSX, "NSDirectSelection", INT2NUM(NSDirectSelection));
  rb_define_const(mOSX, "NSSelectingNext", INT2NUM(NSSelectingNext));
  rb_define_const(mOSX, "NSSelectingPrevious", INT2NUM(NSSelectingPrevious));
  rb_define_const(mOSX, "NSWindowCloseButton", INT2NUM(NSWindowCloseButton));
  rb_define_const(mOSX, "NSWindowMiniaturizeButton", INT2NUM(NSWindowMiniaturizeButton));
  rb_define_const(mOSX, "NSWindowZoomButton", INT2NUM(NSWindowZoomButton));
  rb_define_const(mOSX, "NSWindowToolbarButton", INT2NUM(NSWindowToolbarButton));
  rb_define_const(mOSX, "NSWindowDocumentIconButton", INT2NUM(NSWindowDocumentIconButton));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSIconSize", osx_NSIconSize, 0);
  rb_define_module_function(mOSX, "NSTokenSize", osx_NSTokenSize, 0);
  rb_define_module_function(mOSX, "NSWindowDidBecomeKeyNotification", osx_NSWindowDidBecomeKeyNotification, 0);
  rb_define_module_function(mOSX, "NSWindowDidBecomeMainNotification", osx_NSWindowDidBecomeMainNotification, 0);
  rb_define_module_function(mOSX, "NSWindowDidChangeScreenNotification", osx_NSWindowDidChangeScreenNotification, 0);
  rb_define_module_function(mOSX, "NSWindowDidDeminiaturizeNotification", osx_NSWindowDidDeminiaturizeNotification, 0);
  rb_define_module_function(mOSX, "NSWindowDidExposeNotification", osx_NSWindowDidExposeNotification, 0);
  rb_define_module_function(mOSX, "NSWindowDidMiniaturizeNotification", osx_NSWindowDidMiniaturizeNotification, 0);
  rb_define_module_function(mOSX, "NSWindowDidMoveNotification", osx_NSWindowDidMoveNotification, 0);
  rb_define_module_function(mOSX, "NSWindowDidResignKeyNotification", osx_NSWindowDidResignKeyNotification, 0);
  rb_define_module_function(mOSX, "NSWindowDidResignMainNotification", osx_NSWindowDidResignMainNotification, 0);
  rb_define_module_function(mOSX, "NSWindowDidResizeNotification", osx_NSWindowDidResizeNotification, 0);
  rb_define_module_function(mOSX, "NSWindowDidUpdateNotification", osx_NSWindowDidUpdateNotification, 0);
  rb_define_module_function(mOSX, "NSWindowWillCloseNotification", osx_NSWindowWillCloseNotification, 0);
  rb_define_module_function(mOSX, "NSWindowWillMiniaturizeNotification", osx_NSWindowWillMiniaturizeNotification, 0);
  rb_define_module_function(mOSX, "NSWindowWillMoveNotification", osx_NSWindowWillMoveNotification, 0);
  rb_define_module_function(mOSX, "NSWindowWillBeginSheetNotification", osx_NSWindowWillBeginSheetNotification, 0);
  rb_define_module_function(mOSX, "NSWindowDidEndSheetNotification", osx_NSWindowDidEndSheetNotification, 0);
}
