#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString *NSGraphicsContextDestinationAttributeName;
static VALUE
osx_NSGraphicsContextDestinationAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSGraphicsContextDestinationAttributeName, nil);
}

// NSString *NSGraphicsContextRepresentationFormatAttributeName;
static VALUE
osx_NSGraphicsContextRepresentationFormatAttributeName(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSGraphicsContextRepresentationFormatAttributeName, nil);
}

// NSString *NSGraphicsContextPSFormat;
static VALUE
osx_NSGraphicsContextPSFormat(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSGraphicsContextPSFormat, nil);
}

// NSString *NSGraphicsContextPDFFormat;
static VALUE
osx_NSGraphicsContextPDFFormat(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSGraphicsContextPDFFormat, nil);
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
