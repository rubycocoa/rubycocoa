#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSSize NSIconSize;
static VALUE
osx_NSIconSize(VALUE mdl)
{
  return nsresult_to_rbresult(_PRIV_C_NSSIZE, &NSIconSize, nil);
}

// NSSize NSTokenSize;
static VALUE
osx_NSTokenSize(VALUE mdl)
{
  return nsresult_to_rbresult(_PRIV_C_NSSIZE, &NSTokenSize, nil);
}

// NSString *NSWindowDidBecomeKeyNotification;
static VALUE
osx_NSWindowDidBecomeKeyNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowDidBecomeKeyNotification, nil);
}

// NSString *NSWindowDidBecomeMainNotification;
static VALUE
osx_NSWindowDidBecomeMainNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowDidBecomeMainNotification, nil);
}

// NSString *NSWindowDidChangeScreenNotification;
static VALUE
osx_NSWindowDidChangeScreenNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowDidChangeScreenNotification, nil);
}

// NSString *NSWindowDidDeminiaturizeNotification;
static VALUE
osx_NSWindowDidDeminiaturizeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowDidDeminiaturizeNotification, nil);
}

// NSString *NSWindowDidExposeNotification;
static VALUE
osx_NSWindowDidExposeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowDidExposeNotification, nil);
}

// NSString *NSWindowDidMiniaturizeNotification;
static VALUE
osx_NSWindowDidMiniaturizeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowDidMiniaturizeNotification, nil);
}

// NSString *NSWindowDidMoveNotification;
static VALUE
osx_NSWindowDidMoveNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowDidMoveNotification, nil);
}

// NSString *NSWindowDidResignKeyNotification;
static VALUE
osx_NSWindowDidResignKeyNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowDidResignKeyNotification, nil);
}

// NSString *NSWindowDidResignMainNotification;
static VALUE
osx_NSWindowDidResignMainNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowDidResignMainNotification, nil);
}

// NSString *NSWindowDidResizeNotification;
static VALUE
osx_NSWindowDidResizeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowDidResizeNotification, nil);
}

// NSString *NSWindowDidUpdateNotification;
static VALUE
osx_NSWindowDidUpdateNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowDidUpdateNotification, nil);
}

// NSString *NSWindowWillCloseNotification;
static VALUE
osx_NSWindowWillCloseNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowWillCloseNotification, nil);
}

// NSString *NSWindowWillMiniaturizeNotification;
static VALUE
osx_NSWindowWillMiniaturizeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowWillMiniaturizeNotification, nil);
}

// NSString *NSWindowWillMoveNotification;
static VALUE
osx_NSWindowWillMoveNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowWillMoveNotification, nil);
}

// NSString *NSWindowWillBeginSheetNotification;
static VALUE
osx_NSWindowWillBeginSheetNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowWillBeginSheetNotification, nil);
}

// NSString *NSWindowDidEndSheetNotification;
static VALUE
osx_NSWindowDidEndSheetNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowDidEndSheetNotification, nil);
}

void init_NSWindow(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSBorderlessWindowMask", INT2NUM(NSBorderlessWindowMask));
  rb_define_const(mOSX, "NSTitledWindowMask", INT2NUM(NSTitledWindowMask));
  rb_define_const(mOSX, "NSClosableWindowMask", INT2NUM(NSClosableWindowMask));
  rb_define_const(mOSX, "NSMiniaturizableWindowMask", INT2NUM(NSMiniaturizableWindowMask));
  rb_define_const(mOSX, "NSResizableWindowMask", INT2NUM(NSResizableWindowMask));
  rb_define_const(mOSX, "NSDisplayWindowRunLoopOrdering", INT2NUM(NSDisplayWindowRunLoopOrdering));
  rb_define_const(mOSX, "NSResetCursorRectsRunLoopOrdering", INT2NUM(NSResetCursorRectsRunLoopOrdering));
  rb_define_const(mOSX, "NSDirectSelection", INT2NUM(NSDirectSelection));
  rb_define_const(mOSX, "NSSelectingNext", INT2NUM(NSSelectingNext));
  rb_define_const(mOSX, "NSSelectingPrevious", INT2NUM(NSSelectingPrevious));

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
