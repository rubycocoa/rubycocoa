#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * NSCalibratedWhiteColorSpace;
static VALUE
osx_NSCalibratedWhiteColorSpace(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSCalibratedWhiteColorSpace, "NSCalibratedWhiteColorSpace", nil);
}

// NSString * NSCalibratedBlackColorSpace;
static VALUE
osx_NSCalibratedBlackColorSpace(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSCalibratedBlackColorSpace, "NSCalibratedBlackColorSpace", nil);
}

// NSString * NSCalibratedRGBColorSpace;
static VALUE
osx_NSCalibratedRGBColorSpace(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSCalibratedRGBColorSpace, "NSCalibratedRGBColorSpace", nil);
}

// NSString * NSDeviceWhiteColorSpace;
static VALUE
osx_NSDeviceWhiteColorSpace(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSDeviceWhiteColorSpace, "NSDeviceWhiteColorSpace", nil);
}

// NSString * NSDeviceBlackColorSpace;
static VALUE
osx_NSDeviceBlackColorSpace(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSDeviceBlackColorSpace, "NSDeviceBlackColorSpace", nil);
}

// NSString * NSDeviceRGBColorSpace;
static VALUE
osx_NSDeviceRGBColorSpace(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSDeviceRGBColorSpace, "NSDeviceRGBColorSpace", nil);
}

// NSString * NSDeviceCMYKColorSpace;
static VALUE
osx_NSDeviceCMYKColorSpace(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSDeviceCMYKColorSpace, "NSDeviceCMYKColorSpace", nil);
}

// NSString * NSNamedColorSpace;
static VALUE
osx_NSNamedColorSpace(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSNamedColorSpace, "NSNamedColorSpace", nil);
}

// NSString * NSPatternColorSpace;
static VALUE
osx_NSPatternColorSpace(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSPatternColorSpace, "NSPatternColorSpace", nil);
}

// NSString * NSCustomColorSpace;
static VALUE
osx_NSCustomColorSpace(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSCustomColorSpace, "NSCustomColorSpace", nil);
}

// const float NSWhite;
static VALUE
osx_NSWhite(VALUE mdl)
{
  return nsresult_to_rbresult(_C_FLT, &NSWhite, "NSWhite", nil);
}

// const float NSLightGray;
static VALUE
osx_NSLightGray(VALUE mdl)
{
  return nsresult_to_rbresult(_C_FLT, &NSLightGray, "NSLightGray", nil);
}

// const float NSDarkGray;
static VALUE
osx_NSDarkGray(VALUE mdl)
{
  return nsresult_to_rbresult(_C_FLT, &NSDarkGray, "NSDarkGray", nil);
}

// const float NSBlack;
static VALUE
osx_NSBlack(VALUE mdl)
{
  return nsresult_to_rbresult(_C_FLT, &NSBlack, "NSBlack", nil);
}

// NSString * NSDeviceResolution;
static VALUE
osx_NSDeviceResolution(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSDeviceResolution, "NSDeviceResolution", nil);
}

// NSString * NSDeviceColorSpaceName;
static VALUE
osx_NSDeviceColorSpaceName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSDeviceColorSpaceName, "NSDeviceColorSpaceName", nil);
}

// NSString * NSDeviceBitsPerSample;
static VALUE
osx_NSDeviceBitsPerSample(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSDeviceBitsPerSample, "NSDeviceBitsPerSample", nil);
}

// NSString * NSDeviceIsScreen;
static VALUE
osx_NSDeviceIsScreen(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSDeviceIsScreen, "NSDeviceIsScreen", nil);
}

// NSString * NSDeviceIsPrinter;
static VALUE
osx_NSDeviceIsPrinter(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSDeviceIsPrinter, "NSDeviceIsPrinter", nil);
}

// NSString * NSDeviceSize;
static VALUE
osx_NSDeviceSize(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSDeviceSize, "NSDeviceSize", nil);
}

  /**** functions ****/
