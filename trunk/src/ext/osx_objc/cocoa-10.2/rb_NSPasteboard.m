#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * NSStringPboardType;
static VALUE
osx_NSStringPboardType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSStringPboardType, "NSStringPboardType", nil);
}

// NSString * NSFilenamesPboardType;
static VALUE
osx_NSFilenamesPboardType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFilenamesPboardType, "NSFilenamesPboardType", nil);
}

// NSString * NSPostScriptPboardType;
static VALUE
osx_NSPostScriptPboardType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSPostScriptPboardType, "NSPostScriptPboardType", nil);
}

// NSString * NSTIFFPboardType;
static VALUE
osx_NSTIFFPboardType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSTIFFPboardType, "NSTIFFPboardType", nil);
}

// NSString * NSRTFPboardType;
static VALUE
osx_NSRTFPboardType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSRTFPboardType, "NSRTFPboardType", nil);
}

// NSString * NSTabularTextPboardType;
static VALUE
osx_NSTabularTextPboardType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSTabularTextPboardType, "NSTabularTextPboardType", nil);
}

// NSString * NSFontPboardType;
static VALUE
osx_NSFontPboardType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFontPboardType, "NSFontPboardType", nil);
}

// NSString * NSRulerPboardType;
static VALUE
osx_NSRulerPboardType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSRulerPboardType, "NSRulerPboardType", nil);
}

// NSString * NSFileContentsPboardType;
static VALUE
osx_NSFileContentsPboardType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFileContentsPboardType, "NSFileContentsPboardType", nil);
}

// NSString * NSColorPboardType;
static VALUE
osx_NSColorPboardType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSColorPboardType, "NSColorPboardType", nil);
}

// NSString * NSRTFDPboardType;
static VALUE
osx_NSRTFDPboardType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSRTFDPboardType, "NSRTFDPboardType", nil);
}

// NSString * NSHTMLPboardType;
static VALUE
osx_NSHTMLPboardType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSHTMLPboardType, "NSHTMLPboardType", nil);
}

// NSString * NSPICTPboardType;
static VALUE
osx_NSPICTPboardType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSPICTPboardType, "NSPICTPboardType", nil);
}

// NSString * NSURLPboardType;
static VALUE
osx_NSURLPboardType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSURLPboardType, "NSURLPboardType", nil);
}

// NSString * NSPDFPboardType;
static VALUE
osx_NSPDFPboardType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSPDFPboardType, "NSPDFPboardType", nil);
}

// NSString * NSVCardPboardType;
static VALUE
osx_NSVCardPboardType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSVCardPboardType, "NSVCardPboardType", nil);
}

// NSString * NSFilesPromisePboardType;
static VALUE
osx_NSFilesPromisePboardType(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFilesPromisePboardType, "NSFilesPromisePboardType", nil);
}

// NSString * NSGeneralPboard;
static VALUE
osx_NSGeneralPboard(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSGeneralPboard, "NSGeneralPboard", nil);
}

// NSString * NSFontPboard;
static VALUE
osx_NSFontPboard(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFontPboard, "NSFontPboard", nil);
}

// NSString * NSRulerPboard;
static VALUE
osx_NSRulerPboard(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSRulerPboard, "NSRulerPboard", nil);
}

// NSString * NSFindPboard;
static VALUE
osx_NSFindPboard(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFindPboard, "NSFindPboard", nil);
}

// NSString * NSDragPboard;
static VALUE
osx_NSDragPboard(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSDragPboard, "NSDragPboard", nil);
}

  /**** functions ****/
// NSString * NSCreateFilenamePboardType ( NSString * fileType );
static VALUE
osx_NSCreateFilenamePboardType(VALUE mdl, VALUE a0)
{
  NSString * ns_result;

  NSString * ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, "NSCreateFilenamePboardType", pool, 0);

NS_DURING
  ns_result = NSCreateFilenamePboardType(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSCreateFilenamePboardType", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, "NSCreateFilenamePboardType", pool);
  [pool release];
  return rb_result;
}

// NSString * NSCreateFileContentsPboardType ( NSString * fileType );
static VALUE
osx_NSCreateFileContentsPboardType(VALUE mdl, VALUE a0)
{
  NSString * ns_result;

  NSString * ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, "NSCreateFileContentsPboardType", pool, 0);

NS_DURING
  ns_result = NSCreateFileContentsPboardType(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSCreateFileContentsPboardType", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, "NSCreateFileContentsPboardType", pool);
  [pool release];
  return rb_result;
}

// NSString * NSGetFileType ( NSString * pboardType );
static VALUE
osx_NSGetFileType(VALUE mdl, VALUE a0)
{
  NSString * ns_result;

  NSString * ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, "NSGetFileType", pool, 0);

NS_DURING
  ns_result = NSGetFileType(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSGetFileType", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, "NSGetFileType", pool);
  [pool release];
  return rb_result;
}

// NSArray * NSGetFileTypes ( NSArray * pboardTypes );
static VALUE
osx_NSGetFileTypes(VALUE mdl, VALUE a0)
{
  NSArray * ns_result;

  NSArray * ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, "NSGetFileTypes", pool, 0);

NS_DURING
  ns_result = NSGetFileTypes(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSGetFileTypes", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, "NSGetFileTypes", pool);
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
  rb_define_module_function(mOSX, "NSVCardPboardType", osx_NSVCardPboardType, 0);
  rb_define_module_function(mOSX, "NSFilesPromisePboardType", osx_NSFilesPromisePboardType, 0);
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
