#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSSize NSIconSize;
static VALUE
osx_NSIconSize(VALUE mdl)
{
  rb_notimplement();
}

// NSSize NSTokenSize;
static VALUE
osx_NSTokenSize(VALUE mdl)
{
  rb_notimplement();
}

// NSString *NSWindowDidBecomeKeyNotification;
static VALUE
osx_NSWindowDidBecomeKeyNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWindowDidBecomeKeyNotification);
}

// NSString *NSWindowDidBecomeMainNotification;
static VALUE
osx_NSWindowDidBecomeMainNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWindowDidBecomeMainNotification);
}

// NSString *NSWindowDidChangeScreenNotification;
static VALUE
osx_NSWindowDidChangeScreenNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWindowDidChangeScreenNotification);
}

// NSString *NSWindowDidDeminiaturizeNotification;
static VALUE
osx_NSWindowDidDeminiaturizeNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWindowDidDeminiaturizeNotification);
}

// NSString *NSWindowDidExposeNotification;
static VALUE
osx_NSWindowDidExposeNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWindowDidExposeNotification);
}

// NSString *NSWindowDidMiniaturizeNotification;
static VALUE
osx_NSWindowDidMiniaturizeNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWindowDidMiniaturizeNotification);
}

// NSString *NSWindowDidMoveNotification;
static VALUE
osx_NSWindowDidMoveNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWindowDidMoveNotification);
}

// NSString *NSWindowDidResignKeyNotification;
static VALUE
osx_NSWindowDidResignKeyNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWindowDidResignKeyNotification);
}

// NSString *NSWindowDidResignMainNotification;
static VALUE
osx_NSWindowDidResignMainNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWindowDidResignMainNotification);
}

// NSString *NSWindowDidResizeNotification;
static VALUE
osx_NSWindowDidResizeNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWindowDidResizeNotification);
}

// NSString *NSWindowDidUpdateNotification;
static VALUE
osx_NSWindowDidUpdateNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWindowDidUpdateNotification);
}

// NSString *NSWindowWillCloseNotification;
static VALUE
osx_NSWindowWillCloseNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWindowWillCloseNotification);
}

// NSString *NSWindowWillMiniaturizeNotification;
static VALUE
osx_NSWindowWillMiniaturizeNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWindowWillMiniaturizeNotification);
}

// NSString *NSWindowWillMoveNotification;
static VALUE
osx_NSWindowWillMoveNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWindowWillMoveNotification);
}

// NSString *NSWindowWillBeginSheetNotification;
static VALUE
osx_NSWindowWillBeginSheetNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWindowWillBeginSheetNotification);
}

// NSString *NSWindowDidEndSheetNotification;
static VALUE
osx_NSWindowDidEndSheetNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWindowDidEndSheetNotification);
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
