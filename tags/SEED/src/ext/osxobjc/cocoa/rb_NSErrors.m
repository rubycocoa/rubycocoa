#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString *NSTextLineTooLongException;
static VALUE
osx_NSTextLineTooLongException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSTextLineTooLongException);
}

// NSString *NSTextNoSelectionException;
static VALUE
osx_NSTextNoSelectionException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSTextNoSelectionException);
}

// NSString *NSWordTablesWriteException;
static VALUE
osx_NSWordTablesWriteException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWordTablesWriteException);
}

// NSString *NSWordTablesReadException;
static VALUE
osx_NSWordTablesReadException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWordTablesReadException);
}

// NSString *NSTextReadException;
static VALUE
osx_NSTextReadException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSTextReadException);
}

// NSString *NSTextWriteException;
static VALUE
osx_NSTextWriteException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSTextWriteException);
}

// NSString *NSPasteboardCommunicationException;
static VALUE
osx_NSPasteboardCommunicationException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPasteboardCommunicationException);
}

// NSString *NSPrintingCommunicationException;
static VALUE
osx_NSPrintingCommunicationException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintingCommunicationException);
}

// NSString *NSAbortModalException;
static VALUE
osx_NSAbortModalException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSAbortModalException);
}

// NSString *NSAbortPrintingException;
static VALUE
osx_NSAbortPrintingException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSAbortPrintingException);
}

// NSString *NSIllegalSelectorException;
static VALUE
osx_NSIllegalSelectorException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSIllegalSelectorException);
}

// NSString *NSAppKitVirtualMemoryException;
static VALUE
osx_NSAppKitVirtualMemoryException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSAppKitVirtualMemoryException);
}

// NSString *NSBadRTFDirectiveException;
static VALUE
osx_NSBadRTFDirectiveException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSBadRTFDirectiveException);
}

// NSString *NSBadRTFFontTableException;
static VALUE
osx_NSBadRTFFontTableException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSBadRTFFontTableException);
}

// NSString *NSBadRTFStyleSheetException;
static VALUE
osx_NSBadRTFStyleSheetException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSBadRTFStyleSheetException);
}

// NSString *NSTypedStreamVersionException;
static VALUE
osx_NSTypedStreamVersionException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSTypedStreamVersionException);
}

// NSString *NSTIFFException;
static VALUE
osx_NSTIFFException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSTIFFException);
}

// NSString *NSPrintPackageException;
static VALUE
osx_NSPrintPackageException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintPackageException);
}

// NSString *NSBadRTFColorTableException;
static VALUE
osx_NSBadRTFColorTableException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSBadRTFColorTableException);
}

// NSString *NSDraggingException;
static VALUE
osx_NSDraggingException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSDraggingException);
}

// NSString *NSColorListIOException;
static VALUE
osx_NSColorListIOException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSColorListIOException);
}

// NSString *NSColorListNotEditableException;
static VALUE
osx_NSColorListNotEditableException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSColorListNotEditableException);
}

// NSString *NSBadBitmapParametersException;
static VALUE
osx_NSBadBitmapParametersException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSBadBitmapParametersException);
}

// NSString *NSWindowServerCommunicationException;
static VALUE
osx_NSWindowServerCommunicationException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSWindowServerCommunicationException);
}

// NSString *NSFontUnavailableException;
static VALUE
osx_NSFontUnavailableException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSFontUnavailableException);
}

// NSString *NSPPDIncludeNotFoundException;
static VALUE
osx_NSPPDIncludeNotFoundException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPPDIncludeNotFoundException);
}

// NSString *NSPPDParseException;
static VALUE
osx_NSPPDParseException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPPDParseException);
}

// NSString *NSPPDIncludeStackOverflowException;
static VALUE
osx_NSPPDIncludeStackOverflowException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPPDIncludeStackOverflowException);
}

// NSString *NSPPDIncludeStackUnderflowException;
static VALUE
osx_NSPPDIncludeStackUnderflowException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPPDIncludeStackUnderflowException);
}

// NSString *NSRTFPropertyStackOverflowException;
static VALUE
osx_NSRTFPropertyStackOverflowException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSRTFPropertyStackOverflowException);
}

// NSString *NSAppKitIgnoredException;
static VALUE
osx_NSAppKitIgnoredException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSAppKitIgnoredException);
}

// NSString *NSBadComparisonException;
static VALUE
osx_NSBadComparisonException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSBadComparisonException);
}

// NSString *NSImageCacheException;
static VALUE
osx_NSImageCacheException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSImageCacheException);
}

// NSString *NSNibLoadingException;
static VALUE
osx_NSNibLoadingException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSNibLoadingException);
}

// NSString *NSBrowserIllegalDelegateException;
static VALUE
osx_NSBrowserIllegalDelegateException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSBrowserIllegalDelegateException);
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
