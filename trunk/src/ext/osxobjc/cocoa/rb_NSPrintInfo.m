#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);


  /**** constants ****/
// NSString *NSPrintPaperName;
static VALUE
osx_NSPrintPaperName(VALUE mdl)
{
  NSString * ns_result = NSPrintPaperName;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintPaperSize;
static VALUE
osx_NSPrintPaperSize(VALUE mdl)
{
  NSString * ns_result = NSPrintPaperSize;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintFormName;
static VALUE
osx_NSPrintFormName(VALUE mdl)
{
  NSString * ns_result = NSPrintFormName;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintMustCollate;
static VALUE
osx_NSPrintMustCollate(VALUE mdl)
{
  NSString * ns_result = NSPrintMustCollate;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintOrientation;
static VALUE
osx_NSPrintOrientation(VALUE mdl)
{
  NSString * ns_result = NSPrintOrientation;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintLeftMargin;
static VALUE
osx_NSPrintLeftMargin(VALUE mdl)
{
  NSString * ns_result = NSPrintLeftMargin;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintRightMargin;
static VALUE
osx_NSPrintRightMargin(VALUE mdl)
{
  NSString * ns_result = NSPrintRightMargin;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintTopMargin;
static VALUE
osx_NSPrintTopMargin(VALUE mdl)
{
  NSString * ns_result = NSPrintTopMargin;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintBottomMargin;
static VALUE
osx_NSPrintBottomMargin(VALUE mdl)
{
  NSString * ns_result = NSPrintBottomMargin;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintHorizontallyCentered;
static VALUE
osx_NSPrintHorizontallyCentered(VALUE mdl)
{
  NSString * ns_result = NSPrintHorizontallyCentered;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintVerticallyCentered;
static VALUE
osx_NSPrintVerticallyCentered(VALUE mdl)
{
  NSString * ns_result = NSPrintVerticallyCentered;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintHorizontalPagination;
static VALUE
osx_NSPrintHorizontalPagination(VALUE mdl)
{
  NSString * ns_result = NSPrintHorizontalPagination;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintVerticalPagination;
static VALUE
osx_NSPrintVerticalPagination(VALUE mdl)
{
  NSString * ns_result = NSPrintVerticalPagination;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintScalingFactor;
static VALUE
osx_NSPrintScalingFactor(VALUE mdl)
{
  NSString * ns_result = NSPrintScalingFactor;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintAllPages;
static VALUE
osx_NSPrintAllPages(VALUE mdl)
{
  NSString * ns_result = NSPrintAllPages;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintReversePageOrder;
static VALUE
osx_NSPrintReversePageOrder(VALUE mdl)
{
  NSString * ns_result = NSPrintReversePageOrder;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintFirstPage;
static VALUE
osx_NSPrintFirstPage(VALUE mdl)
{
  NSString * ns_result = NSPrintFirstPage;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintLastPage;
static VALUE
osx_NSPrintLastPage(VALUE mdl)
{
  NSString * ns_result = NSPrintLastPage;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintCopies;
static VALUE
osx_NSPrintCopies(VALUE mdl)
{
  NSString * ns_result = NSPrintCopies;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintPagesPerSheet;
static VALUE
osx_NSPrintPagesPerSheet(VALUE mdl)
{
  NSString * ns_result = NSPrintPagesPerSheet;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintJobFeatures;
static VALUE
osx_NSPrintJobFeatures(VALUE mdl)
{
  NSString * ns_result = NSPrintJobFeatures;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintPaperFeed;
static VALUE
osx_NSPrintPaperFeed(VALUE mdl)
{
  NSString * ns_result = NSPrintPaperFeed;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintManualFeed;
static VALUE
osx_NSPrintManualFeed(VALUE mdl)
{
  NSString * ns_result = NSPrintManualFeed;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintPrinter;
static VALUE
osx_NSPrintPrinter(VALUE mdl)
{
  NSString * ns_result = NSPrintPrinter;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintJobDisposition;
static VALUE
osx_NSPrintJobDisposition(VALUE mdl)
{
  NSString * ns_result = NSPrintJobDisposition;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintSavePath;
static VALUE
osx_NSPrintSavePath(VALUE mdl)
{
  NSString * ns_result = NSPrintSavePath;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintFaxReceiverNames;
static VALUE
osx_NSPrintFaxReceiverNames(VALUE mdl)
{
  NSString * ns_result = NSPrintFaxReceiverNames;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintFaxReceiverNumbers;
static VALUE
osx_NSPrintFaxReceiverNumbers(VALUE mdl)
{
  NSString * ns_result = NSPrintFaxReceiverNumbers;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintFaxSendTime;
static VALUE
osx_NSPrintFaxSendTime(VALUE mdl)
{
  NSString * ns_result = NSPrintFaxSendTime;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintFaxUseCoverSheet;
static VALUE
osx_NSPrintFaxUseCoverSheet(VALUE mdl)
{
  NSString * ns_result = NSPrintFaxUseCoverSheet;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintFaxCoverSheetName;
static VALUE
osx_NSPrintFaxCoverSheetName(VALUE mdl)
{
  NSString * ns_result = NSPrintFaxCoverSheetName;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintFaxReturnReceipt;
static VALUE
osx_NSPrintFaxReturnReceipt(VALUE mdl)
{
  NSString * ns_result = NSPrintFaxReturnReceipt;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintFaxHighResolution;
static VALUE
osx_NSPrintFaxHighResolution(VALUE mdl)
{
  NSString * ns_result = NSPrintFaxHighResolution;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintFaxTrimPageEnds;
static VALUE
osx_NSPrintFaxTrimPageEnds(VALUE mdl)
{
  NSString * ns_result = NSPrintFaxTrimPageEnds;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintFaxModem;
static VALUE
osx_NSPrintFaxModem(VALUE mdl)
{
  NSString * ns_result = NSPrintFaxModem;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintSpoolJob;
static VALUE
osx_NSPrintSpoolJob(VALUE mdl)
{
  NSString * ns_result = NSPrintSpoolJob;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintFaxJob;
static VALUE
osx_NSPrintFaxJob(VALUE mdl)
{
  NSString * ns_result = NSPrintFaxJob;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintPreviewJob;
static VALUE
osx_NSPrintPreviewJob(VALUE mdl)
{
  NSString * ns_result = NSPrintPreviewJob;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintSaveJob;
static VALUE
osx_NSPrintSaveJob(VALUE mdl)
{
  NSString * ns_result = NSPrintSaveJob;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSPrintCancelJob;
static VALUE
osx_NSPrintCancelJob(VALUE mdl)
{
  NSString * ns_result = NSPrintCancelJob;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
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
