#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString *NSStringPboardType;
static VALUE
osx_NSStringPboardType(VALUE mdl)
{
  return ocobj_new_with_ocid(NSStringPboardType);
}

// NSString *NSFilenamesPboardType;
static VALUE
osx_NSFilenamesPboardType(VALUE mdl)
{
  return ocobj_new_with_ocid(NSFilenamesPboardType);
}

// NSString *NSPostScriptPboardType;
static VALUE
osx_NSPostScriptPboardType(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPostScriptPboardType);
}

// NSString *NSTIFFPboardType;
static VALUE
osx_NSTIFFPboardType(VALUE mdl)
{
  return ocobj_new_with_ocid(NSTIFFPboardType);
}

// NSString *NSRTFPboardType;
static VALUE
osx_NSRTFPboardType(VALUE mdl)
{
  return ocobj_new_with_ocid(NSRTFPboardType);
}

// NSString *NSTabularTextPboardType;
static VALUE
osx_NSTabularTextPboardType(VALUE mdl)
{
  return ocobj_new_with_ocid(NSTabularTextPboardType);
}

// NSString *NSFontPboardType;
static VALUE
osx_NSFontPboardType(VALUE mdl)
{
  return ocobj_new_with_ocid(NSFontPboardType);
}

// NSString *NSRulerPboardType;
static VALUE
osx_NSRulerPboardType(VALUE mdl)
{
  return ocobj_new_with_ocid(NSRulerPboardType);
}

// NSString *NSFileContentsPboardType;
static VALUE
osx_NSFileContentsPboardType(VALUE mdl)
{
  return ocobj_new_with_ocid(NSFileContentsPboardType);
}

// NSString *NSColorPboardType;
static VALUE
osx_NSColorPboardType(VALUE mdl)
{
  return ocobj_new_with_ocid(NSColorPboardType);
}

// NSString *NSRTFDPboardType;
static VALUE
osx_NSRTFDPboardType(VALUE mdl)
{
  return ocobj_new_with_ocid(NSRTFDPboardType);
}

// NSString *NSHTMLPboardType;
static VALUE
osx_NSHTMLPboardType(VALUE mdl)
{
  return ocobj_new_with_ocid(NSHTMLPboardType);
}

// NSString *NSPICTPboardType;
static VALUE
osx_NSPICTPboardType(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPICTPboardType);
}

// NSString *NSURLPboardType;
static VALUE
osx_NSURLPboardType(VALUE mdl)
{
  return ocobj_new_with_ocid(NSURLPboardType);
}

// NSString *NSPDFPboardType;
static VALUE
osx_NSPDFPboardType(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPDFPboardType);
}

// NSString *NSGeneralPboard;
static VALUE
osx_NSGeneralPboard(VALUE mdl)
{
  return ocobj_new_with_ocid(NSGeneralPboard);
}

// NSString *NSFontPboard;
static VALUE
osx_NSFontPboard(VALUE mdl)
{
  return ocobj_new_with_ocid(NSFontPboard);
}

// NSString *NSRulerPboard;
static VALUE
osx_NSRulerPboard(VALUE mdl)
{
  return ocobj_new_with_ocid(NSRulerPboard);
}

// NSString *NSFindPboard;
static VALUE
osx_NSFindPboard(VALUE mdl)
{
  return ocobj_new_with_ocid(NSFindPboard);
}

// NSString *NSDragPboard;
static VALUE
osx_NSDragPboard(VALUE mdl)
{
  return ocobj_new_with_ocid(NSDragPboard);
}

  /**** functions ****/
// NSString *NSCreateFilenamePboardType(NSString *fileType);
static VALUE
osx_NSCreateFilenamePboardType(int argc, VALUE* argv, VALUE mdl)
{
  id pool = [[NSAutoreleasePool alloc] init];
  id ns_result;
  VALUE rb_result;
    int i;
  id oc_args[1];
  for (i = 0; i < argc; i++) {
    if (!rbobj_to_nsobj(argv[i], &oc_args[i])) {
      [pool release];
      rb_raise(rb_eArgError, "arg #%d cannot convert to nsobj.", i);
    }
  }

  ns_result =  NSCreateFilenamePboardType(oc_args[0]);
  rb_result = ocobj_new_with_ocid(ns_result);
  [pool release];
  return rb_result;
}

