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
// NSString *NSGraphicsContextDestinationAttributeName;
static VALUE
osx_NSGraphicsContextDestinationAttributeName(VALUE mdl)
{
  NSString * ns_result = NSGraphicsContextDestinationAttributeName;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSGraphicsContextRepresentationFormatAttributeName;
static VALUE
osx_NSGraphicsContextRepresentationFormatAttributeName(VALUE mdl)
{
  NSString * ns_result = NSGraphicsContextRepresentationFormatAttributeName;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSGraphicsContextPSFormat;
static VALUE
osx_NSGraphicsContextPSFormat(VALUE mdl)
{
  NSString * ns_result = NSGraphicsContextPSFormat;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSGraphicsContextPDFFormat;
static VALUE
osx_NSGraphicsContextPDFFormat(VALUE mdl)
{
  NSString * ns_result = NSGraphicsContextPDFFormat;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
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
