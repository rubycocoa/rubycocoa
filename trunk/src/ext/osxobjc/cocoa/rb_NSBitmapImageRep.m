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
// NSString* NSImageCompressionMethod;
static VALUE
osx_NSImageCompressionMethod(VALUE mdl)
{
  NSString* ns_result = NSImageCompressionMethod;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString* NSImageCompressionFactor;
static VALUE
osx_NSImageCompressionFactor(VALUE mdl)
{
  NSString* ns_result = NSImageCompressionFactor;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString* NSImageDitherTransparency;
static VALUE
osx_NSImageDitherTransparency(VALUE mdl)
{
  NSString* ns_result = NSImageDitherTransparency;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString* NSImageRGBColorTable;
static VALUE
osx_NSImageRGBColorTable(VALUE mdl)
{
  NSString* ns_result = NSImageRGBColorTable;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString* NSImageInterlaced;
static VALUE
osx_NSImageInterlaced(VALUE mdl)
{
  NSString* ns_result = NSImageInterlaced;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString* NSImageColorSyncProfileData;
static VALUE
osx_NSImageColorSyncProfileData(VALUE mdl)
{
  NSString* ns_result = NSImageColorSyncProfileData;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

void init_NSBitmapImageRep(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSTIFFCompressionNone", INT2NUM(NSTIFFCompressionNone));
  rb_define_const(mOSX, "NSTIFFCompressionCCITTFAX3", INT2NUM(NSTIFFCompressionCCITTFAX3));
  rb_define_const(mOSX, "NSTIFFCompressionCCITTFAX4", INT2NUM(NSTIFFCompressionCCITTFAX4));
  rb_define_const(mOSX, "NSTIFFCompressionLZW", INT2NUM(NSTIFFCompressionLZW));
  rb_define_const(mOSX, "NSTIFFCompressionJPEG", INT2NUM(NSTIFFCompressionJPEG));
  rb_define_const(mOSX, "NSTIFFCompressionNEXT", INT2NUM(NSTIFFCompressionNEXT));
  rb_define_const(mOSX, "NSTIFFCompressionPackBits", INT2NUM(NSTIFFCompressionPackBits));
  rb_define_const(mOSX, "NSTIFFCompressionOldJPEG", INT2NUM(NSTIFFCompressionOldJPEG));
  rb_define_const(mOSX, "NSTIFFFileType", INT2NUM(NSTIFFFileType));
  rb_define_const(mOSX, "NSBMPFileType", INT2NUM(NSBMPFileType));
  rb_define_const(mOSX, "NSGIFFileType", INT2NUM(NSGIFFileType));
  rb_define_const(mOSX, "NSJPEGFileType", INT2NUM(NSJPEGFileType));
  rb_define_const(mOSX, "NSPNGFileType", INT2NUM(NSPNGFileType));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSImageCompressionMethod", osx_NSImageCompressionMethod, 0);
  rb_define_module_function(mOSX, "NSImageCompressionFactor", osx_NSImageCompressionFactor, 0);
  rb_define_module_function(mOSX, "NSImageDitherTransparency", osx_NSImageDitherTransparency, 0);
  rb_define_module_function(mOSX, "NSImageRGBColorTable", osx_NSImageRGBColorTable, 0);
  rb_define_module_function(mOSX, "NSImageInterlaced", osx_NSImageInterlaced, 0);
  rb_define_module_function(mOSX, "NSImageColorSyncProfileData", osx_NSImageColorSyncProfileData, 0);
}
