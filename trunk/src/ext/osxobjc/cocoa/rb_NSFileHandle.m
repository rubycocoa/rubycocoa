#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

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
// NSString * const NSFileHandleOperationException;
static VALUE
osx_NSFileHandleOperationException(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSFileHandleReadCompletionNotification;
static VALUE
osx_NSFileHandleReadCompletionNotification(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSFileHandleReadToEndOfFileCompletionNotification;
static VALUE
osx_NSFileHandleReadToEndOfFileCompletionNotification(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSFileHandleConnectionAcceptedNotification;
static VALUE
osx_NSFileHandleConnectionAcceptedNotification(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSFileHandleDataAvailableNotification;
static VALUE
osx_NSFileHandleDataAvailableNotification(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSFileHandleNotificationDataItem;
static VALUE
osx_NSFileHandleNotificationDataItem(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSFileHandleNotificationFileHandleItem;
static VALUE
osx_NSFileHandleNotificationFileHandleItem(VALUE mdl)
{
  rb_notimplement();
}

// NSString * const NSFileHandleNotificationMonitorModes;
static VALUE
osx_NSFileHandleNotificationMonitorModes(VALUE mdl)
{
  rb_notimplement();
}

void init_NSFileHandle(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSFileHandleOperationException", osx_NSFileHandleOperationException, 0);
  rb_define_module_function(mOSX, "NSFileHandleReadCompletionNotification", osx_NSFileHandleReadCompletionNotification, 0);
  rb_define_module_function(mOSX, "NSFileHandleReadToEndOfFileCompletionNotification", osx_NSFileHandleReadToEndOfFileCompletionNotification, 0);
  rb_define_module_function(mOSX, "NSFileHandleConnectionAcceptedNotification", osx_NSFileHandleConnectionAcceptedNotification, 0);
  rb_define_module_function(mOSX, "NSFileHandleDataAvailableNotification", osx_NSFileHandleDataAvailableNotification, 0);
  rb_define_module_function(mOSX, "NSFileHandleNotificationDataItem", osx_NSFileHandleNotificationDataItem, 0);
  rb_define_module_function(mOSX, "NSFileHandleNotificationFileHandleItem", osx_NSFileHandleNotificationFileHandleItem, 0);
  rb_define_module_function(mOSX, "NSFileHandleNotificationMonitorModes", osx_NSFileHandleNotificationMonitorModes, 0);
}
