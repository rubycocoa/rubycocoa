#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

void init_NSBezierPath(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSButtLineCapStyle", INT2NUM(NSButtLineCapStyle));
  rb_define_const(mOSX, "NSRoundLineCapStyle", INT2NUM(NSRoundLineCapStyle));
  rb_define_const(mOSX, "NSSquareLineCapStyle", INT2NUM(NSSquareLineCapStyle));
  rb_define_const(mOSX, "NSMiterLineJoinStyle", INT2NUM(NSMiterLineJoinStyle));
  rb_define_const(mOSX, "NSRoundLineJoinStyle", INT2NUM(NSRoundLineJoinStyle));
  rb_define_const(mOSX, "NSBevelLineJoinStyle", INT2NUM(NSBevelLineJoinStyle));
  rb_define_const(mOSX, "NSNonZeroWindingRule", INT2NUM(NSNonZeroWindingRule));
  rb_define_const(mOSX, "NSEvenOddWindingRule", INT2NUM(NSEvenOddWindingRule));
  rb_define_const(mOSX, "NSMoveToBezierPathElement", INT2NUM(NSMoveToBezierPathElement));
  rb_define_const(mOSX, "NSLineToBezierPathElement", INT2NUM(NSLineToBezierPathElement));
  rb_define_const(mOSX, "NSCurveToBezierPathElement", INT2NUM(NSCurveToBezierPathElement));
  rb_define_const(mOSX, "NSClosePathBezierPathElement", INT2NUM(NSClosePathBezierPathElement));

}
