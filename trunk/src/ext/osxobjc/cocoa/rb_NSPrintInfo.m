#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString *NSPrintPaperName;
static VALUE
osx_NSPrintPaperName(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintPaperName);
}

// NSString *NSPrintPaperSize;
static VALUE
osx_NSPrintPaperSize(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintPaperSize);
}

// NSString *NSPrintFormName;
static VALUE
osx_NSPrintFormName(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintFormName);
}

// NSString *NSPrintMustCollate;
static VALUE
osx_NSPrintMustCollate(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintMustCollate);
}

// NSString *NSPrintOrientation;
static VALUE
osx_NSPrintOrientation(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintOrientation);
}

// NSString *NSPrintLeftMargin;
static VALUE
osx_NSPrintLeftMargin(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintLeftMargin);
}

// NSString *NSPrintRightMargin;
static VALUE
osx_NSPrintRightMargin(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintRightMargin);
}

// NSString *NSPrintTopMargin;
static VALUE
osx_NSPrintTopMargin(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintTopMargin);
}

// NSString *NSPrintBottomMargin;
static VALUE
osx_NSPrintBottomMargin(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintBottomMargin);
}

// NSString *NSPrintHorizontallyCentered;
static VALUE
osx_NSPrintHorizontallyCentered(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintHorizontallyCentered);
}

// NSString *NSPrintVerticallyCentered;
static VALUE
osx_NSPrintVerticallyCentered(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintVerticallyCentered);
}

// NSString *NSPrintHorizontalPagination;
static VALUE
osx_NSPrintHorizontalPagination(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintHorizontalPagination);
}

// NSString *NSPrintVerticalPagination;
static VALUE
osx_NSPrintVerticalPagination(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintVerticalPagination);
}

// NSString *NSPrintScalingFactor;
static VALUE
osx_NSPrintScalingFactor(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintScalingFactor);
}

// NSString *NSPrintAllPages;
static VALUE
osx_NSPrintAllPages(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintAllPages);
}

// NSString *NSPrintReversePageOrder;
static VALUE
osx_NSPrintReversePageOrder(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintReversePageOrder);
}

// NSString *NSPrintFirstPage;
static VALUE
osx_NSPrintFirstPage(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintFirstPage);
}

// NSString *NSPrintLastPage;
static VALUE
osx_NSPrintLastPage(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintLastPage);
}

// NSString *NSPrintCopies;
static VALUE
osx_NSPrintCopies(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintCopies);
}

// NSString *NSPrintPagesPerSheet;
static VALUE
osx_NSPrintPagesPerSheet(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintPagesPerSheet);
}

// NSString *NSPrintJobFeatures;
static VALUE
osx_NSPrintJobFeatures(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintJobFeatures);
}

// NSString *NSPrintPaperFeed;
static VALUE
osx_NSPrintPaperFeed(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintPaperFeed);
}

// NSString *NSPrintManualFeed;
static VALUE
osx_NSPrintManualFeed(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintManualFeed);
}

// NSString *NSPrintPrinter;
static VALUE
osx_NSPrintPrinter(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintPrinter);
}

// NSString *NSPrintJobDisposition;
static VALUE
osx_NSPrintJobDisposition(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintJobDisposition);
}

// NSString *NSPrintSavePath;
static VALUE
osx_NSPrintSavePath(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintSavePath);
}

// NSString *NSPrintFaxReceiverNames;
static VALUE
osx_NSPrintFaxReceiverNames(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintFaxReceiverNames);
}

// NSString *NSPrintFaxReceiverNumbers;
static VALUE
osx_NSPrintFaxReceiverNumbers(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintFaxReceiverNumbers);
}

// NSString *NSPrintFaxSendTime;
static VALUE
osx_NSPrintFaxSendTime(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintFaxSendTime);
}

// NSString *NSPrintFaxUseCoverSheet;
static VALUE
osx_NSPrintFaxUseCoverSheet(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintFaxUseCoverSheet);
}

// NSString *NSPrintFaxCoverSheetName;
static VALUE
osx_NSPrintFaxCoverSheetName(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintFaxCoverSheetName);
}

// NSString *NSPrintFaxReturnReceipt;
static VALUE
osx_NSPrintFaxReturnReceipt(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintFaxReturnReceipt);
}

// NSString *NSPrintFaxHighResolution;
static VALUE
osx_NSPrintFaxHighResolution(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintFaxHighResolution);
}

// NSString *NSPrintFaxTrimPageEnds;
static VALUE
osx_NSPrintFaxTrimPageEnds(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintFaxTrimPageEnds);
}

// NSString *NSPrintFaxModem;
static VALUE
osx_NSPrintFaxModem(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintFaxModem);
}

// NSString *NSPrintSpoolJob;
static VALUE
osx_NSPrintSpoolJob(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintSpoolJob);
}

// NSString *NSPrintFaxJob;
static VALUE
osx_NSPrintFaxJob(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintFaxJob);
}

// NSString *NSPrintPreviewJob;
static VALUE
osx_NSPrintPreviewJob(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintPreviewJob);
}

// NSString *NSPrintSaveJob;
static VALUE
osx_NSPrintSaveJob(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintSaveJob);
}

// NSString *NSPrintCancelJob;
static VALUE
osx_NSPrintCancelJob(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintCancelJob);
}

