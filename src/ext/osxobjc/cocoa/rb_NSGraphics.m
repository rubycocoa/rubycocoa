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
// NSString *NSCalibratedWhiteColorSpace;
static VALUE
osx_NSCalibratedWhiteColorSpace(VALUE mdl)
{
  NSString * ns_result = NSCalibratedWhiteColorSpace;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSCalibratedBlackColorSpace;
static VALUE
osx_NSCalibratedBlackColorSpace(VALUE mdl)
{
  NSString * ns_result = NSCalibratedBlackColorSpace;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSCalibratedRGBColorSpace;
static VALUE
osx_NSCalibratedRGBColorSpace(VALUE mdl)
{
  NSString * ns_result = NSCalibratedRGBColorSpace;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSDeviceWhiteColorSpace;
static VALUE
osx_NSDeviceWhiteColorSpace(VALUE mdl)
{
  NSString * ns_result = NSDeviceWhiteColorSpace;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSDeviceBlackColorSpace;
static VALUE
osx_NSDeviceBlackColorSpace(VALUE mdl)
{
  NSString * ns_result = NSDeviceBlackColorSpace;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSDeviceRGBColorSpace;
static VALUE
osx_NSDeviceRGBColorSpace(VALUE mdl)
{
  NSString * ns_result = NSDeviceRGBColorSpace;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSDeviceCMYKColorSpace;
static VALUE
osx_NSDeviceCMYKColorSpace(VALUE mdl)
{
  NSString * ns_result = NSDeviceCMYKColorSpace;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSNamedColorSpace;
static VALUE
osx_NSNamedColorSpace(VALUE mdl)
{
  NSString * ns_result = NSNamedColorSpace;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPatternColorSpace;
static VALUE
osx_NSPatternColorSpace(VALUE mdl)
{
  NSString * ns_result = NSPatternColorSpace;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSCustomColorSpace;
static VALUE
osx_NSCustomColorSpace(VALUE mdl)
{
  NSString * ns_result = NSCustomColorSpace;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
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
  NSString * ns_result = NSDeviceResolution;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSDeviceColorSpaceName;
static VALUE
osx_NSDeviceColorSpaceName(VALUE mdl)
{
  NSString * ns_result = NSDeviceColorSpaceName;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSDeviceBitsPerSample;
static VALUE
osx_NSDeviceBitsPerSample(VALUE mdl)
{
  NSString * ns_result = NSDeviceBitsPerSample;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSDeviceIsScreen;
static VALUE
osx_NSDeviceIsScreen(VALUE mdl)
{
  NSString * ns_result = NSDeviceIsScreen;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSDeviceIsPrinter;
static VALUE
osx_NSDeviceIsPrinter(VALUE mdl)
{
  NSString * ns_result = NSDeviceIsPrinter;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSDeviceSize;
static VALUE
osx_NSDeviceSize(VALUE mdl)
{
  NSString * ns_result = NSDeviceSize;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

  /**** functions ****/
// NSWindowDepth NSBestDepth (NSString *colorSpace, int bps, int bpp, BOOL planar, BOOL *exactMatch);
static VALUE
osx_NSBestDepth(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3, VALUE a4)
{
  rb_notimplement();
}

// BOOL NSPlanarFromDepth (NSWindowDepth depth);
static VALUE
osx_NSPlanarFromDepth(VALUE mdl, VALUE a0)
{
  rb_notimplement();
}

// NSString *NSColorSpaceFromDepth (NSWindowDepth depth);
static VALUE
osx_NSColorSpaceFromDepth(VALUE mdl, VALUE a0)
{
  rb_notimplement();
}

// int NSBitsPerSampleFromDepth (NSWindowDepth depth);
static VALUE
osx_NSBitsPerSampleFromDepth(VALUE mdl, VALUE a0)
{
  rb_notimplement();
}

// int NSBitsPerPixelFromDepth (NSWindowDepth depth);
static VALUE
osx_NSBitsPerPixelFromDepth(VALUE mdl, VALUE a0)
{
  rb_notimplement();
}

// int NSNumberOfColorComponents (NSString *colorSpaceName);
static VALUE
osx_NSNumberOfColorComponents(VALUE mdl, VALUE a0)
{
  int ns_result;

  NSString * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);

  ns_result = NSNumberOfColorComponents(ns_a0);

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, pool);
  [pool release];
  return rb_result;
}

// const NSWindowDepth *NSAvailableWindowDepths (void);
static VALUE
osx_NSAvailableWindowDepths(VALUE mdl)
{
  const NSWindowDepth * ns_result = NSAvailableWindowDepths();
  return nsresult_to_rbresult(_C_PTR, &ns_result, nil);
}

// void NSRectFill(NSRect aRect);
static VALUE
osx_NSRectFill(VALUE mdl, VALUE a0)
{

  NSRect ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, pool, 0);

  NSRectFill(ns_a0);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSRectFillList(const NSRect *rects, int count);
static VALUE
osx_NSRectFillList(VALUE mdl, VALUE a0, VALUE a1)
{

  const NSRect * ns_a0;
  int ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_INT, &ns_a1, pool, 1);

  NSRectFillList(ns_a0, ns_a1);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSRectFillListWithGrays(const NSRect *rects, const float *grays, int num);
static VALUE
osx_NSRectFillListWithGrays(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{

  const NSRect * ns_a0;
  const float * ns_a1;
  int ns_a2;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_PTR, &ns_a1, pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_INT, &ns_a2, pool, 2);

  NSRectFillListWithGrays(ns_a0, ns_a1, ns_a2);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSRectFillListWithColors(const NSRect *rects, NSColor **colors, int num);
static VALUE
osx_NSRectFillListWithColors(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{

  const NSRect * ns_a0;
  NSColor ** ns_a1;
  int ns_a2;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_PTR, &ns_a1, pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_INT, &ns_a2, pool, 2);

  NSRectFillListWithColors(ns_a0, ns_a1, ns_a2);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSRectFillUsingOperation(NSRect aRect, NSCompositingOperation op);
static VALUE
osx_NSRectFillUsingOperation(VALUE mdl, VALUE a0, VALUE a1)
{
  rb_notimplement();
}

// void NSRectFillListUsingOperation(const NSRect *rects, int count, NSCompositingOperation op);
static VALUE
osx_NSRectFillListUsingOperation(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{
  rb_notimplement();
}

// void NSRectFillListWithColorsUsingOperation(const NSRect *rects, NSColor **colors, int num, NSCompositingOperation op);
static VALUE
osx_NSRectFillListWithColorsUsingOperation(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3)
{
  rb_notimplement();
}

// void NSFrameRect(NSRect aRect);
static VALUE
osx_NSFrameRect(VALUE mdl, VALUE a0)
{

  NSRect ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, pool, 0);

  NSFrameRect(ns_a0);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSFrameRectWithWidth(NSRect aRect, float frameWidth);
static VALUE
osx_NSFrameRectWithWidth(VALUE mdl, VALUE a0, VALUE a1)
{

  NSRect ns_a0;
  float ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_FLT, &ns_a1, pool, 1);

  NSFrameRectWithWidth(ns_a0, ns_a1);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSFrameRectWithWidthUsingOperation(NSRect aRect, float frameWidth, NSCompositingOperation op);
static VALUE
osx_NSFrameRectWithWidthUsingOperation(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{
  rb_notimplement();
}

// void NSRectClip(NSRect aRect);
static VALUE
osx_NSRectClip(VALUE mdl, VALUE a0)
{

  NSRect ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, pool, 0);

  NSRectClip(ns_a0);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSRectClipList(const NSRect *rects, int count);
static VALUE
osx_NSRectClipList(VALUE mdl, VALUE a0, VALUE a1)
{

  const NSRect * ns_a0;
  int ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_INT, &ns_a1, pool, 1);

  NSRectClipList(ns_a0, ns_a1);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// NSRect NSDrawTiledRects(NSRect boundsRect, NSRect clipRect, const NSRectEdge *sides, const float *grays, int count);
static VALUE
osx_NSDrawTiledRects(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3, VALUE a4)
{
  NSRect ns_result;

  NSRect ns_a0;
  NSRect ns_a1;
  const NSRectEdge * ns_a2;
  const float * ns_a3;
  int ns_a4;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRECT, &ns_a1, pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_PTR, &ns_a2, pool, 2);
  /* a3 */
  rbarg_to_nsarg(a3, _C_PTR, &ns_a3, pool, 3);
  /* a4 */
  rbarg_to_nsarg(a4, _C_INT, &ns_a4, pool, 4);

  ns_result = NSDrawTiledRects(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4);

  rb_result = nsresult_to_rbresult(_PRIV_C_NSRECT, &ns_result, pool);
  [pool release];
  return rb_result;
}

// void NSDrawGrayBezel(NSRect aRect, NSRect clipRect);
static VALUE
osx_NSDrawGrayBezel(VALUE mdl, VALUE a0, VALUE a1)
{

  NSRect ns_a0;
  NSRect ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRECT, &ns_a1, pool, 1);

  NSDrawGrayBezel(ns_a0, ns_a1);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSDrawGroove(NSRect aRect, NSRect clipRect);
static VALUE
osx_NSDrawGroove(VALUE mdl, VALUE a0, VALUE a1)
{

  NSRect ns_a0;
  NSRect ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRECT, &ns_a1, pool, 1);

  NSDrawGroove(ns_a0, ns_a1);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSDrawWhiteBezel(NSRect aRect, NSRect clipRect);
static VALUE
osx_NSDrawWhiteBezel(VALUE mdl, VALUE a0, VALUE a1)
{

  NSRect ns_a0;
  NSRect ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRECT, &ns_a1, pool, 1);

  NSDrawWhiteBezel(ns_a0, ns_a1);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSDrawButton(NSRect aRect, NSRect clipRect);
static VALUE
osx_NSDrawButton(VALUE mdl, VALUE a0, VALUE a1)
{

  NSRect ns_a0;
  NSRect ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRECT, &ns_a1, pool, 1);

  NSDrawButton(ns_a0, ns_a1);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSEraseRect(NSRect aRect);
static VALUE
osx_NSEraseRect(VALUE mdl, VALUE a0)
{

  NSRect ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, pool, 0);

  NSEraseRect(ns_a0);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// NSColor *NSReadPixel(NSPoint passedPoint);
static VALUE
osx_NSReadPixel(VALUE mdl, VALUE a0)
{
  NSColor * ns_result;

  NSPoint ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSPOINT, &ns_a0, pool, 0);

  ns_result = NSReadPixel(ns_a0);

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, pool);
  [pool release];
  return rb_result;
}

// void NSDrawBitmap(NSRect rect, int width, int height, int bps, int spp, int bpp, int bpr, BOOL isPlanar, BOOL hasAlpha, NSString *colorSpaceName, const unsigned char *const data[5]);
static VALUE
osx_NSDrawBitmap(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3, VALUE a4, VALUE a5, VALUE a6, VALUE a7, VALUE a8, VALUE a9, VALUE a10)
{
  rb_notimplement();
}

// void NSCopyBitmapFromGState(int srcGState, NSRect srcRect, NSRect destRect);
static VALUE
osx_NSCopyBitmapFromGState(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{

  int ns_a0;
  NSRect ns_a1;
  NSRect ns_a2;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_INT, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRECT, &ns_a1, pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _PRIV_C_NSRECT, &ns_a2, pool, 2);

  NSCopyBitmapFromGState(ns_a0, ns_a1, ns_a2);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSCopyBits(int srcGState, NSRect srcRect, NSPoint destPoint);
static VALUE
osx_NSCopyBits(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{

  int ns_a0;
  NSRect ns_a1;
  NSPoint ns_a2;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_INT, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRECT, &ns_a1, pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _PRIV_C_NSPOINT, &ns_a2, pool, 2);

  NSCopyBits(ns_a0, ns_a1, ns_a2);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSHighlightRect(NSRect aRect);
static VALUE
osx_NSHighlightRect(VALUE mdl, VALUE a0)
{

  NSRect ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, pool, 0);

  NSHighlightRect(ns_a0);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSBeep(void);
static VALUE
osx_NSBeep(VALUE mdl)
{
  NSBeep();
  return Qnil;
}

// void NSCountWindows(int *count);
static VALUE
osx_NSCountWindows(VALUE mdl, VALUE a0)
{

  int * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);

  NSCountWindows(ns_a0);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSWindowList(int size, int list[]);
static VALUE
osx_NSWindowList(VALUE mdl, VALUE a0, VALUE a1)
{
  rb_notimplement();
}

// void NSCountWindowsForContext(int context, int *count);
static VALUE
osx_NSCountWindowsForContext(VALUE mdl, VALUE a0, VALUE a1)
{

  int ns_a0;
  int * ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_INT, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_PTR, &ns_a1, pool, 1);

  NSCountWindowsForContext(ns_a0, ns_a1);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSWindowListForContext(int context, int size, int list[]);
static VALUE
osx_NSWindowListForContext(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{
  rb_notimplement();
}

// int NSGetWindowServerMemory(int context, int *virtualMemory, int *windowBackingMemory, NSString **windowDumpString);
static VALUE
osx_NSGetWindowServerMemory(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3)
{
  int ns_result;

  int ns_a0;
  int * ns_a1;
  int * ns_a2;
  NSString ** ns_a3;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_INT, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_PTR, &ns_a1, pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_PTR, &ns_a2, pool, 2);
  /* a3 */
  rbarg_to_nsarg(a3, _C_PTR, &ns_a3, pool, 3);

  ns_result = NSGetWindowServerMemory(ns_a0, ns_a1, ns_a2, ns_a3);

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, pool);
  [pool release];
  return rb_result;
}

// NSRect NSDrawColorTiledRects(NSRect boundsRect, NSRect clipRect, const NSRectEdge *sides, NSColor **colors, int count);
static VALUE
osx_NSDrawColorTiledRects(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3, VALUE a4)
{
  NSRect ns_result;

  NSRect ns_a0;
  NSRect ns_a1;
  const NSRectEdge * ns_a2;
  NSColor ** ns_a3;
  int ns_a4;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRECT, &ns_a1, pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_PTR, &ns_a2, pool, 2);
  /* a3 */
  rbarg_to_nsarg(a3, _C_PTR, &ns_a3, pool, 3);
  /* a4 */
  rbarg_to_nsarg(a4, _C_INT, &ns_a4, pool, 4);

  ns_result = NSDrawColorTiledRects(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4);

  rb_result = nsresult_to_rbresult(_PRIV_C_NSRECT, &ns_result, pool);
  [pool release];
  return rb_result;
}

// void NSDrawDarkBezel(NSRect aRect, NSRect clipRect);
static VALUE
osx_NSDrawDarkBezel(VALUE mdl, VALUE a0, VALUE a1)
{

  NSRect ns_a0;
  NSRect ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRECT, &ns_a1, pool, 1);

  NSDrawDarkBezel(ns_a0, ns_a1);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSDrawLightBezel(NSRect aRect, NSRect clipRect);
static VALUE
osx_NSDrawLightBezel(VALUE mdl, VALUE a0, VALUE a1)
{

  NSRect ns_a0;
  NSRect ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRECT, &ns_a1, pool, 1);

  NSDrawLightBezel(ns_a0, ns_a1);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSDottedFrameRect(NSRect aRect);
static VALUE
osx_NSDottedFrameRect(VALUE mdl, VALUE a0)
{

  NSRect ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, pool, 0);

  NSDottedFrameRect(ns_a0);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSDrawWindowBackground(NSRect aRect);
static VALUE
osx_NSDrawWindowBackground(VALUE mdl, VALUE a0)
{

  NSRect ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, pool, 0);

  NSDrawWindowBackground(ns_a0);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSSetFocusRingStyle(NSFocusRingPlacement placement);
static VALUE
osx_NSSetFocusRingStyle(VALUE mdl, VALUE a0)
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
  rb_define_module_function(mOSX, "NSBestDepth", osx_NSBestDepth, 5);
  rb_define_module_function(mOSX, "NSPlanarFromDepth", osx_NSPlanarFromDepth, 1);
  rb_define_module_function(mOSX, "NSColorSpaceFromDepth", osx_NSColorSpaceFromDepth, 1);
  rb_define_module_function(mOSX, "NSBitsPerSampleFromDepth", osx_NSBitsPerSampleFromDepth, 1);
  rb_define_module_function(mOSX, "NSBitsPerPixelFromDepth", osx_NSBitsPerPixelFromDepth, 1);
  rb_define_module_function(mOSX, "NSNumberOfColorComponents", osx_NSNumberOfColorComponents, 1);
  rb_define_module_function(mOSX, "NSAvailableWindowDepths", osx_NSAvailableWindowDepths, 0);
  rb_define_module_function(mOSX, "NSRectFill", osx_NSRectFill, 1);
  rb_define_module_function(mOSX, "NSRectFillList", osx_NSRectFillList, 2);
  rb_define_module_function(mOSX, "NSRectFillListWithGrays", osx_NSRectFillListWithGrays, 3);
  rb_define_module_function(mOSX, "NSRectFillListWithColors", osx_NSRectFillListWithColors, 3);
  rb_define_module_function(mOSX, "NSRectFillUsingOperation", osx_NSRectFillUsingOperation, 2);
  rb_define_module_function(mOSX, "NSRectFillListUsingOperation", osx_NSRectFillListUsingOperation, 3);
  rb_define_module_function(mOSX, "NSRectFillListWithColorsUsingOperation", osx_NSRectFillListWithColorsUsingOperation, 4);
  rb_define_module_function(mOSX, "NSFrameRect", osx_NSFrameRect, 1);
  rb_define_module_function(mOSX, "NSFrameRectWithWidth", osx_NSFrameRectWithWidth, 2);
  rb_define_module_function(mOSX, "NSFrameRectWithWidthUsingOperation", osx_NSFrameRectWithWidthUsingOperation, 3);
  rb_define_module_function(mOSX, "NSRectClip", osx_NSRectClip, 1);
  rb_define_module_function(mOSX, "NSRectClipList", osx_NSRectClipList, 2);
  rb_define_module_function(mOSX, "NSDrawTiledRects", osx_NSDrawTiledRects, 5);
  rb_define_module_function(mOSX, "NSDrawGrayBezel", osx_NSDrawGrayBezel, 2);
  rb_define_module_function(mOSX, "NSDrawGroove", osx_NSDrawGroove, 2);
  rb_define_module_function(mOSX, "NSDrawWhiteBezel", osx_NSDrawWhiteBezel, 2);
  rb_define_module_function(mOSX, "NSDrawButton", osx_NSDrawButton, 2);
  rb_define_module_function(mOSX, "NSEraseRect", osx_NSEraseRect, 1);
  rb_define_module_function(mOSX, "NSReadPixel", osx_NSReadPixel, 1);
  rb_define_module_function(mOSX, "NSDrawBitmap", osx_NSDrawBitmap, 11);
  rb_define_module_function(mOSX, "NSCopyBitmapFromGState", osx_NSCopyBitmapFromGState, 3);
  rb_define_module_function(mOSX, "NSCopyBits", osx_NSCopyBits, 3);
  rb_define_module_function(mOSX, "NSHighlightRect", osx_NSHighlightRect, 1);
  rb_define_module_function(mOSX, "NSBeep", osx_NSBeep, 0);
  rb_define_module_function(mOSX, "NSCountWindows", osx_NSCountWindows, 1);
  rb_define_module_function(mOSX, "NSWindowList", osx_NSWindowList, 2);
  rb_define_module_function(mOSX, "NSCountWindowsForContext", osx_NSCountWindowsForContext, 2);
  rb_define_module_function(mOSX, "NSWindowListForContext", osx_NSWindowListForContext, 3);
  rb_define_module_function(mOSX, "NSGetWindowServerMemory", osx_NSGetWindowServerMemory, 4);
  rb_define_module_function(mOSX, "NSDrawColorTiledRects", osx_NSDrawColorTiledRects, 5);
  rb_define_module_function(mOSX, "NSDrawDarkBezel", osx_NSDrawDarkBezel, 2);
  rb_define_module_function(mOSX, "NSDrawLightBezel", osx_NSDrawLightBezel, 2);
  rb_define_module_function(mOSX, "NSDottedFrameRect", osx_NSDottedFrameRect, 1);
  rb_define_module_function(mOSX, "NSDrawWindowBackground", osx_NSDrawWindowBackground, 1);
  rb_define_module_function(mOSX, "NSSetFocusRingStyle", osx_NSSetFocusRingStyle, 1);
}
