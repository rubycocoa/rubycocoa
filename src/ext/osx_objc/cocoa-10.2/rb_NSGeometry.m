#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// const NSPoint NSZeroPoint;
static VALUE
osx_NSZeroPoint(VALUE mdl)
{
  return nsresult_to_rbresult(_PRIV_C_NSPOINT, &NSZeroPoint, nil);
}

// const NSSize NSZeroSize;
static VALUE
osx_NSZeroSize(VALUE mdl)
{
  return nsresult_to_rbresult(_PRIV_C_NSSIZE, &NSZeroSize, nil);
}

// const NSRect NSZeroRect;
static VALUE
osx_NSZeroRect(VALUE mdl)
{
  return nsresult_to_rbresult(_PRIV_C_NSRECT, &NSZeroRect, nil);
}

  /**** functions ****/
// BOOL NSEqualPoints(NSPoint aPoint, NSPoint bPoint);
static VALUE
osx_NSEqualPoints(VALUE mdl, VALUE a0, VALUE a1)
{
  BOOL ns_result;

  NSPoint ns_a0;
  NSPoint ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSPOINT, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSPOINT, &ns_a1, pool, 1);

  ns_result = NSEqualPoints(ns_a0, ns_a1);

  rb_result = nsresult_to_rbresult(_PRIV_C_BOOL, &ns_result, pool);
  [pool release];
  return rb_result;
}

// BOOL NSEqualSizes(NSSize aSize, NSSize bSize);
static VALUE
osx_NSEqualSizes(VALUE mdl, VALUE a0, VALUE a1)
{
  BOOL ns_result;

  NSSize ns_a0;
  NSSize ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSSIZE, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSSIZE, &ns_a1, pool, 1);

  ns_result = NSEqualSizes(ns_a0, ns_a1);

  rb_result = nsresult_to_rbresult(_PRIV_C_BOOL, &ns_result, pool);
  [pool release];
  return rb_result;
}

// BOOL NSEqualRects(NSRect aRect, NSRect bRect);
static VALUE
osx_NSEqualRects(VALUE mdl, VALUE a0, VALUE a1)
{
  BOOL ns_result;

  NSRect ns_a0;
  NSRect ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRECT, &ns_a1, pool, 1);

  ns_result = NSEqualRects(ns_a0, ns_a1);

  rb_result = nsresult_to_rbresult(_PRIV_C_BOOL, &ns_result, pool);
  [pool release];
  return rb_result;
}

// BOOL NSIsEmptyRect(NSRect aRect);
static VALUE
osx_NSIsEmptyRect(VALUE mdl, VALUE a0)
{
  BOOL ns_result;

  NSRect ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, pool, 0);

  ns_result = NSIsEmptyRect(ns_a0);

  rb_result = nsresult_to_rbresult(_PRIV_C_BOOL, &ns_result, pool);
  [pool release];
  return rb_result;
}

// NSRect NSInsetRect(NSRect aRect, float dX, float dY);
static VALUE
osx_NSInsetRect(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{
  NSRect ns_result;

  NSRect ns_a0;
  float ns_a1;
  float ns_a2;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_FLT, &ns_a1, pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_FLT, &ns_a2, pool, 2);

  ns_result = NSInsetRect(ns_a0, ns_a1, ns_a2);

  rb_result = nsresult_to_rbresult(_PRIV_C_NSRECT, &ns_result, pool);
  [pool release];
  return rb_result;
}

// NSRect NSIntegralRect(NSRect aRect);
static VALUE
osx_NSIntegralRect(VALUE mdl, VALUE a0)
{
  NSRect ns_result;

  NSRect ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, pool, 0);

  ns_result = NSIntegralRect(ns_a0);

  rb_result = nsresult_to_rbresult(_PRIV_C_NSRECT, &ns_result, pool);
  [pool release];
  return rb_result;
}

// NSRect NSUnionRect(NSRect aRect, NSRect bRect);
static VALUE
osx_NSUnionRect(VALUE mdl, VALUE a0, VALUE a1)
{
  NSRect ns_result;

  NSRect ns_a0;
  NSRect ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRECT, &ns_a1, pool, 1);

  ns_result = NSUnionRect(ns_a0, ns_a1);

  rb_result = nsresult_to_rbresult(_PRIV_C_NSRECT, &ns_result, pool);
  [pool release];
  return rb_result;
}

