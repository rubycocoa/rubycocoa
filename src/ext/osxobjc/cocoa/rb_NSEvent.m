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


void init_NSEvent(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSLeftMouseDown", INT2NUM(NSLeftMouseDown));
  rb_define_const(mOSX, "NSLeftMouseUp", INT2NUM(NSLeftMouseUp));
  rb_define_const(mOSX, "NSRightMouseDown", INT2NUM(NSRightMouseDown));
  rb_define_const(mOSX, "NSRightMouseUp", INT2NUM(NSRightMouseUp));
  rb_define_const(mOSX, "NSMouseMoved", INT2NUM(NSMouseMoved));
  rb_define_const(mOSX, "NSLeftMouseDragged", INT2NUM(NSLeftMouseDragged));
  rb_define_const(mOSX, "NSRightMouseDragged", INT2NUM(NSRightMouseDragged));
  rb_define_const(mOSX, "NSMouseEntered", INT2NUM(NSMouseEntered));
  rb_define_const(mOSX, "NSMouseExited", INT2NUM(NSMouseExited));
  rb_define_const(mOSX, "NSKeyDown", INT2NUM(NSKeyDown));
  rb_define_const(mOSX, "NSKeyUp", INT2NUM(NSKeyUp));
  rb_define_const(mOSX, "NSFlagsChanged", INT2NUM(NSFlagsChanged));
  rb_define_const(mOSX, "NSAppKitDefined", INT2NUM(NSAppKitDefined));
  rb_define_const(mOSX, "NSSystemDefined", INT2NUM(NSSystemDefined));
  rb_define_const(mOSX, "NSApplicationDefined", INT2NUM(NSApplicationDefined));
  rb_define_const(mOSX, "NSPeriodic", INT2NUM(NSPeriodic));
  rb_define_const(mOSX, "NSCursorUpdate", INT2NUM(NSCursorUpdate));
  rb_define_const(mOSX, "NSScrollWheel", INT2NUM(NSScrollWheel));
  rb_define_const(mOSX, "NSOtherMouseDown", INT2NUM(NSOtherMouseDown));
  rb_define_const(mOSX, "NSOtherMouseUp", INT2NUM(NSOtherMouseUp));
  rb_define_const(mOSX, "NSOtherMouseDragged", INT2NUM(NSOtherMouseDragged));
  rb_define_const(mOSX, "NSLeftMouseDownMask", INT2NUM(NSLeftMouseDownMask));
  rb_define_const(mOSX, "NSLeftMouseUpMask", INT2NUM(NSLeftMouseUpMask));
  rb_define_const(mOSX, "NSRightMouseDownMask", INT2NUM(NSRightMouseDownMask));
  rb_define_const(mOSX, "NSRightMouseUpMask", INT2NUM(NSRightMouseUpMask));
  rb_define_const(mOSX, "NSMouseMovedMask", INT2NUM(NSMouseMovedMask));
  rb_define_const(mOSX, "NSLeftMouseDraggedMask", INT2NUM(NSLeftMouseDraggedMask));
  rb_define_const(mOSX, "NSRightMouseDraggedMask", INT2NUM(NSRightMouseDraggedMask));
  rb_define_const(mOSX, "NSMouseEnteredMask", INT2NUM(NSMouseEnteredMask));
  rb_define_const(mOSX, "NSMouseExitedMask", INT2NUM(NSMouseExitedMask));
  rb_define_const(mOSX, "NSKeyDownMask", INT2NUM(NSKeyDownMask));
  rb_define_const(mOSX, "NSKeyUpMask", INT2NUM(NSKeyUpMask));
  rb_define_const(mOSX, "NSFlagsChangedMask", INT2NUM(NSFlagsChangedMask));
  rb_define_const(mOSX, "NSAppKitDefinedMask", INT2NUM(NSAppKitDefinedMask));
  rb_define_const(mOSX, "NSSystemDefinedMask", INT2NUM(NSSystemDefinedMask));
  rb_define_const(mOSX, "NSApplicationDefinedMask", INT2NUM(NSApplicationDefinedMask));
  rb_define_const(mOSX, "NSPeriodicMask", INT2NUM(NSPeriodicMask));
  rb_define_const(mOSX, "NSCursorUpdateMask", INT2NUM(NSCursorUpdateMask));
  rb_define_const(mOSX, "NSScrollWheelMask", INT2NUM(NSScrollWheelMask));
  rb_define_const(mOSX, "NSOtherMouseDownMask", INT2NUM(NSOtherMouseDownMask));
  rb_define_const(mOSX, "NSOtherMouseUpMask", INT2NUM(NSOtherMouseUpMask));
  rb_define_const(mOSX, "NSOtherMouseDraggedMask", INT2NUM(NSOtherMouseDraggedMask));
  rb_define_const(mOSX, "NSAnyEventMask", INT2NUM(NSAnyEventMask));
  rb_define_const(mOSX, "NSAlphaShiftKeyMask", INT2NUM(NSAlphaShiftKeyMask));
  rb_define_const(mOSX, "NSShiftKeyMask", INT2NUM(NSShiftKeyMask));
  rb_define_const(mOSX, "NSControlKeyMask", INT2NUM(NSControlKeyMask));
  rb_define_const(mOSX, "NSAlternateKeyMask", INT2NUM(NSAlternateKeyMask));
  rb_define_const(mOSX, "NSCommandKeyMask", INT2NUM(NSCommandKeyMask));
  rb_define_const(mOSX, "NSNumericPadKeyMask", INT2NUM(NSNumericPadKeyMask));
  rb_define_const(mOSX, "NSHelpKeyMask", INT2NUM(NSHelpKeyMask));
  rb_define_const(mOSX, "NSFunctionKeyMask", INT2NUM(NSFunctionKeyMask));
  rb_define_const(mOSX, "NSUpArrowFunctionKey", INT2NUM(NSUpArrowFunctionKey));
  rb_define_const(mOSX, "NSDownArrowFunctionKey", INT2NUM(NSDownArrowFunctionKey));
  rb_define_const(mOSX, "NSLeftArrowFunctionKey", INT2NUM(NSLeftArrowFunctionKey));
  rb_define_const(mOSX, "NSRightArrowFunctionKey", INT2NUM(NSRightArrowFunctionKey));
  rb_define_const(mOSX, "NSF1FunctionKey", INT2NUM(NSF1FunctionKey));
  rb_define_const(mOSX, "NSF2FunctionKey", INT2NUM(NSF2FunctionKey));
  rb_define_const(mOSX, "NSF3FunctionKey", INT2NUM(NSF3FunctionKey));
  rb_define_const(mOSX, "NSF4FunctionKey", INT2NUM(NSF4FunctionKey));
  rb_define_const(mOSX, "NSF5FunctionKey", INT2NUM(NSF5FunctionKey));
  rb_define_const(mOSX, "NSF6FunctionKey", INT2NUM(NSF6FunctionKey));
  rb_define_const(mOSX, "NSF7FunctionKey", INT2NUM(NSF7FunctionKey));
  rb_define_const(mOSX, "NSF8FunctionKey", INT2NUM(NSF8FunctionKey));
  rb_define_const(mOSX, "NSF9FunctionKey", INT2NUM(NSF9FunctionKey));
  rb_define_const(mOSX, "NSF10FunctionKey", INT2NUM(NSF10FunctionKey));
  rb_define_const(mOSX, "NSF11FunctionKey", INT2NUM(NSF11FunctionKey));
  rb_define_const(mOSX, "NSF12FunctionKey", INT2NUM(NSF12FunctionKey));
  rb_define_const(mOSX, "NSF13FunctionKey", INT2NUM(NSF13FunctionKey));
  rb_define_const(mOSX, "NSF14FunctionKey", INT2NUM(NSF14FunctionKey));
  rb_define_const(mOSX, "NSF15FunctionKey", INT2NUM(NSF15FunctionKey));
  rb_define_const(mOSX, "NSF16FunctionKey", INT2NUM(NSF16FunctionKey));
  rb_define_const(mOSX, "NSF17FunctionKey", INT2NUM(NSF17FunctionKey));
  rb_define_const(mOSX, "NSF18FunctionKey", INT2NUM(NSF18FunctionKey));
  rb_define_const(mOSX, "NSF19FunctionKey", INT2NUM(NSF19FunctionKey));
  rb_define_const(mOSX, "NSF20FunctionKey", INT2NUM(NSF20FunctionKey));
  rb_define_const(mOSX, "NSF21FunctionKey", INT2NUM(NSF21FunctionKey));
  rb_define_const(mOSX, "NSF22FunctionKey", INT2NUM(NSF22FunctionKey));
  rb_define_const(mOSX, "NSF23FunctionKey", INT2NUM(NSF23FunctionKey));
  rb_define_const(mOSX, "NSF24FunctionKey", INT2NUM(NSF24FunctionKey));
  rb_define_const(mOSX, "NSF25FunctionKey", INT2NUM(NSF25FunctionKey));
  rb_define_const(mOSX, "NSF26FunctionKey", INT2NUM(NSF26FunctionKey));
  rb_define_const(mOSX, "NSF27FunctionKey", INT2NUM(NSF27FunctionKey));
  rb_define_const(mOSX, "NSF28FunctionKey", INT2NUM(NSF28FunctionKey));
  rb_define_const(mOSX, "NSF29FunctionKey", INT2NUM(NSF29FunctionKey));
  rb_define_const(mOSX, "NSF30FunctionKey", INT2NUM(NSF30FunctionKey));
  rb_define_const(mOSX, "NSF31FunctionKey", INT2NUM(NSF31FunctionKey));
  rb_define_const(mOSX, "NSF32FunctionKey", INT2NUM(NSF32FunctionKey));
  rb_define_const(mOSX, "NSF33FunctionKey", INT2NUM(NSF33FunctionKey));
  rb_define_const(mOSX, "NSF34FunctionKey", INT2NUM(NSF34FunctionKey));
  rb_define_const(mOSX, "NSF35FunctionKey", INT2NUM(NSF35FunctionKey));
  rb_define_const(mOSX, "NSInsertFunctionKey", INT2NUM(NSInsertFunctionKey));
  rb_define_const(mOSX, "NSDeleteFunctionKey", INT2NUM(NSDeleteFunctionKey));
  rb_define_const(mOSX, "NSHomeFunctionKey", INT2NUM(NSHomeFunctionKey));
  rb_define_const(mOSX, "NSBeginFunctionKey", INT2NUM(NSBeginFunctionKey));
  rb_define_const(mOSX, "NSEndFunctionKey", INT2NUM(NSEndFunctionKey));
  rb_define_const(mOSX, "NSPageUpFunctionKey", INT2NUM(NSPageUpFunctionKey));
  rb_define_const(mOSX, "NSPageDownFunctionKey", INT2NUM(NSPageDownFunctionKey));
  rb_define_const(mOSX, "NSPrintScreenFunctionKey", INT2NUM(NSPrintScreenFunctionKey));
  rb_define_const(mOSX, "NSScrollLockFunctionKey", INT2NUM(NSScrollLockFunctionKey));
  rb_define_const(mOSX, "NSPauseFunctionKey", INT2NUM(NSPauseFunctionKey));
  rb_define_const(mOSX, "NSSysReqFunctionKey", INT2NUM(NSSysReqFunctionKey));
  rb_define_const(mOSX, "NSBreakFunctionKey", INT2NUM(NSBreakFunctionKey));
  rb_define_const(mOSX, "NSResetFunctionKey", INT2NUM(NSResetFunctionKey));
  rb_define_const(mOSX, "NSStopFunctionKey", INT2NUM(NSStopFunctionKey));
  rb_define_const(mOSX, "NSMenuFunctionKey", INT2NUM(NSMenuFunctionKey));
  rb_define_const(mOSX, "NSUserFunctionKey", INT2NUM(NSUserFunctionKey));
  rb_define_const(mOSX, "NSSystemFunctionKey", INT2NUM(NSSystemFunctionKey));
  rb_define_const(mOSX, "NSPrintFunctionKey", INT2NUM(NSPrintFunctionKey));
  rb_define_const(mOSX, "NSClearLineFunctionKey", INT2NUM(NSClearLineFunctionKey));
  rb_define_const(mOSX, "NSClearDisplayFunctionKey", INT2NUM(NSClearDisplayFunctionKey));
  rb_define_const(mOSX, "NSInsertLineFunctionKey", INT2NUM(NSInsertLineFunctionKey));
  rb_define_const(mOSX, "NSDeleteLineFunctionKey", INT2NUM(NSDeleteLineFunctionKey));
  rb_define_const(mOSX, "NSInsertCharFunctionKey", INT2NUM(NSInsertCharFunctionKey));
  rb_define_const(mOSX, "NSDeleteCharFunctionKey", INT2NUM(NSDeleteCharFunctionKey));
  rb_define_const(mOSX, "NSPrevFunctionKey", INT2NUM(NSPrevFunctionKey));
  rb_define_const(mOSX, "NSNextFunctionKey", INT2NUM(NSNextFunctionKey));
  rb_define_const(mOSX, "NSSelectFunctionKey", INT2NUM(NSSelectFunctionKey));
  rb_define_const(mOSX, "NSExecuteFunctionKey", INT2NUM(NSExecuteFunctionKey));
  rb_define_const(mOSX, "NSUndoFunctionKey", INT2NUM(NSUndoFunctionKey));
  rb_define_const(mOSX, "NSRedoFunctionKey", INT2NUM(NSRedoFunctionKey));
  rb_define_const(mOSX, "NSFindFunctionKey", INT2NUM(NSFindFunctionKey));
  rb_define_const(mOSX, "NSHelpFunctionKey", INT2NUM(NSHelpFunctionKey));
  rb_define_const(mOSX, "NSModeSwitchFunctionKey", INT2NUM(NSModeSwitchFunctionKey));
  rb_define_const(mOSX, "NSWindowExposedEventType", INT2NUM(NSWindowExposedEventType));
  rb_define_const(mOSX, "NSApplicationActivatedEventType", INT2NUM(NSApplicationActivatedEventType));
  rb_define_const(mOSX, "NSApplicationDeactivatedEventType", INT2NUM(NSApplicationDeactivatedEventType));
  rb_define_const(mOSX, "NSWindowMovedEventType", INT2NUM(NSWindowMovedEventType));
  rb_define_const(mOSX, "NSScreenChangedEventType", INT2NUM(NSScreenChangedEventType));
  rb_define_const(mOSX, "NSAWTEventType", INT2NUM(NSAWTEventType));
  rb_define_const(mOSX, "NSPowerOffEventType", INT2NUM(NSPowerOffEventType));

}
