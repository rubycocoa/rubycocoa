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
// NSString *NSStringPboardType;
static VALUE
osx_NSStringPboardType(VALUE mdl)
{
  NSString * ns_result = NSStringPboardType;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSFilenamesPboardType;
static VALUE
osx_NSFilenamesPboardType(VALUE mdl)
{
  NSString * ns_result = NSFilenamesPboardType;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPostScriptPboardType;
static VALUE
osx_NSPostScriptPboardType(VALUE mdl)
{
  NSString * ns_result = NSPostScriptPboardType;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSTIFFPboardType;
static VALUE
osx_NSTIFFPboardType(VALUE mdl)
{
  NSString * ns_result = NSTIFFPboardType;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSRTFPboardType;
static VALUE
osx_NSRTFPboardType(VALUE mdl)
{
  NSString * ns_result = NSRTFPboardType;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSTabularTextPboardType;
static VALUE
osx_NSTabularTextPboardType(VALUE mdl)
{
  NSString * ns_result = NSTabularTextPboardType;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSFontPboardType;
static VALUE
osx_NSFontPboardType(VALUE mdl)
{
  NSString * ns_result = NSFontPboardType;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSRulerPboardType;
static VALUE
osx_NSRulerPboardType(VALUE mdl)
{
  NSString * ns_result = NSRulerPboardType;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSFileContentsPboardType;
static VALUE
osx_NSFileContentsPboardType(VALUE mdl)
{
  NSString * ns_result = NSFileContentsPboardType;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSColorPboardType;
static VALUE
osx_NSColorPboardType(VALUE mdl)
{
  NSString * ns_result = NSColorPboardType;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSRTFDPboardType;
static VALUE
osx_NSRTFDPboardType(VALUE mdl)
{
  NSString * ns_result = NSRTFDPboardType;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSHTMLPboardType;
static VALUE
osx_NSHTMLPboardType(VALUE mdl)
{
  NSString * ns_result = NSHTMLPboardType;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPICTPboardType;
static VALUE
osx_NSPICTPboardType(VALUE mdl)
{
  NSString * ns_result = NSPICTPboardType;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSURLPboardType;
static VALUE
osx_NSURLPboardType(VALUE mdl)
{
  NSString * ns_result = NSURLPboardType;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPDFPboardType;
static VALUE
osx_NSPDFPboardType(VALUE mdl)
{
  NSString * ns_result = NSPDFPboardType;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSGeneralPboard;
static VALUE
osx_NSGeneralPboard(VALUE mdl)
{
  NSString * ns_result = NSGeneralPboard;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSFontPboard;
static VALUE
osx_NSFontPboard(VALUE mdl)
{
  NSString * ns_result = NSFontPboard;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSRulerPboard;
static VALUE
osx_NSRulerPboard(VALUE mdl)
{
  NSString * ns_result = NSRulerPboard;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSFindPboard;
static VALUE
osx_NSFindPboard(VALUE mdl)
{
  NSString * ns_result = NSFindPboard;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSDragPboard;
static VALUE
osx_NSDragPboard(VALUE mdl)
{
  NSString * ns_result = NSDragPboard;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

  /**** functions ****/
// NSString *NSCreateFilenamePboardType(NSString *fileType);
static VALUE
osx_NSCreateFilenamePboardType(VALUE mdl, VALUE a0)
{
  NSString * ns_result;

  NSString * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);

  ns_result = NSCreateFilenamePboardType(ns_a0);

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, pool);
  [pool release];
  return rb_result;
}

// NSString *NSCreateFileContentsPboardType(NSString *fileType);
static VALUE
osx_NSCreateFileContentsPboardType(VALUE mdl, VALUE a0)
{
  NSString * ns_result;

  NSString * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);

  ns_result = NSCreateFileContentsPboardType(ns_a0);

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, pool);
  [pool release];
  return rb_result;
}

// NSString *NSGetFileType(NSString *pboardType);
static VALUE
osx_NSGetFileType(VALUE mdl, VALUE a0)
{
  NSString * ns_result;

  NSString * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);

  ns_result = NSGetFileType(ns_a0);

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, pool);
  [pool release];
  return rb_result;
}

// NSArray *NSGetFileTypes(NSArray *pboardTypes);
static VALUE
osx_NSGetFileTypes(VALUE mdl, VALUE a0)
{
  NSArray * ns_result;

  NSArray * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);

  ns_result = NSGetFileTypes(ns_a0);

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, pool);
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
  rb_define_module_function(mOSX, "NSCreateFilenamePboardType", osx_NSCreateFilenamePboardType, 1);
  rb_define_module_function(mOSX, "NSCreateFileContentsPboardType", osx_NSCreateFileContentsPboardType, 1);
  rb_define_module_function(mOSX, "NSGetFileType", osx_NSGetFileType, 1);
  rb_define_module_function(mOSX, "NSGetFileTypes", osx_NSGetFileTypes, 1);
}