void init_NSPrintInfo(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSPortraitOrientation", INT2NUM(NSPortraitOrientation));
  rb_define_const(mOSX, "NSLandscapeOrientation", INT2NUM(NSLandscapeOrientation));
  rb_define_const(mOSX, "NSAutoPagination", INT2NUM(NSAutoPagination));
  rb_define_const(mOSX, "NSFitPagination", INT2NUM(NSFitPagination));
  rb_define_const(mOSX, "NSClipPagination", INT2NUM(NSClipPagination));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSPrintPaperName", osx_NSPrintPaperName, 0);
  rb_define_module_function(mOSX, "NSPrintPaperSize", osx_NSPrintPaperSize, 0);
  rb_define_module_function(mOSX, "NSPrintFormName", osx_NSPrintFormName, 0);
  rb_define_module_function(mOSX, "NSPrintMustCollate", osx_NSPrintMustCollate, 0);
  rb_define_module_function(mOSX, "NSPrintOrientation", osx_NSPrintOrientation, 0);
  rb_define_module_function(mOSX, "NSPrintLeftMargin", osx_NSPrintLeftMargin, 0);
  rb_define_module_function(mOSX, "NSPrintRightMargin", osx_NSPrintRightMargin, 0);
  rb_define_module_function(mOSX, "NSPrintTopMargin", osx_NSPrintTopMargin, 0);
  rb_define_module_function(mOSX, "NSPrintBottomMargin", osx_NSPrintBottomMargin, 0);
  rb_define_module_function(mOSX, "NSPrintHorizontallyCentered", osx_NSPrintHorizontallyCentered, 0);
  rb_define_module_function(mOSX, "NSPrintVerticallyCentered", osx_NSPrintVerticallyCentered, 0);
  rb_define_module_function(mOSX, "NSPrintHorizontalPagination", osx_NSPrintHorizontalPagination, 0);
  rb_define_module_function(mOSX, "NSPrintVerticalPagination", osx_NSPrintVerticalPagination, 0);
  rb_define_module_function(mOSX, "NSPrintScalingFactor", osx_NSPrintScalingFactor, 0);
  rb_define_module_function(mOSX, "NSPrintAllPages", osx_NSPrintAllPages, 0);
  rb_define_module_function(mOSX, "NSPrintReversePageOrder", osx_NSPrintReversePageOrder, 0);
  rb_define_module_function(mOSX, "NSPrintFirstPage", osx_NSPrintFirstPage, 0);
  rb_define_module_function(mOSX, "NSPrintLastPage", osx_NSPrintLastPage, 0);
  rb_define_module_function(mOSX, "NSPrintCopies", osx_NSPrintCopies, 0);
  rb_define_module_function(mOSX, "NSPrintPagesPerSheet", osx_NSPrintPagesPerSheet, 0);
  rb_define_module_function(mOSX, "NSPrintJobFeatures", osx_NSPrintJobFeatures, 0);
  rb_define_module_function(mOSX, "NSPrintPaperFeed", osx_NSPrintPaperFeed, 0);
  rb_define_module_function(mOSX, "NSPrintManualFeed", osx_NSPrintManualFeed, 0);
  rb_define_module_function(mOSX, "NSPrintPrinter", osx_NSPrintPrinter, 0);
  rb_define_module_function(mOSX, "NSPrintJobDisposition", osx_NSPrintJobDisposition, 0);
  rb_define_module_function(mOSX, "NSPrintSavePath", osx_NSPrintSavePath, 0);
  rb_define_module_function(mOSX, "NSPrintFaxReceiverNames", osx_NSPrintFaxReceiverNames, 0);
  rb_define_module_function(mOSX, "NSPrintFaxReceiverNumbers", osx_NSPrintFaxReceiverNumbers, 0);
  rb_define_module_function(mOSX, "NSPrintFaxSendTime", osx_NSPrintFaxSendTime, 0);
  rb_define_module_function(mOSX, "NSPrintFaxUseCoverSheet", osx_NSPrintFaxUseCoverSheet, 0);
  rb_define_module_function(mOSX, "NSPrintFaxCoverSheetName", osx_NSPrintFaxCoverSheetName, 0);
  rb_define_module_function(mOSX, "NSPrintFaxReturnReceipt", osx_NSPrintFaxReturnReceipt, 0);
  rb_define_module_function(mOSX, "NSPrintFaxHighResolution", osx_NSPrintFaxHighResolution, 0);
  rb_define_module_function(mOSX, "NSPrintFaxTrimPageEnds", osx_NSPrintFaxTrimPageEnds, 0);
  rb_define_module_function(mOSX, "NSPrintFaxModem", osx_NSPrintFaxModem, 0);
  rb_define_module_function(mOSX, "NSPrintSpoolJob", osx_NSPrintSpoolJob, 0);
  rb_define_module_function(mOSX, "NSPrintFaxJob", osx_NSPrintFaxJob, 0);
  rb_define_module_function(mOSX, "NSPrintPreviewJob", osx_NSPrintPreviewJob, 0);
  rb_define_module_function(mOSX, "NSPrintSaveJob", osx_NSPrintSaveJob, 0);
  rb_define_module_function(mOSX, "NSPrintCancelJob", osx_NSPrintCancelJob, 0);
}
