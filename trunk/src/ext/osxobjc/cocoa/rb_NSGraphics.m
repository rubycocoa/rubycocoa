#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString *NSCalibratedWhiteColorSpace;
static VALUE
osx_NSCalibratedWhiteColorSpace(VALUE mdl)
{
  return ocobj_new_with_ocid(NSCalibratedWhiteColorSpace);
}

// NSString *NSCalibratedBlackColorSpace;
static VALUE
osx_NSCalibratedBlackColorSpace(VALUE mdl)
{
  return ocobj_new_with_ocid(NSCalibratedBlackColorSpace);
}

// NSString *NSCalibratedRGBColorSpace;
static VALUE
osx_NSCalibratedRGBColorSpace(VALUE mdl)
{
  return ocobj_new_with_ocid(NSCalibratedRGBColorSpace);
}

// NSString *NSDeviceWhiteColorSpace;
static VALUE
osx_NSDeviceWhiteColorSpace(VALUE mdl)
{
  return ocobj_new_with_ocid(NSDeviceWhiteColorSpace);
}

// NSString *NSDeviceBlackColorSpace;
static VALUE
osx_NSDeviceBlackColorSpace(VALUE mdl)
{
  return ocobj_new_with_ocid(NSDeviceBlackColorSpace);
}

// NSString *NSDeviceRGBColorSpace;
static VALUE
osx_NSDeviceRGBColorSpace(VALUE mdl)
{
  return ocobj_new_with_ocid(NSDeviceRGBColorSpace);
}

// NSString *NSDeviceCMYKColorSpace;
static VALUE
osx_NSDeviceCMYKColorSpace(VALUE mdl)
{
  return ocobj_new_with_ocid(NSDeviceCMYKColorSpace);
}

// NSString *NSNamedColorSpace;
static VALUE
osx_NSNamedColorSpace(VALUE mdl)
{
  return ocobj_new_with_ocid(NSNamedColorSpace);
}

// NSString *NSPatternColorSpace;
static VALUE
osx_NSPatternColorSpace(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPatternColorSpace);
}

// NSString *NSCustomColorSpace;
static VALUE
osx_NSCustomColorSpace(VALUE mdl)
{
  return ocobj_new_with_ocid(NSCustomColorSpace);
}

// const float NSWhite;
static VALUE
osx_NSWhite(VALUE mdl)
{
  rb_notimplement();
}

// const float NSLightGray;
static VALUE
osx_NSLightGray(VALUE mdl)
{
  rb_notimplement();
}

// const float NSDarkGray;
static VALUE
osx_NSDarkGray(VALUE mdl)
{
  rb_notimplement();
}

// const float NSBlack;
static VALUE
osx_NSBlack(VALUE mdl)
{
  rb_notimplement();
}

// NSString *NSDeviceResolution;
static VALUE
osx_NSDeviceResolution(VALUE mdl)
{
  return ocobj_new_with_ocid(NSDeviceResolution);
}

// NSString *NSDeviceColorSpaceName;
static VALUE
osx_NSDeviceColorSpaceName(VALUE mdl)
{
  return ocobj_new_with_ocid(NSDeviceColorSpaceName);
}

// NSString *NSDeviceBitsPerSample;
static VALUE
osx_NSDeviceBitsPerSample(VALUE mdl)
{
  return ocobj_new_with_ocid(NSDeviceBitsPerSample);
}

// NSString *NSDeviceIsScreen;
static VALUE
osx_NSDeviceIsScreen(VALUE mdl)
{
  return ocobj_new_with_ocid(NSDeviceIsScreen);
}

// NSString *NSDeviceIsPrinter;
static VALUE
osx_NSDeviceIsPrinter(VALUE mdl)
{
  return ocobj_new_with_ocid(NSDeviceIsPrinter);
}

// NSString *NSDeviceSize;
static VALUE
osx_NSDeviceSize(VALUE mdl)
{
  return ocobj_new_with_ocid(NSDeviceSize);
}

  /**** functions ****/