// NSWindowDepth NSBestDepth ( NSString * colorSpace , int bps , int bpp , BOOL planar , BOOL * exactMatch );
static VALUE
osx_NSBestDepth(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3, VALUE a4)
{
  NSWindowDepth ns_result;

  NSString * ns_a0;
  int ns_a1;
  int ns_a2;
  BOOL ns_a3;
  BOOL * ns_a4;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, "NSBestDepth", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_INT, &ns_a1, "NSBestDepth", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_INT, &ns_a2, "NSBestDepth", pool, 2);
  /* a3 */
  rbarg_to_nsarg(a3, _C_UCHR, &ns_a3, "NSBestDepth", pool, 3);
  /* a4 */
  rbarg_to_nsarg(a4, _PRIV_C_PTR, &ns_a4, "NSBestDepth", pool, 4);

NS_DURING
  ns_result = NSBestDepth(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4);
NS_HANDLER
  excp = oc_err_new ("NSBestDepth", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, "NSBestDepth", pool);
  [pool release];
  return rb_result;
}

// BOOL NSPlanarFromDepth ( NSWindowDepth depth );
static VALUE
osx_NSPlanarFromDepth(VALUE mdl, VALUE a0)
{
  BOOL ns_result;

  NSWindowDepth ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_INT, &ns_a0, "NSPlanarFromDepth", pool, 0);

NS_DURING
  ns_result = NSPlanarFromDepth(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSPlanarFromDepth", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_PRIV_C_BOOL, &ns_result, "NSPlanarFromDepth", pool);
  [pool release];
  return rb_result;
}

// NSString * NSColorSpaceFromDepth ( NSWindowDepth depth );
static VALUE
osx_NSColorSpaceFromDepth(VALUE mdl, VALUE a0)
{
  NSString * ns_result;

  NSWindowDepth ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_INT, &ns_a0, "NSColorSpaceFromDepth", pool, 0);

NS_DURING
  ns_result = NSColorSpaceFromDepth(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSColorSpaceFromDepth", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, "NSColorSpaceFromDepth", pool);
  [pool release];
  return rb_result;
}

// int NSBitsPerSampleFromDepth ( NSWindowDepth depth );
static VALUE
osx_NSBitsPerSampleFromDepth(VALUE mdl, VALUE a0)
{
  int ns_result;

  NSWindowDepth ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_INT, &ns_a0, "NSBitsPerSampleFromDepth", pool, 0);

NS_DURING
  ns_result = NSBitsPerSampleFromDepth(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSBitsPerSampleFromDepth", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, "NSBitsPerSampleFromDepth", pool);
  [pool release];
  return rb_result;
}

// int NSBitsPerPixelFromDepth ( NSWindowDepth depth );
static VALUE
osx_NSBitsPerPixelFromDepth(VALUE mdl, VALUE a0)
{
  int ns_result;

  NSWindowDepth ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_INT, &ns_a0, "NSBitsPerPixelFromDepth", pool, 0);

NS_DURING
  ns_result = NSBitsPerPixelFromDepth(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSBitsPerPixelFromDepth", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, "NSBitsPerPixelFromDepth", pool);
  [pool release];
  return rb_result;
}

// int NSNumberOfColorComponents ( NSString * colorSpaceName );
static VALUE
osx_NSNumberOfColorComponents(VALUE mdl, VALUE a0)
{
  int ns_result;

  NSString * ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, "NSNumberOfColorComponents", pool, 0);

NS_DURING
  ns_result = NSNumberOfColorComponents(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSNumberOfColorComponents", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, "NSNumberOfColorComponents", pool);
  [pool release];
  return rb_result;
}

// const NSWindowDepth * NSAvailableWindowDepths ( void );
static VALUE
osx_NSAvailableWindowDepths(VALUE mdl)
{
  const NSWindowDepth * ns_result = NSAvailableWindowDepths();
  return nsresult_to_rbresult(_PRIV_C_PTR, &ns_result, "NSAvailableWindowDepths", nil);
}

// void NSRectFill ( NSRect aRect );
static VALUE
osx_NSRectFill(VALUE mdl, VALUE a0)
{

  NSRect ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, "NSRectFill", pool, 0);

