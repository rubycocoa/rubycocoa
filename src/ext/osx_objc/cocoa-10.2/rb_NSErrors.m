#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString *NSTextLineTooLongException;
static VALUE
osx_NSTextLineTooLongException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSTextLineTooLongException, nil);
}

// NSString *NSTextNoSelectionException;
static VALUE
osx_NSTextNoSelectionException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSTextNoSelectionException, nil);
}

// NSString *NSWordTablesWriteException;
static VALUE
osx_NSWordTablesWriteException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWordTablesWriteException, nil);
}

// NSString *NSWordTablesReadException;
static VALUE
osx_NSWordTablesReadException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWordTablesReadException, nil);
}

// NSString *NSTextReadException;
static VALUE
osx_NSTextReadException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSTextReadException, nil);
}

// NSString *NSTextWriteException;
static VALUE
osx_NSTextWriteException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSTextWriteException, nil);
}

// NSString *NSPasteboardCommunicationException;
static VALUE
osx_NSPasteboardCommunicationException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSPasteboardCommunicationException, nil);
}

// NSString *NSPrintingCommunicationException;
static VALUE
osx_NSPrintingCommunicationException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSPrintingCommunicationException, nil);
}

// NSString *NSAbortModalException;
static VALUE
osx_NSAbortModalException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAbortModalException, nil);
}

// NSString *NSAbortPrintingException;
static VALUE
osx_NSAbortPrintingException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAbortPrintingException, nil);
}

// NSString *NSIllegalSelectorException;
static VALUE
osx_NSIllegalSelectorException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSIllegalSelectorException, nil);
}

// NSString *NSAppKitVirtualMemoryException;
static VALUE
osx_NSAppKitVirtualMemoryException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAppKitVirtualMemoryException, nil);
}

// NSString *NSBadRTFDirectiveException;
static VALUE
osx_NSBadRTFDirectiveException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSBadRTFDirectiveException, nil);
}

// NSString *NSBadRTFFontTableException;
static VALUE
osx_NSBadRTFFontTableException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSBadRTFFontTableException, nil);
}

// NSString *NSBadRTFStyleSheetException;
static VALUE
osx_NSBadRTFStyleSheetException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSBadRTFStyleSheetException, nil);
}

// NSString *NSTypedStreamVersionException;
static VALUE
osx_NSTypedStreamVersionException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSTypedStreamVersionException, nil);
}

// NSString *NSTIFFException;
static VALUE
osx_NSTIFFException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSTIFFException, nil);
}

// NSString *NSPrintPackageException;
static VALUE
osx_NSPrintPackageException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSPrintPackageException, nil);
}

// NSString *NSBadRTFColorTableException;
static VALUE
osx_NSBadRTFColorTableException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSBadRTFColorTableException, nil);
}

// NSString *NSDraggingException;
static VALUE
osx_NSDraggingException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSDraggingException, nil);
}

// NSString *NSColorListIOException;
static VALUE
osx_NSColorListIOException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSColorListIOException, nil);
}

// NSString *NSColorListNotEditableException;
static VALUE
osx_NSColorListNotEditableException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSColorListNotEditableException, nil);
}

// NSString *NSBadBitmapParametersException;
static VALUE
osx_NSBadBitmapParametersException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSBadBitmapParametersException, nil);
}

// NSString *NSWindowServerCommunicationException;
static VALUE
osx_NSWindowServerCommunicationException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSWindowServerCommunicationException, nil);
}

// NSString *NSFontUnavailableException;
static VALUE
osx_NSFontUnavailableException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSFontUnavailableException, nil);
}

// NSString *NSPPDIncludeNotFoundException;
static VALUE
osx_NSPPDIncludeNotFoundException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSPPDIncludeNotFoundException, nil);
}

// NSString *NSPPDParseException;
static VALUE
osx_NSPPDParseException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSPPDParseException, nil);
}

// NSString *NSPPDIncludeStackOverflowException;
static VALUE
osx_NSPPDIncludeStackOverflowException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSPPDIncludeStackOverflowException, nil);
}

// NSString *NSPPDIncludeStackUnderflowException;
static VALUE
osx_NSPPDIncludeStackUnderflowException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSPPDIncludeStackUnderflowException, nil);
}

// NSString *NSRTFPropertyStackOverflowException;
static VALUE
osx_NSRTFPropertyStackOverflowException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSRTFPropertyStackOverflowException, nil);
}

// NSString *NSAppKitIgnoredException;
static VALUE
osx_NSAppKitIgnoredException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAppKitIgnoredException, nil);
}

// NSString *NSBadComparisonException;
static VALUE
osx_NSBadComparisonException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSBadComparisonException, nil);
}

// NSString *NSImageCacheException;
static VALUE
osx_NSImageCacheException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSImageCacheException, nil);
}

// NSString *NSNibLoadingException;
static VALUE
osx_NSNibLoadingException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSNibLoadingException, nil);
}

// NSString *NSBrowserIllegalDelegateException;
static VALUE
osx_NSBrowserIllegalDelegateException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSBrowserIllegalDelegateException, nil);
}

// NSString *NSAccessibilityException;
static VALUE
osx_NSAccessibilityException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSAccessibilityException, nil);
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
  rb_define_module_function(mOSX, "NSAccessibilityException", osx_NSAccessibilityException, 0);
}