// NSWindowDepth NSBestDepth (NSString *colorSpace, int bps, int bpp, BOOL planar, BOOL *exactMatch);
static VALUE
osx_NSBestDepth(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// BOOL NSPlanarFromDepth (NSWindowDepth depth);
static VALUE
osx_NSPlanarFromDepth(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSString *NSColorSpaceFromDepth (NSWindowDepth depth);
static VALUE
osx_NSColorSpaceFromDepth(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// int NSBitsPerSampleFromDepth (NSWindowDepth depth);
static VALUE
osx_NSBitsPerSampleFromDepth(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// int NSBitsPerPixelFromDepth (NSWindowDepth depth);
static VALUE
osx_NSBitsPerPixelFromDepth(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// int NSNumberOfColorComponents (NSString *colorSpaceName);
static VALUE
osx_NSNumberOfColorComponents(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// const NSWindowDepth *NSAvailableWindowDepths (void);
static VALUE
osx_NSAvailableWindowDepths(VALUE mdl)
{
  rb_notimplement();
}

// void NSRectFill(NSRect aRect);
static VALUE
osx_NSRectFill(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSRectFillList(const NSRect *rects, int count);
static VALUE
osx_NSRectFillList(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSRectFillListWithGrays(const NSRect *rects, const float *grays, int num);
static VALUE
osx_NSRectFillListWithGrays(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSRectFillListWithColors(const NSRect *rects, NSColor **colors, int num);
static VALUE
osx_NSRectFillListWithColors(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSRectFillUsingOperation(NSRect aRect, NSCompositingOperation op);
static VALUE
osx_NSRectFillUsingOperation(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSRectFillListUsingOperation(const NSRect *rects, int count, NSCompositingOperation op);
static VALUE
osx_NSRectFillListUsingOperation(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSRectFillListWithColorsUsingOperation(const NSRect *rects, NSColor **colors, int num, NSCompositingOperation op);
static VALUE
osx_NSRectFillListWithColorsUsingOperation(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSFrameRect(NSRect aRect);
static VALUE
osx_NSFrameRect(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSFrameRectWithWidth(NSRect aRect, float frameWidth);
static VALUE
osx_NSFrameRectWithWidth(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSFrameRectWithWidthUsingOperation(NSRect aRect, float frameWidth, NSCompositingOperation op);
static VALUE
osx_NSFrameRectWithWidthUsingOperation(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSRectClip(NSRect aRect);
static VALUE
osx_NSRectClip(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSRectClipList(const NSRect *rects, int count);
static VALUE
osx_NSRectClipList(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSRect NSDrawTiledRects(NSRect boundsRect, NSRect clipRect, const NSRectEdge *sides, const float *grays, int count);
static VALUE
osx_NSDrawTiledRects(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSDrawGrayBezel(NSRect aRect, NSRect clipRect);
static VALUE
osx_NSDrawGrayBezel(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSDrawGroove(NSRect aRect, NSRect clipRect);
static VALUE
osx_NSDrawGroove(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSDrawWhiteBezel(NSRect aRect, NSRect clipRect);
static VALUE
osx_NSDrawWhiteBezel(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSDrawButton(NSRect aRect, NSRect clipRect);
static VALUE
osx_NSDrawButton(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSEraseRect(NSRect aRect);
static VALUE
osx_NSEraseRect(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSColor *NSReadPixel(NSPoint passedPoint);
static VALUE
osx_NSReadPixel(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSDrawBitmap(NSRect rect, int width, int height, int bps, int spp, int bpp, int bpr, BOOL isPlanar, BOOL hasAlpha, NSString *colorSpaceName, const unsigned char *const data[5]);
static VALUE
osx_NSDrawBitmap(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSCopyBitmapFromGState(int srcGState, NSRect srcRect, NSRect destRect);
static VALUE
osx_NSCopyBitmapFromGState(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSCopyBits(int srcGState, NSRect srcRect, NSPoint destPoint);
static VALUE
osx_NSCopyBits(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSHighlightRect(NSRect aRect);
static VALUE
osx_NSHighlightRect(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSBeep(void);
static VALUE
osx_NSBeep(VALUE mdl)
{
  id pool = [[NSAutoreleasePool alloc] init];
  
  VALUE rb_result;
  
   NSBeep();
  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSCountWindows(int *count);
static VALUE
osx_NSCountWindows(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSWindowList(int size, int list[]);
static VALUE
osx_NSWindowList(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSCountWindowsForContext(int context, int *count);
static VALUE
osx_NSCountWindowsForContext(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSWindowListForContext(int context, int size, int list[]);
static VALUE
osx_NSWindowListForContext(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// int NSGetWindowServerMemory(int context, int *virtualMemory, int *windowBackingMemory, NSString **windowDumpString);
static VALUE
osx_NSGetWindowServerMemory(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSRect NSDrawColorTiledRects(NSRect boundsRect, NSRect clipRect, const NSRectEdge *sides, NSColor **colors, int count);
static VALUE
osx_NSDrawColorTiledRects(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSDrawDarkBezel(NSRect aRect, NSRect clipRect);
static VALUE
osx_NSDrawDarkBezel(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSDrawLightBezel(NSRect aRect, NSRect clipRect);
static VALUE
osx_NSDrawLightBezel(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSDottedFrameRect(NSRect aRect);
static VALUE
osx_NSDottedFrameRect(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSDrawWindowBackground(NSRect aRect);
static VALUE
osx_NSDrawWindowBackground(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSSetFocusRingStyle(NSFocusRingPlacement placement);
static VALUE
osx_NSSetFocusRingStyle(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

void init_NSGraphics(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSCompositeClear", INT2NUM(NSCompositeClear));
  rb_define_const(mOSX, "NSCompositeCopy", INT2NUM(NSCompositeCopy));
  rb_define_const(mOSX, "NSCompositeSourceOver", INT2NUM(NSCompositeSourceOver));
  rb_define_const(mOSX, "NSCompositeSourceIn", INT2NUM(NSCompositeSourceIn));
  rb_define_const(mOSX, "NSCompositeSourceOut", INT2NUM(NSCompositeSourceOut));
  rb_define_const(mOSX, "NSCompositeSourceAtop", INT2NUM(NSCompositeSourceAtop));
  rb_define_const(mOSX, "NSCompositeDestinationOver", INT2NUM(NSCompositeDestinationOver));
  rb_define_const(mOSX, "NSCompositeDestinationIn", INT2NUM(NSCompositeDestinationIn));
  rb_define_const(mOSX, "NSCompositeDestinationOut", INT2NUM(NSCompositeDestinationOut));
  rb_define_const(mOSX, "NSCompositeDestinationAtop", INT2NUM(NSCompositeDestinationAtop));
  rb_define_const(mOSX, "NSCompositeXOR", INT2NUM(NSCompositeXOR));
  rb_define_const(mOSX, "NSCompositePlusDarker", INT2NUM(NSCompositePlusDarker));
  rb_define_const(mOSX, "NSCompositeHighlight", INT2NUM(NSCompositeHighlight));
  rb_define_const(mOSX, "NSCompositePlusLighter", INT2NUM(NSCompositePlusLighter));
  rb_define_const(mOSX, "NSAlphaEqualToData", INT2NUM(NSAlphaEqualToData));
  rb_define_const(mOSX, "NSAlphaAlwaysOne", INT2NUM(NSAlphaAlwaysOne));
  rb_define_const(mOSX, "NSBackingStoreRetained", INT2NUM(NSBackingStoreRetained));
  rb_define_const(mOSX, "NSBackingStoreNonretained", INT2NUM(NSBackingStoreNonretained));
  rb_define_const(mOSX, "NSBackingStoreBuffered", INT2NUM(NSBackingStoreBuffered));
  rb_define_const(mOSX, "NSWindowAbove", INT2NUM(NSWindowAbove));
  rb_define_const(mOSX, "NSWindowBelow", INT2NUM(NSWindowBelow));
  rb_define_const(mOSX, "NSWindowOut", INT2NUM(NSWindowOut));
  rb_define_const(mOSX, "NSFocusRingOnly", INT2NUM(NSFocusRingOnly));
  rb_define_const(mOSX, "NSFocusRingBelow", INT2NUM(NSFocusRingBelow));
  rb_define_const(mOSX, "NSFocusRingAbove", INT2NUM(NSFocusRingAbove));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSCalibratedWhiteColorSpace", osx_NSCalibratedWhiteColorSpace, 0);
  rb_define_module_function(mOSX, "NSCalibratedBlackColorSpace", osx_NSCalibratedBlackColorSpace, 0);
  rb_define_module_function(mOSX, "NSCalibratedRGBColorSpace", osx_NSCalibratedRGBColorSpace, 0);
  rb_define_module_function(mOSX, "NSDeviceWhiteColorSpace", osx_NSDeviceWhiteColorSpace, 0);
  rb_define_module_function(mOSX, "NSDeviceBlackColorSpace", osx_NSDeviceBlackColorSpace, 0);
  rb_define_module_function(mOSX, "NSDeviceRGBColorSpace", osx_NSDeviceRGBColorSpace, 0);
  rb_define_module_function(mOSX, "NSDeviceCMYKColorSpace", osx_NSDeviceCMYKColorSpace, 0);
  rb_define_module_function(mOSX, "NSNamedColorSpace", osx_NSNamedColorSpace, 0);
  rb_define_module_function(mOSX, "NSPatternColorSpace", osx_NSPatternColorSpace, 0);
  rb_define_module_function(mOSX, "NSCustomColorSpace", osx_NSCustomColorSpace, 0);
  rb_define_module_function(mOSX, "NSWhite", osx_NSWhite, 0);
  rb_define_module_function(mOSX, "NSLightGray", osx_NSLightGray, 0);
  rb_define_module_function(mOSX, "NSDarkGray", osx_NSDarkGray, 0);
  rb_define_module_function(mOSX, "NSBlack", osx_NSBlack, 0);
  rb_define_module_function(mOSX, "NSDeviceResolution", osx_NSDeviceResolution, 0);
  rb_define_module_function(mOSX, "NSDeviceColorSpaceName", osx_NSDeviceColorSpaceName, 0);
  rb_define_module_function(mOSX, "NSDeviceBitsPerSample", osx_NSDeviceBitsPerSample, 0);
  rb_define_module_function(mOSX, "NSDeviceIsScreen", osx_NSDeviceIsScreen, 0);
  rb_define_module_function(mOSX, "NSDeviceIsPrinter", osx_NSDeviceIsPrinter, 0);
  rb_define_module_function(mOSX, "NSDeviceSize", osx_NSDeviceSize, 0);
  /**** functions ****/
  rb_define_module_function(mOSX, "NSBestDepth", osx_NSBestDepth, -1);
  rb_define_module_function(mOSX, "NSPlanarFromDepth", osx_NSPlanarFromDepth, -1);
  rb_define_module_function(mOSX, "NSColorSpaceFromDepth", osx_NSColorSpaceFromDepth, -1);
  rb_define_module_function(mOSX, "NSBitsPerSampleFromDepth", osx_NSBitsPerSampleFromDepth, -1);
  rb_define_module_function(mOSX, "NSBitsPerPixelFromDepth", osx_NSBitsPerPixelFromDepth, -1);
  rb_define_module_function(mOSX, "NSNumberOfColorComponents", osx_NSNumberOfColorComponents, -1);
  rb_define_module_function(mOSX, "NSAvailableWindowDepths", osx_NSAvailableWindowDepths, 0);
  rb_define_module_function(mOSX, "NSRectFill", osx_NSRectFill, -1);
  rb_define_module_function(mOSX, "NSRectFillList", osx_NSRectFillList, -1);
  rb_define_module_function(mOSX, "NSRectFillListWithGrays", osx_NSRectFillListWithGrays, -1);
  rb_define_module_function(mOSX, "NSRectFillListWithColors", osx_NSRectFillListWithColors, -1);
  rb_define_module_function(mOSX, "NSRectFillUsingOperation", osx_NSRectFillUsingOperation, -1);
  rb_define_module_function(mOSX, "NSRectFillListUsingOperation", osx_NSRectFillListUsingOperation, -1);
  rb_define_module_function(mOSX, "NSRectFillListWithColorsUsingOperation", osx_NSRectFillListWithColorsUsingOperation, -1);
  rb_define_module_function(mOSX, "NSFrameRect", osx_NSFrameRect, -1);
  rb_define_module_function(mOSX, "NSFrameRectWithWidth", osx_NSFrameRectWithWidth, -1);
  rb_define_module_function(mOSX, "NSFrameRectWithWidthUsingOperation", osx_NSFrameRectWithWidthUsingOperation, -1);
  rb_define_module_function(mOSX, "NSRectClip", osx_NSRectClip, -1);
  rb_define_module_function(mOSX, "NSRectClipList", osx_NSRectClipList, -1);
  rb_define_module_function(mOSX, "NSDrawTiledRects", osx_NSDrawTiledRects, -1);
  rb_define_module_function(mOSX, "NSDrawGrayBezel", osx_NSDrawGrayBezel, -1);
  rb_define_module_function(mOSX, "NSDrawGroove", osx_NSDrawGroove, -1);
  rb_define_module_function(mOSX, "NSDrawWhiteBezel", osx_NSDrawWhiteBezel, -1);
  rb_define_module_function(mOSX, "NSDrawButton", osx_NSDrawButton, -1);
  rb_define_module_function(mOSX, "NSEraseRect", osx_NSEraseRect, -1);
  rb_define_module_function(mOSX, "NSReadPixel", osx_NSReadPixel, -1);
  rb_define_module_function(mOSX, "NSDrawBitmap", osx_NSDrawBitmap, -1);
  rb_define_module_function(mOSX, "NSCopyBitmapFromGState", osx_NSCopyBitmapFromGState, -1);
  rb_define_module_function(mOSX, "NSCopyBits", osx_NSCopyBits, -1);
  rb_define_module_function(mOSX, "NSHighlightRect", osx_NSHighlightRect, -1);
  rb_define_module_function(mOSX, "NSBeep", osx_NSBeep, 0);
  rb_define_module_function(mOSX, "NSCountWindows", osx_NSCountWindows, -1);
  rb_define_module_function(mOSX, "NSWindowList", osx_NSWindowList, -1);
  rb_define_module_function(mOSX, "NSCountWindowsForContext", osx_NSCountWindowsForContext, -1);
  rb_define_module_function(mOSX, "NSWindowListForContext", osx_NSWindowListForContext, -1);
  rb_define_module_function(mOSX, "NSGetWindowServerMemory", osx_NSGetWindowServerMemory, -1);
  rb_define_module_function(mOSX, "NSDrawColorTiledRects", osx_NSDrawColorTiledRects, -1);
  rb_define_module_function(mOSX, "NSDrawDarkBezel", osx_NSDrawDarkBezel, -1);
  rb_define_module_function(mOSX, "NSDrawLightBezel", osx_NSDrawLightBezel, -1);
  rb_define_module_function(mOSX, "NSDottedFrameRect", osx_NSDottedFrameRect, -1);
  rb_define_module_function(mOSX, "NSDrawWindowBackground", osx_NSDrawWindowBackground, -1);
  rb_define_module_function(mOSX, "NSSetFocusRingStyle", osx_NSSetFocusRingStyle, -1);
}
