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
// NSString *NSTextLineTooLongException;
static VALUE
osx_NSTextLineTooLongException(VALUE mdl)
{
  NSString * ns_result = NSTextLineTooLongException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSTextNoSelectionException;
static VALUE
osx_NSTextNoSelectionException(VALUE mdl)
{
  NSString * ns_result = NSTextNoSelectionException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWordTablesWriteException;
static VALUE
osx_NSWordTablesWriteException(VALUE mdl)
{
  NSString * ns_result = NSWordTablesWriteException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWordTablesReadException;
static VALUE
osx_NSWordTablesReadException(VALUE mdl)
{
  NSString * ns_result = NSWordTablesReadException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSTextReadException;
static VALUE
osx_NSTextReadException(VALUE mdl)
{
  NSString * ns_result = NSTextReadException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSTextWriteException;
static VALUE
osx_NSTextWriteException(VALUE mdl)
{
  NSString * ns_result = NSTextWriteException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPasteboardCommunicationException;
static VALUE
osx_NSPasteboardCommunicationException(VALUE mdl)
{
  NSString * ns_result = NSPasteboardCommunicationException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintingCommunicationException;
static VALUE
osx_NSPrintingCommunicationException(VALUE mdl)
{
  NSString * ns_result = NSPrintingCommunicationException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSAbortModalException;
static VALUE
osx_NSAbortModalException(VALUE mdl)
{
  NSString * ns_result = NSAbortModalException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSAbortPrintingException;
static VALUE
osx_NSAbortPrintingException(VALUE mdl)
{
  NSString * ns_result = NSAbortPrintingException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSIllegalSelectorException;
static VALUE
osx_NSIllegalSelectorException(VALUE mdl)
{
  NSString * ns_result = NSIllegalSelectorException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSAppKitVirtualMemoryException;
static VALUE
osx_NSAppKitVirtualMemoryException(VALUE mdl)
{
  NSString * ns_result = NSAppKitVirtualMemoryException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSBadRTFDirectiveException;
static VALUE
osx_NSBadRTFDirectiveException(VALUE mdl)
{
  NSString * ns_result = NSBadRTFDirectiveException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSBadRTFFontTableException;
static VALUE
osx_NSBadRTFFontTableException(VALUE mdl)
{
  NSString * ns_result = NSBadRTFFontTableException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSBadRTFStyleSheetException;
static VALUE
osx_NSBadRTFStyleSheetException(VALUE mdl)
{
  NSString * ns_result = NSBadRTFStyleSheetException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSTypedStreamVersionException;
static VALUE
osx_NSTypedStreamVersionException(VALUE mdl)
{
  NSString * ns_result = NSTypedStreamVersionException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSTIFFException;
static VALUE
osx_NSTIFFException(VALUE mdl)
{
  NSString * ns_result = NSTIFFException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintPackageException;
static VALUE
osx_NSPrintPackageException(VALUE mdl)
{
  NSString * ns_result = NSPrintPackageException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSBadRTFColorTableException;
static VALUE
osx_NSBadRTFColorTableException(VALUE mdl)
{
  NSString * ns_result = NSBadRTFColorTableException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSDraggingException;
static VALUE
osx_NSDraggingException(VALUE mdl)
{
  NSString * ns_result = NSDraggingException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSColorListIOException;
static VALUE
osx_NSColorListIOException(VALUE mdl)
{
  NSString * ns_result = NSColorListIOException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSColorListNotEditableException;
static VALUE
osx_NSColorListNotEditableException(VALUE mdl)
{
  NSString * ns_result = NSColorListNotEditableException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSBadBitmapParametersException;
static VALUE
osx_NSBadBitmapParametersException(VALUE mdl)
{
  NSString * ns_result = NSBadBitmapParametersException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSWindowServerCommunicationException;
static VALUE
osx_NSWindowServerCommunicationException(VALUE mdl)
{
  NSString * ns_result = NSWindowServerCommunicationException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSFontUnavailableException;
static VALUE
osx_NSFontUnavailableException(VALUE mdl)
{
  NSString * ns_result = NSFontUnavailableException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPPDIncludeNotFoundException;
static VALUE
osx_NSPPDIncludeNotFoundException(VALUE mdl)
{
  NSString * ns_result = NSPPDIncludeNotFoundException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPPDParseException;
static VALUE
osx_NSPPDParseException(VALUE mdl)
{
  NSString * ns_result = NSPPDParseException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPPDIncludeStackOverflowException;
static VALUE
osx_NSPPDIncludeStackOverflowException(VALUE mdl)
{
  NSString * ns_result = NSPPDIncludeStackOverflowException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPPDIncludeStackUnderflowException;
static VALUE
osx_NSPPDIncludeStackUnderflowException(VALUE mdl)
{
  NSString * ns_result = NSPPDIncludeStackUnderflowException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSRTFPropertyStackOverflowException;
static VALUE
osx_NSRTFPropertyStackOverflowException(VALUE mdl)
{
  NSString * ns_result = NSRTFPropertyStackOverflowException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSAppKitIgnoredException;
static VALUE
osx_NSAppKitIgnoredException(VALUE mdl)
{
  NSString * ns_result = NSAppKitIgnoredException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSBadComparisonException;
static VALUE
osx_NSBadComparisonException(VALUE mdl)
{
  NSString * ns_result = NSBadComparisonException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSImageCacheException;
static VALUE
osx_NSImageCacheException(VALUE mdl)
{
  NSString * ns_result = NSImageCacheException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSNibLoadingException;
static VALUE
osx_NSNibLoadingException(VALUE mdl)
{
  NSString * ns_result = NSNibLoadingException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSBrowserIllegalDelegateException;
static VALUE
osx_NSBrowserIllegalDelegateException(VALUE mdl)
{
  NSString * ns_result = NSBrowserIllegalDelegateException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

void init_NSErrors(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSTextLineTooLongException", osx_NSTextLineTooLongException, 0);
  rb_define_module_function(mOSX, "NSTextNoSelectionException", osx_NSTextNoSelectionException, 0);
  rb_define_module_function(mOSX, "NSWordTablesWriteException", osx_NSWordTablesWriteException, 0);
  rb_define_module_function(mOSX, "NSWordTablesReadException", osx_NSWordTablesReadException, 0);
  rb_define_module_function(mOSX, "NSTextReadException", osx_NSTextReadException, 0);
  rb_define_module_function(mOSX, "NSTextWriteException", osx_NSTextWriteException, 0);
  rb_define_module_function(mOSX, "NSPasteboardCommunicationException", osx_NSPasteboardCommunicationException, 0);
  rb_define_module_function(mOSX, "NSPrintingCommunicationException", osx_NSPrintingCommunicationException, 0);
  rb_define_module_function(mOSX, "NSAbortModalException", osx_NSAbortModalException, 0);
  rb_define_module_function(mOSX, "NSAbortPrintingException", osx_NSAbortPrintingException, 0);
  rb_define_module_function(mOSX, "NSIllegalSelectorException", osx_NSIllegalSelectorException, 0);
  rb_define_module_function(mOSX, "NSAppKitVirtualMemoryException", osx_NSAppKitVirtualMemoryException, 0);
  rb_define_module_function(mOSX, "NSBadRTFDirectiveException", osx_NSBadRTFDirectiveException, 0);
  rb_define_module_function(mOSX, "NSBadRTFFontTableException", osx_NSBadRTFFontTableException, 0);
  rb_define_module_function(mOSX, "NSBadRTFStyleSheetException", osx_NSBadRTFStyleSheetException, 0);
  rb_define_module_function(mOSX, "NSTypedStreamVersionException", osx_NSTypedStreamVersionException, 0);
  rb_define_module_function(mOSX, "NSTIFFException", osx_NSTIFFException, 0);
  rb_define_module_function(mOSX, "NSPrintPackageException", osx_NSPrintPackageException, 0);
  rb_define_module_function(mOSX, "NSBadRTFColorTableException", osx_NSBadRTFColorTableException, 0);
  rb_define_module_function(mOSX, "NSDraggingException", osx_NSDraggingException, 0);
  rb_define_module_function(mOSX, "NSColorListIOException", osx_NSColorListIOException, 0);
  rb_define_module_function(mOSX, "NSColorListNotEditableException", osx_NSColorListNotEditableException, 0);
  rb_define_module_function(mOSX, "NSBadBitmapParametersException", osx_NSBadBitmapParametersException, 0);
  rb_define_module_function(mOSX, "NSWindowServerCommunicationException", osx_NSWindowServerCommunicationException, 0);
  rb_define_module_function(mOSX, "NSFontUnavailableException", osx_NSFontUnavailableException, 0);
  rb_define_module_function(mOSX, "NSPPDIncludeNotFoundException", osx_NSPPDIncludeNotFoundException, 0);
  rb_define_module_function(mOSX, "NSPPDParseException", osx_NSPPDParseException, 0);
  rb_define_module_function(mOSX, "NSPPDIncludeStackOverflowException", osx_NSPPDIncludeStackOverflowException, 0);
  rb_define_module_function(mOSX, "NSPPDIncludeStackUnderflowException", osx_NSPPDIncludeStackUnderflowException, 0);
  rb_define_module_function(mOSX, "NSRTFPropertyStackOverflowException", osx_NSRTFPropertyStackOverflowException, 0);
  rb_define_module_function(mOSX, "NSAppKitIgnoredException", osx_NSAppKitIgnoredException, 0);
  rb_define_module_function(mOSX, "NSBadComparisonException", osx_NSBadComparisonException, 0);
  rb_define_module_function(mOSX, "NSImageCacheException", osx_NSImageCacheException, 0);
  rb_define_module_function(mOSX, "NSNibLoadingException", osx_NSNibLoadingException, 0);
  rb_define_module_function(mOSX, "NSBrowserIllegalDelegateException", osx_NSBrowserIllegalDelegateException, 0);
}
