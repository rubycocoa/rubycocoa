#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString *NSGraphicsContextDestinationAttributeName;
static VALUE
osx_NSGraphicsContextDestinationAttributeName(VALUE mdl)
{
  return ocobj_new_with_ocid(NSGraphicsContextDestinationAttributeName);
}

// NSString *NSGraphicsContextRepresentationFormatAttributeName;
static VALUE
osx_NSGraphicsContextRepresentationFormatAttributeName(VALUE mdl)
{
  return ocobj_new_with_ocid(NSGraphicsContextRepresentationFormatAttributeName);
}

// NSString *NSGraphicsContextPSFormat;
static VALUE
osx_NSGraphicsContextPSFormat(VALUE mdl)
{
  return ocobj_new_with_ocid(NSGraphicsContextPSFormat);
}

// NSString *NSGraphicsContextPDFFormat;
static VALUE
osx_NSGraphicsContextPDFFormat(VALUE mdl)
{
  return ocobj_new_with_ocid(NSGraphicsContextPDFFormat);
}

void init_NSGraphicsContext(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSImageInterpolationDefault", INT2NUM(NSImageInterpolationDefault));
  rb_define_const(mOSX, "NSImageInterpolationNone", INT2NUM(NSImageInterpolationNone));
  rb_define_const(mOSX, "NSImageInterpolationLow", INT2NUM(NSImageInterpolationLow));
  rb_define_const(mOSX, "NSImageInterpolationHigh", INT2NUM(NSImageInterpolationHigh));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSGraphicsContextDestinationAttributeName", osx_NSGraphicsContextDestinationAttributeName, 0);
  rb_define_module_function(mOSX, "NSGraphicsContextRepresentationFormatAttributeName", osx_NSGraphicsContextRepresentationFormatAttributeName, 0);
  rb_define_module_function(mOSX, "NSGraphicsContextPSFormat", osx_NSGraphicsContextPSFormat, 0);
  rb_define_module_function(mOSX, "NSGraphicsContextPDFFormat", osx_NSGraphicsContextPDFFormat, 0);
}