// NSString *NSCreateFileContentsPboardType(NSString *fileType);
static VALUE
osx_NSCreateFileContentsPboardType(int argc, VALUE* argv, VALUE mdl)
{
  id pool = [[NSAutoreleasePool alloc] init];
  id ns_result;
  VALUE rb_result;
    int i;
  id oc_args[1];
  for (i = 0; i < argc; i++) {
    if (!rbobj_to_nsobj(argv[i], &oc_args[i])) {
      [pool release];
      rb_raise(rb_eArgError, "arg #%d cannot convert to nsobj.", i);
    }
  }

  ns_result =  NSCreateFileContentsPboardType(oc_args[0]);
  rb_result = ocobj_new_with_ocid(ns_result);
  [pool release];
  return rb_result;
}

// NSString *NSGetFileType(NSString *pboardType);
static VALUE
osx_NSGetFileType(int argc, VALUE* argv, VALUE mdl)
{
  id pool = [[NSAutoreleasePool alloc] init];
  id ns_result;
  VALUE rb_result;
    int i;
  id oc_args[1];
  for (i = 0; i < argc; i++) {
    if (!rbobj_to_nsobj(argv[i], &oc_args[i])) {
      [pool release];
      rb_raise(rb_eArgError, "arg #%d cannot convert to nsobj.", i);
    }
  }

  ns_result =  NSGetFileType(oc_args[0]);
  rb_result = ocobj_new_with_ocid(ns_result);
  [pool release];
  return rb_result;
}

// NSArray *NSGetFileTypes(NSArray *pboardTypes);
static VALUE
osx_NSGetFileTypes(int argc, VALUE* argv, VALUE mdl)
{
  id pool = [[NSAutoreleasePool alloc] init];
  id ns_result;
  VALUE rb_result;
    int i;
  id oc_args[1];
  for (i = 0; i < argc; i++) {
    if (!rbobj_to_nsobj(argv[i], &oc_args[i])) {
      [pool release];
      rb_raise(rb_eArgError, "arg #%d cannot convert to nsobj.", i);
    }
  }

  ns_result =  NSGetFileTypes(oc_args[0]);
  rb_result = ocobj_new_with_ocid(ns_result);
  [pool release];
  return rb_result;
}

void init_NSPasteboard(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSStringPboardType", osx_NSStringPboardType, 0);
  rb_define_module_function(mOSX, "NSFilenamesPboardType", osx_NSFilenamesPboardType, 0);
  rb_define_module_function(mOSX, "NSPostScriptPboardType", osx_NSPostScriptPboardType, 0);
  rb_define_module_function(mOSX, "NSTIFFPboardType", osx_NSTIFFPboardType, 0);
  rb_define_module_function(mOSX, "NSRTFPboardType", osx_NSRTFPboardType, 0);
  rb_define_module_function(mOSX, "NSTabularTextPboardType", osx_NSTabularTextPboardType, 0);
  rb_define_module_function(mOSX, "NSFontPboardType", osx_NSFontPboardType, 0);
  rb_define_module_function(mOSX, "NSRulerPboardType", osx_NSRulerPboardType, 0);
  rb_define_module_function(mOSX, "NSFileContentsPboardType", osx_NSFileContentsPboardType, 0);
  rb_define_module_function(mOSX, "NSColorPboardType", osx_NSColorPboardType, 0);
  rb_define_module_function(mOSX, "NSRTFDPboardType", osx_NSRTFDPboardType, 0);
  rb_define_module_function(mOSX, "NSHTMLPboardType", osx_NSHTMLPboardType, 0);
  rb_define_module_function(mOSX, "NSPICTPboardType", osx_NSPICTPboardType, 0);
  rb_define_module_function(mOSX, "NSURLPboardType", osx_NSURLPboardType, 0);
  rb_define_module_function(mOSX, "NSPDFPboardType", osx_NSPDFPboardType, 0);
  rb_define_module_function(mOSX, "NSGeneralPboard", osx_NSGeneralPboard, 0);
  rb_define_module_function(mOSX, "NSFontPboard", osx_NSFontPboard, 0);
  rb_define_module_function(mOSX, "NSRulerPboard", osx_NSRulerPboard, 0);
  rb_define_module_function(mOSX, "NSFindPboard", osx_NSFindPboard, 0);
  rb_define_module_function(mOSX, "NSDragPboard", osx_NSDragPboard, 0);
  /**** functions ****/
  rb_define_module_function(mOSX, "NSCreateFilenamePboardType", osx_NSCreateFilenamePboardType, -1);
  rb_define_module_function(mOSX, "NSCreateFileContentsPboardType", osx_NSCreateFileContentsPboardType, -1);
  rb_define_module_function(mOSX, "NSGetFileType", osx_NSGetFileType, -1);
  rb_define_module_function(mOSX, "NSGetFileTypes", osx_NSGetFileTypes, -1);
}
