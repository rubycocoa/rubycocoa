#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString* NSImageCompressionMethod;
static VALUE
osx_NSImageCompressionMethod(VALUE mdl)
{
  return ocobj_new_with_ocid(NSImageCompressionMethod);
}

// NSString* NSImageCompressionFactor;
static VALUE
osx_NSImageCompressionFactor(VALUE mdl)
{
  return ocobj_new_with_ocid(NSImageCompressionFactor);
}

// NSString* NSImageDitherTransparency;
static VALUE
osx_NSImageDitherTransparency(VALUE mdl)
{
  return ocobj_new_with_ocid(NSImageDitherTransparency);
}

// NSString* NSImageRGBColorTable;
static VALUE
osx_NSImageRGBColorTable(VALUE mdl)
{
  return ocobj_new_with_ocid(NSImageRGBColorTable);
}

// NSString* NSImageInterlaced;
static VALUE
osx_NSImageInterlaced(VALUE mdl)
{
  return ocobj_new_with_ocid(NSImageInterlaced);
}

// NSString* NSImageColorSyncProfileData;
static VALUE
osx_NSImageColorSyncProfileData(VALUE mdl)
{
  return ocobj_new_with_ocid(NSImageColorSyncProfileData);
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