// NSRect NSIntersectionRect(NSRect aRect, NSRect bRect);
static VALUE
osx_NSIntersectionRect(VALUE mdl, VALUE a0, VALUE a1)
{
  NSRect ns_result;

  NSRect ns_a0;
  NSRect ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRECT, &ns_a1, pool, 1);

  ns_result = NSIntersectionRect(ns_a0, ns_a1);

  rb_result = nsresult_to_rbresult(_PRIV_C_NSRECT, &ns_result, pool);
  [pool release];
  return rb_result;
}

// NSRect NSOffsetRect(NSRect aRect, float dX, float dY);
static VALUE
osx_NSOffsetRect(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{
  NSRect ns_result;

  NSRect ns_a0;
  float ns_a1;
  float ns_a2;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_FLT, &ns_a1, pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_FLT, &ns_a2, pool, 2);

  ns_result = NSOffsetRect(ns_a0, ns_a1, ns_a2);

  rb_result = nsresult_to_rbresult(_PRIV_C_NSRECT, &ns_result, pool);
  [pool release];
  return rb_result;
}

// void NSDivideRect(NSRect inRect, NSRect *slice, NSRect *rem, float amount, NSRectEdge edge);
static VALUE
osx_NSDivideRect(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3, VALUE a4)
{
  rb_notimplement();
}

// BOOL NSPointInRect(NSPoint aPoint, NSRect aRect);
static VALUE
osx_NSPointInRect(VALUE mdl, VALUE a0, VALUE a1)
{
  BOOL ns_result;

  NSPoint ns_a0;
  NSRect ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSPOINT, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRECT, &ns_a1, pool, 1);

  ns_result = NSPointInRect(ns_a0, ns_a1);

  rb_result = nsresult_to_rbresult(_PRIV_C_BOOL, &ns_result, pool);
  [pool release];
  return rb_result;
}

// BOOL NSMouseInRect(NSPoint aPoint, NSRect aRect, BOOL flipped);
static VALUE
osx_NSMouseInRect(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{
  BOOL ns_result;

  NSPoint ns_a0;
  NSRect ns_a1;
  BOOL ns_a2;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSPOINT, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRECT, &ns_a1, pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_UCHR, &ns_a2, pool, 2);

  ns_result = NSMouseInRect(ns_a0, ns_a1, ns_a2);

  rb_result = nsresult_to_rbresult(_PRIV_C_BOOL, &ns_result, pool);
  [pool release];
  return rb_result;
}

// BOOL NSContainsRect(NSRect aRect, NSRect bRect);
static VALUE
osx_NSContainsRect(VALUE mdl, VALUE a0, VALUE a1)
{
  BOOL ns_result;

  NSRect ns_a0;
  NSRect ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRECT, &ns_a1, pool, 1);

  ns_result = NSContainsRect(ns_a0, ns_a1);

  rb_result = nsresult_to_rbresult(_PRIV_C_BOOL, &ns_result, pool);
  [pool release];
  return rb_result;
}

// BOOL NSIntersectsRect(NSRect aRect, NSRect bRect);
static VALUE
osx_NSIntersectsRect(VALUE mdl, VALUE a0, VALUE a1)
{
  BOOL ns_result;

  NSRect ns_a0;
  NSRect ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_NSRECT, &ns_a1, pool, 1);

  ns_result = NSIntersectsRect(ns_a0, ns_a1);

  rb_result = nsresult_to_rbresult(_PRIV_C_BOOL, &ns_result, pool);
  [pool release];
  return rb_result;
}

// NSString *NSStringFromPoint(NSPoint aPoint);
static VALUE
osx_NSStringFromPoint(VALUE mdl, VALUE a0)
{
  NSString * ns_result;

  NSPoint ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSPOINT, &ns_a0, pool, 0);

  ns_result = NSStringFromPoint(ns_a0);

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, pool);
  [pool release];
  return rb_result;
}

// NSString *NSStringFromSize(NSSize aSize);
static VALUE
osx_NSStringFromSize(VALUE mdl, VALUE a0)
{
  NSString * ns_result;

  NSSize ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSSIZE, &ns_a0, pool, 0);

  ns_result = NSStringFromSize(ns_a0);

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, pool);
  [pool release];
  return rb_result;
}

