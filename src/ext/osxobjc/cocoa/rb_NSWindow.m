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
// NSSize NSIconSize;
static VALUE
osx_NSIconSize(VALUE mdl)
{
  NSSize ns_result = NSIconSize;
  return nsresult_to_rbresult(_PRIV_C_NSSIZE, &ns_result, nil);
}

// NSSize NSTokenSize;
static VALUE
osx_NSTokenSize(VALUE mdl)
{
  NSSize ns_result = NSTokenSize;
  return nsresult_to_rbresult(_PRIV_C_NSSIZE, &ns_result, nil);
}

// NSString *NSWindowDidBecomeKeyNotification;
static VALUE
osx_NSWindowDidBecomeKeyNotification(VALUE mdl)
{
  NSString * ns_result = NSWindowDidBecomeKeyNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWindowDidBecomeMainNotification;
static VALUE
osx_NSWindowDidBecomeMainNotification(VALUE mdl)
{
  NSString * ns_result = NSWindowDidBecomeMainNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWindowDidChangeScreenNotification;
static VALUE
osx_NSWindowDidChangeScreenNotification(VALUE mdl)
{
  NSString * ns_result = NSWindowDidChangeScreenNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWindowDidDeminiaturizeNotification;
static VALUE
osx_NSWindowDidDeminiaturizeNotification(VALUE mdl)
{
  NSString * ns_result = NSWindowDidDeminiaturizeNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWindowDidExposeNotification;
static VALUE
osx_NSWindowDidExposeNotification(VALUE mdl)
{
  NSString * ns_result = NSWindowDidExposeNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWindowDidMiniaturizeNotification;
static VALUE
osx_NSWindowDidMiniaturizeNotification(VALUE mdl)
{
  NSString * ns_result = NSWindowDidMiniaturizeNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWindowDidMoveNotification;
static VALUE
osx_NSWindowDidMoveNotification(VALUE mdl)
{
  NSString * ns_result = NSWindowDidMoveNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWindowDidResignKeyNotification;
static VALUE
osx_NSWindowDidResignKeyNotification(VALUE mdl)
{
  NSString * ns_result = NSWindowDidResignKeyNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWindowDidResignMainNotification;
static VALUE
osx_NSWindowDidResignMainNotification(VALUE mdl)
{
  NSString * ns_result = NSWindowDidResignMainNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWindowDidResizeNotification;
static VALUE
osx_NSWindowDidResizeNotification(VALUE mdl)
{
  NSString * ns_result = NSWindowDidResizeNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWindowDidUpdateNotification;
static VALUE
osx_NSWindowDidUpdateNotification(VALUE mdl)
{
  NSString * ns_result = NSWindowDidUpdateNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWindowWillCloseNotification;
static VALUE
osx_NSWindowWillCloseNotification(VALUE mdl)
{
  NSString * ns_result = NSWindowWillCloseNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWindowWillMiniaturizeNotification;
static VALUE
osx_NSWindowWillMiniaturizeNotification(VALUE mdl)
{
  NSString * ns_result = NSWindowWillMiniaturizeNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWindowWillMoveNotification;
static VALUE
osx_NSWindowWillMoveNotification(VALUE mdl)
{
  NSString * ns_result = NSWindowWillMoveNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWindowWillBeginSheetNotification;
static VALUE
osx_NSWindowWillBeginSheetNotification(VALUE mdl)
{
  NSString * ns_result = NSWindowWillBeginSheetNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWindowDidEndSheetNotification;
static VALUE
osx_NSWindowDidEndSheetNotification(VALUE mdl)
{
  NSString * ns_result = NSWindowDidEndSheetNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
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
