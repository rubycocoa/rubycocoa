#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <Foundation/Foundation.h>

  /**** constants ****/
// const NSPoint NSZeroPoint;
static VALUE
osx_NSZeroPoint(VALUE mdl)
{
  rb_notimplement();
}

// const NSSize NSZeroSize;
static VALUE
osx_NSZeroSize(VALUE mdl)
{
  rb_notimplement();
}

// const NSRect NSZeroRect;
static VALUE
osx_NSZeroRect(VALUE mdl)
{
  rb_notimplement();
}

  /**** functions ****/
// BOOL NSEqualPoints(NSPoint aPoint, NSPoint bPoint);
static VALUE
osx_NSEqualPoints(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// BOOL NSEqualSizes(NSSize aSize, NSSize bSize);
static VALUE
osx_NSEqualSizes(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// BOOL NSEqualRects(NSRect aRect, NSRect bRect);
static VALUE
osx_NSEqualRects(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// BOOL NSIsEmptyRect(NSRect aRect);
static VALUE
osx_NSIsEmptyRect(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSRect NSInsetRect(NSRect aRect, float dX, float dY);
static VALUE
osx_NSInsetRect(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSRect NSIntegralRect(NSRect aRect);
static VALUE
osx_NSIntegralRect(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSRect NSUnionRect(NSRect aRect, NSRect bRect);
static VALUE
osx_NSUnionRect(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSRect NSIntersectionRect(NSRect aRect, NSRect bRect);
static VALUE
osx_NSIntersectionRect(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSRect NSOffsetRect(NSRect aRect, float dX, float dY);
static VALUE
osx_NSOffsetRect(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSDivideRect(NSRect inRect, NSRect *slice, NSRect *rem, float amount, NSRectEdge edge);
static VALUE
osx_NSDivideRect(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// BOOL NSPointInRect(NSPoint aPoint, NSRect aRect);
static VALUE
osx_NSPointInRect(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// BOOL NSMouseInRect(NSPoint aPoint, NSRect aRect, BOOL flipped);
static VALUE
osx_NSMouseInRect(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// BOOL NSContainsRect(NSRect aRect, NSRect bRect);
static VALUE
osx_NSContainsRect(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// BOOL NSIntersectsRect(NSRect aRect, NSRect bRect);
static VALUE
osx_NSIntersectsRect(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSString *NSStringFromPoint(NSPoint aPoint);
static VALUE
osx_NSStringFromPoint(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSString *NSStringFromSize(NSSize aSize);
static VALUE
osx_NSStringFromSize(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSString *NSStringFromRect(NSRect aRect);
static VALUE
osx_NSStringFromRect(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSPoint NSPointFromString(NSString *aString);
static VALUE
osx_NSPointFromString(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSSize NSSizeFromString(NSString *aString);
static VALUE
osx_NSSizeFromString(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSRect NSRectFromString(NSString *aString);
static VALUE
osx_NSRectFromString(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
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
  rb_define_module_function(mOSX, "NSEqualPoints", osx_NSEqualPoints, -1);
  rb_define_module_function(mOSX, "NSEqualSizes", osx_NSEqualSizes, -1);
  rb_define_module_function(mOSX, "NSEqualRects", osx_NSEqualRects, -1);
  rb_define_module_function(mOSX, "NSIsEmptyRect", osx_NSIsEmptyRect, -1);
  rb_define_module_function(mOSX, "NSInsetRect", osx_NSInsetRect, -1);
  rb_define_module_function(mOSX, "NSIntegralRect", osx_NSIntegralRect, -1);
  rb_define_module_function(mOSX, "NSUnionRect", osx_NSUnionRect, -1);
  rb_define_module_function(mOSX, "NSIntersectionRect", osx_NSIntersectionRect, -1);
  rb_define_module_function(mOSX, "NSOffsetRect", osx_NSOffsetRect, -1);
  rb_define_module_function(mOSX, "NSDivideRect", osx_NSDivideRect, -1);
  rb_define_module_function(mOSX, "NSPointInRect", osx_NSPointInRect, -1);
  rb_define_module_function(mOSX, "NSMouseInRect", osx_NSMouseInRect, -1);
  rb_define_module_function(mOSX, "NSContainsRect", osx_NSContainsRect, -1);
  rb_define_module_function(mOSX, "NSIntersectsRect", osx_NSIntersectsRect, -1);
  rb_define_module_function(mOSX, "NSStringFromPoint", osx_NSStringFromPoint, -1);
  rb_define_module_function(mOSX, "NSStringFromSize", osx_NSStringFromSize, -1);
  rb_define_module_function(mOSX, "NSStringFromRect", osx_NSStringFromRect, -1);
  rb_define_module_function(mOSX, "NSPointFromString", osx_NSPointFromString, -1);
  rb_define_module_function(mOSX, "NSSizeFromString", osx_NSSizeFromString, -1);
  rb_define_module_function(mOSX, "NSRectFromString", osx_NSRectFromString, -1);
}