NS_DURING
  NSRectFill(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSRectFill", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSRectFillList ( const NSRect * rects , int count );
static VALUE
osx_NSRectFillList(VALUE mdl, VALUE a0, VALUE a1)
{

  const NSRect * ns_a0;
  int ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSRectFillList", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_INT, &ns_a1, "NSRectFillList", pool, 1);

NS_DURING
  NSRectFillList(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSRectFillList", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSRectFillListWithGrays ( const NSRect * rects , const float * grays , int num );
static VALUE
osx_NSRectFillListWithGrays(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{

  const NSRect * ns_a0;
  const float * ns_a1;
  int ns_a2;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSRectFillListWithGrays", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSRectFillListWithGrays", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_INT, &ns_a2, "NSRectFillListWithGrays", pool, 2);

NS_DURING
  NSRectFillListWithGrays(ns_a0, ns_a1, ns_a2);
NS_HANDLER
  excp = oc_err_new ("NSRectFillListWithGrays", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSRectFillListWithColors ( const NSRect * rects , NSColor * * colors , int num );
static VALUE
osx_NSRectFillListWithColors(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{

  const NSRect * ns_a0;
  NSColor * * ns_a1;
  int ns_a2;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSRectFillListWithColors", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSRectFillListWithColors", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_INT, &ns_a2, "NSRectFillListWithColors", pool, 2);

NS_DURING
  NSRectFillListWithColors(ns_a0, ns_a1, ns_a2);
NS_HANDLER
  excp = oc_err_new ("NSRectFillListWithColors", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSRectFillUsingOperation ( NSRect aRect , NSCompositingOperation op );
static VALUE
osx_NSRectFillUsingOperation(VALUE mdl, VALUE a0, VALUE a1)
{

  NSRect ns_a0;
  NSCompositingOperation ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, "NSRectFillUsingOperation", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_INT, &ns_a1, "NSRectFillUsingOperation", pool, 1);

NS_DURING
  NSRectFillUsingOperation(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSRectFillUsingOperation", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSRectFillListUsingOperation ( const NSRect * rects , int count , NSCompositingOperation op );
static VALUE
osx_NSRectFillListUsingOperation(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{

  const NSRect * ns_a0;
  int ns_a1;
  NSCompositingOperation ns_a2;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSRectFillListUsingOperation", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_INT, &ns_a1, "NSRectFillListUsingOperation", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_INT, &ns_a2, "NSRectFillListUsingOperation", pool, 2);

NS_DURING
  NSRectFillListUsingOperation(ns_a0, ns_a1, ns_a2);
NS_HANDLER
  excp = oc_err_new ("NSRectFillListUsingOperation", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSRectFillListWithColorsUsingOperation ( const NSRect * rects , NSColor * * colors , int num , NSCompositingOperation op );
static VALUE
osx_NSRectFillListWithColorsUsingOperation(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3)
{

  const NSRect * ns_a0;
  NSColor * * ns_a1;
  int ns_a2;
  NSCompositingOperation ns_a3;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSRectFillListWithColorsUsingOperation", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSRectFillListWithColorsUsingOperation", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_INT, &ns_a2, "NSRectFillListWithColorsUsingOperation", pool, 2);
  /* a3 */
  rbarg_to_nsarg(a3, _C_INT, &ns_a3, "NSRectFillListWithColorsUsingOperation", pool, 3);

NS_DURING
  NSRectFillListWithColorsUsingOperation(ns_a0, ns_a1, ns_a2, ns_a3);
NS_HANDLER
  excp = oc_err_new ("NSRectFillListWithColorsUsingOperation", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSFrameRect ( NSRect aRect );
static VALUE
osx_NSFrameRect(VALUE mdl, VALUE a0)
{

  NSRect ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, "NSFrameRect", pool, 0);

NS_DURING
  NSFrameRect(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSFrameRect", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSFrameRectWithWidth ( NSRect aRect , float frameWidth );
static VALUE
osx_NSFrameRectWithWidth(VALUE mdl, VALUE a0, VALUE a1)
{

  NSRect ns_a0;
  float ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, "NSFrameRectWithWidth", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_FLT, &ns_a1, "NSFrameRectWithWidth", pool, 1);

NS_DURING
  NSFrameRectWithWidth(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSFrameRectWithWidth", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSFrameRectWithWidthUsingOperation ( NSRect aRect , float frameWidth , NSCompositingOperation op );
static VALUE
osx_NSFrameRectWithWidthUsingOperation(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{

  NSRect ns_a0;
  float ns_a1;
  NSCompositingOperation ns_a2;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, "NSFrameRectWithWidthUsingOperation", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_FLT, &ns_a1, "NSFrameRectWithWidthUsingOperation", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_INT, &ns_a2, "NSFrameRectWithWidthUsingOperation", pool, 2);

NS_DURING
  NSFrameRectWithWidthUsingOperation(ns_a0, ns_a1, ns_a2);
NS_HANDLER
  excp = oc_err_new ("NSFrameRectWithWidthUsingOperation", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSRectClip ( NSRect aRect );
static VALUE
osx_NSRectClip(VALUE mdl, VALUE a0)
{

  NSRect ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, "NSRectClip", pool, 0);

NS_DURING
  NSRectClip(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSRectClip", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSRectClipList ( const NSRect * rects , int count );
static VALUE
osx_NSRectClipList(VALUE mdl, VALUE a0, VALUE a1)
{

  const NSRect * ns_a0;
  int ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSRectClipList", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_INT, &ns_a1, "NSRectClipList", pool, 1);

NS_DURING
  NSRectClipList(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSRectClipList", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// NSRect NSDrawTiledRects ( NSRect boundsRect , NSRect clipRect , const NSRectEdge * sides , const float * grays , int count );
static VALUE
osx_NSDrawTiledRects(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3, VALUE a4)
{
  NSRect ns_result;

  NSRect ns_a0;
  NSRect ns_a1;
  const NSRectEdge * ns_a2;
  const float * ns_a3;
  int ns_a4;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, "NSDrawTiledRects", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRECT, &ns_a1, "NSDrawTiledRects", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _PRIV_C_PTR, &ns_a2, "NSDrawTiledRects", pool, 2);
  /* a3 */
  rbarg_to_nsarg(a3, _PRIV_C_PTR, &ns_a3, "NSDrawTiledRects", pool, 3);
  /* a4 */
  rbarg_to_nsarg(a4, _C_INT, &ns_a4, "NSDrawTiledRects", pool, 4);

NS_DURING
  ns_result = NSDrawTiledRects(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4);
NS_HANDLER
  excp = oc_err_new ("NSDrawTiledRects", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_PRIV_C_NSRECT, &ns_result, "NSDrawTiledRects", pool);
  [pool release];
  return rb_result;
}

// void NSDrawGrayBezel ( NSRect aRect , NSRect clipRect );
static VALUE
osx_NSDrawGrayBezel(VALUE mdl, VALUE a0, VALUE a1)
{

  NSRect ns_a0;
  NSRect ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, "NSDrawGrayBezel", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRECT, &ns_a1, "NSDrawGrayBezel", pool, 1);

NS_DURING
  NSDrawGrayBezel(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSDrawGrayBezel", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSDrawGroove ( NSRect aRect , NSRect clipRect );
static VALUE
osx_NSDrawGroove(VALUE mdl, VALUE a0, VALUE a1)
{

  NSRect ns_a0;
  NSRect ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, "NSDrawGroove", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRECT, &ns_a1, "NSDrawGroove", pool, 1);

NS_DURING
  NSDrawGroove(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSDrawGroove", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSDrawWhiteBezel ( NSRect aRect , NSRect clipRect );
static VALUE
osx_NSDrawWhiteBezel(VALUE mdl, VALUE a0, VALUE a1)
{

  NSRect ns_a0;
  NSRect ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, "NSDrawWhiteBezel", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRECT, &ns_a1, "NSDrawWhiteBezel", pool, 1);

NS_DURING
  NSDrawWhiteBezel(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSDrawWhiteBezel", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSDrawButton ( NSRect aRect , NSRect clipRect );
static VALUE
osx_NSDrawButton(VALUE mdl, VALUE a0, VALUE a1)
{

  NSRect ns_a0;
  NSRect ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, "NSDrawButton", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRECT, &ns_a1, "NSDrawButton", pool, 1);

NS_DURING
  NSDrawButton(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSDrawButton", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSEraseRect ( NSRect aRect );
static VALUE
osx_NSEraseRect(VALUE mdl, VALUE a0)
{

  NSRect ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, "NSEraseRect", pool, 0);

NS_DURING
  NSEraseRect(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSEraseRect", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// NSColor * NSReadPixel ( NSPoint passedPoint );
static VALUE
osx_NSReadPixel(VALUE mdl, VALUE a0)
{
  NSColor * ns_result;

  NSPoint ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSPOINT, &ns_a0, "NSReadPixel", pool, 0);

NS_DURING
  ns_result = NSReadPixel(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSReadPixel", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, "NSReadPixel", pool);
  [pool release];
  return rb_result;
}

// void NSDrawBitmap ( NSRect rect , int width , int height , int bps , int spp , int bpp , int bpr , BOOL isPlanar , BOOL hasAlpha , NSString * colorSpaceName , const unsigned char * const data [ 5 ] );
static VALUE
osx_NSDrawBitmap(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3, VALUE a4, VALUE a5, VALUE a6, VALUE a7, VALUE a8, VALUE a9, VALUE a10)
{

  NSRect ns_a0;
  int ns_a1;
  int ns_a2;
  int ns_a3;
  int ns_a4;
  int ns_a5;
  int ns_a6;
  BOOL ns_a7;
  BOOL ns_a8;
  NSString * ns_a9;
  const unsigned char * const* ns_a10;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, "NSDrawBitmap", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_INT, &ns_a1, "NSDrawBitmap", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_INT, &ns_a2, "NSDrawBitmap", pool, 2);
  /* a3 */
  rbarg_to_nsarg(a3, _C_INT, &ns_a3, "NSDrawBitmap", pool, 3);
  /* a4 */
  rbarg_to_nsarg(a4, _C_INT, &ns_a4, "NSDrawBitmap", pool, 4);
  /* a5 */
  rbarg_to_nsarg(a5, _C_INT, &ns_a5, "NSDrawBitmap", pool, 5);
  /* a6 */
  rbarg_to_nsarg(a6, _C_INT, &ns_a6, "NSDrawBitmap", pool, 6);
  /* a7 */
  rbarg_to_nsarg(a7, _C_UCHR, &ns_a7, "NSDrawBitmap", pool, 7);
  /* a8 */
  rbarg_to_nsarg(a8, _C_UCHR, &ns_a8, "NSDrawBitmap", pool, 8);
  /* a9 */
  rbarg_to_nsarg(a9, _C_ID, &ns_a9, "NSDrawBitmap", pool, 9);
  /* a10 */
  rbarg_to_nsarg(a10, _PRIV_C_PTR, &ns_a10, "NSDrawBitmap", pool, 10);

NS_DURING
  NSDrawBitmap(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5, ns_a6, ns_a7, ns_a8, ns_a9, ns_a10);
NS_HANDLER
  excp = oc_err_new ("NSDrawBitmap", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSCopyBits ( int srcGState , NSRect srcRect , NSPoint destPoint );
static VALUE
osx_NSCopyBits(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{

  int ns_a0;
  NSRect ns_a1;
  NSPoint ns_a2;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_INT, &ns_a0, "NSCopyBits", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRECT, &ns_a1, "NSCopyBits", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _PRIV_C_NSPOINT, &ns_a2, "NSCopyBits", pool, 2);

NS_DURING
  NSCopyBits(ns_a0, ns_a1, ns_a2);
NS_HANDLER
  excp = oc_err_new ("NSCopyBits", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSHighlightRect ( NSRect aRect );
static VALUE
osx_NSHighlightRect(VALUE mdl, VALUE a0)
{

  NSRect ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, "NSHighlightRect", pool, 0);

NS_DURING
  NSHighlightRect(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSHighlightRect", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSBeep ( void );
static VALUE
osx_NSBeep(VALUE mdl)
{
  NSBeep();
  return Qnil;
}

// void NSCountWindows ( int * count );
static VALUE
osx_NSCountWindows(VALUE mdl, VALUE a0)
{

  int * ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSCountWindows", pool, 0);

NS_DURING
  NSCountWindows(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSCountWindows", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSWindowList ( int size , int list [ ] );
static VALUE
osx_NSWindowList(VALUE mdl, VALUE a0, VALUE a1)
{

  int ns_a0;
  int* ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_INT, &ns_a0, "NSWindowList", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSWindowList", pool, 1);

NS_DURING
  NSWindowList(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSWindowList", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSCountWindowsForContext ( int context , int * count );
static VALUE
osx_NSCountWindowsForContext(VALUE mdl, VALUE a0, VALUE a1)
{

  int ns_a0;
  int * ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_INT, &ns_a0, "NSCountWindowsForContext", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSCountWindowsForContext", pool, 1);

NS_DURING
  NSCountWindowsForContext(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSCountWindowsForContext", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSWindowListForContext ( int context , int size , int list [ ] );
static VALUE
osx_NSWindowListForContext(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{

  int ns_a0;
  int ns_a1;
  int* ns_a2;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_INT, &ns_a0, "NSWindowListForContext", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_INT, &ns_a1, "NSWindowListForContext", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _PRIV_C_PTR, &ns_a2, "NSWindowListForContext", pool, 2);

NS_DURING
  NSWindowListForContext(ns_a0, ns_a1, ns_a2);
NS_HANDLER
  excp = oc_err_new ("NSWindowListForContext", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// int NSGetWindowServerMemory ( int context , int * virtualMemory , int * windowBackingMemory , NSString * * windowDumpString );
static VALUE
osx_NSGetWindowServerMemory(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3)
{
  int ns_result;

  int ns_a0;
  int * ns_a1;
  int * ns_a2;
  NSString * * ns_a3;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_INT, &ns_a0, "NSGetWindowServerMemory", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSGetWindowServerMemory", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _PRIV_C_PTR, &ns_a2, "NSGetWindowServerMemory", pool, 2);
  /* a3 */
  rbarg_to_nsarg(a3, _PRIV_C_PTR, &ns_a3, "NSGetWindowServerMemory", pool, 3);

NS_DURING
  ns_result = NSGetWindowServerMemory(ns_a0, ns_a1, ns_a2, ns_a3);
NS_HANDLER
  excp = oc_err_new ("NSGetWindowServerMemory", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_INT, &ns_result, "NSGetWindowServerMemory", pool);
  [pool release];
  return rb_result;
}

// NSRect NSDrawColorTiledRects ( NSRect boundsRect , NSRect clipRect , const NSRectEdge * sides , NSColor * * colors , int count );
static VALUE
osx_NSDrawColorTiledRects(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3, VALUE a4)
{
  NSRect ns_result;

  NSRect ns_a0;
  NSRect ns_a1;
  const NSRectEdge * ns_a2;
  NSColor * * ns_a3;
  int ns_a4;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, "NSDrawColorTiledRects", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRECT, &ns_a1, "NSDrawColorTiledRects", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _PRIV_C_PTR, &ns_a2, "NSDrawColorTiledRects", pool, 2);
  /* a3 */
  rbarg_to_nsarg(a3, _PRIV_C_PTR, &ns_a3, "NSDrawColorTiledRects", pool, 3);
  /* a4 */
  rbarg_to_nsarg(a4, _C_INT, &ns_a4, "NSDrawColorTiledRects", pool, 4);

NS_DURING
  ns_result = NSDrawColorTiledRects(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4);
NS_HANDLER
  excp = oc_err_new ("NSDrawColorTiledRects", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_PRIV_C_NSRECT, &ns_result, "NSDrawColorTiledRects", pool);
  [pool release];
  return rb_result;
}

// void NSDrawDarkBezel ( NSRect aRect , NSRect clipRect );
static VALUE
osx_NSDrawDarkBezel(VALUE mdl, VALUE a0, VALUE a1)
{

  NSRect ns_a0;
  NSRect ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, "NSDrawDarkBezel", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRECT, &ns_a1, "NSDrawDarkBezel", pool, 1);

NS_DURING
  NSDrawDarkBezel(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSDrawDarkBezel", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSDrawLightBezel ( NSRect aRect , NSRect clipRect );
static VALUE
osx_NSDrawLightBezel(VALUE mdl, VALUE a0, VALUE a1)
{

  NSRect ns_a0;
  NSRect ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, "NSDrawLightBezel", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRECT, &ns_a1, "NSDrawLightBezel", pool, 1);

NS_DURING
  NSDrawLightBezel(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSDrawLightBezel", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSDottedFrameRect ( NSRect aRect );
static VALUE
osx_NSDottedFrameRect(VALUE mdl, VALUE a0)
{

  NSRect ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, "NSDottedFrameRect", pool, 0);

NS_DURING
  NSDottedFrameRect(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSDottedFrameRect", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSDrawWindowBackground ( NSRect aRect );
static VALUE
osx_NSDrawWindowBackground(VALUE mdl, VALUE a0)
{

  NSRect ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, "NSDrawWindowBackground", pool, 0);

NS_DURING
  NSDrawWindowBackground(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSDrawWindowBackground", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSSetFocusRingStyle ( NSFocusRingPlacement placement );
static VALUE
osx_NSSetFocusRingStyle(VALUE mdl, VALUE a0)
{

  NSFocusRingPlacement ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_INT, &ns_a0, "NSSetFocusRingStyle", pool, 0);

NS_DURING
  NSSetFocusRingStyle(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSSetFocusRingStyle", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSDisableScreenUpdates ( void );
static VALUE
osx_NSDisableScreenUpdates(VALUE mdl)
{
  NSDisableScreenUpdates();
  return Qnil;
}

// void NSEnableScreenUpdates ( void );
static VALUE
osx_NSEnableScreenUpdates(VALUE mdl)
{
  NSEnableScreenUpdates();
  return Qnil;
}

// void NSShowAnimationEffect ( NSAnimationEffect animationEffect , NSPoint centerLocation , NSSize size , id animationDelegate , SEL didEndSelector , void * contextInfo );
static VALUE
osx_NSShowAnimationEffect(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3, VALUE a4, VALUE a5)
{

  NSAnimationEffect ns_a0;
  NSPoint ns_a1;
  NSSize ns_a2;
  id ns_a3;
  SEL ns_a4;
  void * ns_a5;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_INT, &ns_a0, "NSShowAnimationEffect", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSPOINT, &ns_a1, "NSShowAnimationEffect", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _PRIV_C_NSSIZE, &ns_a2, "NSShowAnimationEffect", pool, 2);
  /* a3 */
  rbarg_to_nsarg(a3, _C_ID, &ns_a3, "NSShowAnimationEffect", pool, 3);
  /* a4 */
  rbarg_to_nsarg(a4, _C_SEL, &ns_a4, "NSShowAnimationEffect", pool, 4);
  /* a5 */
  rbarg_to_nsarg(a5, _PRIV_C_PTR, &ns_a5, "NSShowAnimationEffect", pool, 5);

NS_DURING
  NSShowAnimationEffect(ns_a0, ns_a1, ns_a2, ns_a3, ns_a4, ns_a5);
NS_HANDLER
  excp = oc_err_new ("NSShowAnimationEffect", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
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
  rb_define_const(mOSX, "NSBackingStoreRetained", INT2NUM(NSBackingStoreRetained));
  rb_define_const(mOSX, "NSBackingStoreNonretained", INT2NUM(NSBackingStoreNonretained));
  rb_define_const(mOSX, "NSBackingStoreBuffered", INT2NUM(NSBackingStoreBuffered));
  rb_define_const(mOSX, "NSWindowAbove", INT2NUM(NSWindowAbove));
  rb_define_const(mOSX, "NSWindowBelow", INT2NUM(NSWindowBelow));
  rb_define_const(mOSX, "NSWindowOut", INT2NUM(NSWindowOut));
  rb_define_const(mOSX, "NSFocusRingOnly", INT2NUM(NSFocusRingOnly));
  rb_define_const(mOSX, "NSFocusRingBelow", INT2NUM(NSFocusRingBelow));
  rb_define_const(mOSX, "NSFocusRingAbove", INT2NUM(NSFocusRingAbove));
  rb_define_const(mOSX, "NSFocusRingTypeDefault", INT2NUM(NSFocusRingTypeDefault));
  rb_define_const(mOSX, "NSFocusRingTypeNone", INT2NUM(NSFocusRingTypeNone));
  rb_define_const(mOSX, "NSFocusRingTypeExterior", INT2NUM(NSFocusRingTypeExterior));
  rb_define_const(mOSX, "NSAnimationEffectDisappearingItemDefault", INT2NUM(NSAnimationEffectDisappearingItemDefault));
  rb_define_const(mOSX, "NSAnimationEffectPoof", INT2NUM(NSAnimationEffectPoof));

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
  rb_define_module_function(mOSX, "NSDisableScreenUpdates", osx_NSDisableScreenUpdates, 0);
  rb_define_module_function(mOSX, "NSEnableScreenUpdates", osx_NSEnableScreenUpdates, 0);
  rb_define_module_function(mOSX, "NSShowAnimationEffect", osx_NSShowAnimationEffect, 6);
}