// NSString *NSStringFromRect(NSRect aRect);
static VALUE
osx_NSStringFromRect(VALUE mdl, VALUE a0)
{
  NSString * ns_result;

  NSRect ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_NSRECT, &ns_a0, pool, 0);

  ns_result = NSStringFromRect(ns_a0);

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, pool);
  [pool release];
  return rb_result;
}

// NSPoint NSPointFromString(NSString *aString);
static VALUE
osx_NSPointFromString(VALUE mdl, VALUE a0)
{
  NSPoint ns_result;

  NSString * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);

  ns_result = NSPointFromString(ns_a0);

  rb_result = nsresult_to_rbresult(_PRIV_C_NSPOINT, &ns_result, pool);
  [pool release];
  return rb_result;
}

// NSSize NSSizeFromString(NSString *aString);
static VALUE
osx_NSSizeFromString(VALUE mdl, VALUE a0)
{
  NSSize ns_result;

  NSString * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);

  ns_result = NSSizeFromString(ns_a0);

  rb_result = nsresult_to_rbresult(_PRIV_C_NSSIZE, &ns_result, pool);
  [pool release];
  return rb_result;
}

// NSRect NSRectFromString(NSString *aString);
static VALUE
osx_NSRectFromString(VALUE mdl, VALUE a0)
{
  NSRect ns_result;

  NSString * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);

  ns_result = NSRectFromString(ns_a0);

  rb_result = nsresult_to_rbresult(_PRIV_C_NSRECT, &ns_result, pool);
  [pool release];
  return rb_result;
}

void init_NSGeometry(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSMinXEdge", INT2NUM(NSMinXEdge));
  rb_define_const(mOSX, "NSMinYEdge", INT2NUM(NSMinYEdge));
  rb_define_const(mOSX, "NSMaxXEdge", INT2NUM(NSMaxXEdge));
  rb_define_const(mOSX, "NSMaxYEdge", INT2NUM(NSMaxYEdge));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSZeroPoint", osx_NSZeroPoint, 0);
  rb_define_module_function(mOSX, "NSZeroSize", osx_NSZeroSize, 0);
  rb_define_module_function(mOSX, "NSZeroRect", osx_NSZeroRect, 0);
  /**** functions ****/
  rb_define_module_function(mOSX, "NSEqualPoints", osx_NSEqualPoints, 2);
  rb_define_module_function(mOSX, "NSEqualSizes", osx_NSEqualSizes, 2);
  rb_define_module_function(mOSX, "NSEqualRects", osx_NSEqualRects, 2);
  rb_define_module_function(mOSX, "NSIsEmptyRect", osx_NSIsEmptyRect, 1);
  rb_define_module_function(mOSX, "NSInsetRect", osx_NSInsetRect, 3);
  rb_define_module_function(mOSX, "NSIntegralRect", osx_NSIntegralRect, 1);
  rb_define_module_function(mOSX, "NSUnionRect", osx_NSUnionRect, 2);
  rb_define_module_function(mOSX, "NSIntersectionRect", osx_NSIntersectionRect, 2);
  rb_define_module_function(mOSX, "NSOffsetRect", osx_NSOffsetRect, 3);
  rb_define_module_function(mOSX, "NSDivideRect", osx_NSDivideRect, 5);
  rb_define_module_function(mOSX, "NSPointInRect", osx_NSPointInRect, 2);
  rb_define_module_function(mOSX, "NSMouseInRect", osx_NSMouseInRect, 3);
  rb_define_module_function(mOSX, "NSContainsRect", osx_NSContainsRect, 2);
  rb_define_module_function(mOSX, "NSIntersectsRect", osx_NSIntersectsRect, 2);
  rb_define_module_function(mOSX, "NSStringFromPoint", osx_NSStringFromPoint, 1);
  rb_define_module_function(mOSX, "NSStringFromSize", osx_NSStringFromSize, 1);
  rb_define_module_function(mOSX, "NSStringFromRect", osx_NSStringFromRect, 1);
  rb_define_module_function(mOSX, "NSPointFromString", osx_NSPointFromString, 1);
  rb_define_module_function(mOSX, "NSSizeFromString", osx_NSSizeFromString, 1);
  rb_define_module_function(mOSX, "NSRectFromString", osx_NSRectFromString, 1);
}
