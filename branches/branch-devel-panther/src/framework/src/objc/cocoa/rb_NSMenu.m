#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * NSMenuWillSendActionNotification;
static VALUE
osx_NSMenuWillSendActionNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSMenuWillSendActionNotification, "NSMenuWillSendActionNotification", nil);
}

// NSString * NSMenuDidSendActionNotification;
static VALUE
osx_NSMenuDidSendActionNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSMenuDidSendActionNotification, "NSMenuDidSendActionNotification", nil);
}

// NSString * NSMenuDidAddItemNotification;
static VALUE
osx_NSMenuDidAddItemNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSMenuDidAddItemNotification, "NSMenuDidAddItemNotification", nil);
}

// NSString * NSMenuDidRemoveItemNotification;
static VALUE
osx_NSMenuDidRemoveItemNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSMenuDidRemoveItemNotification, "NSMenuDidRemoveItemNotification", nil);
}

// NSString * NSMenuDidChangeItemNotification;
static VALUE
osx_NSMenuDidChangeItemNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSMenuDidChangeItemNotification, "NSMenuDidChangeItemNotification", nil);
}

// NSString * NSMenuDidEndTrackingNotification;
static VALUE
osx_NSMenuDidEndTrackingNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSMenuDidEndTrackingNotification, "NSMenuDidEndTrackingNotification", nil);
}

void init_NSMenu(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSMenuWillSendActionNotification", osx_NSMenuWillSendActionNotification, 0);
  rb_define_module_function(mOSX, "NSMenuDidSendActionNotification", osx_NSMenuDidSendActionNotification, 0);
  rb_define_module_function(mOSX, "NSMenuDidAddItemNotification", osx_NSMenuDidAddItemNotification, 0);
  rb_define_module_function(mOSX, "NSMenuDidRemoveItemNotification", osx_NSMenuDidRemoveItemNotification, 0);
  rb_define_module_function(mOSX, "NSMenuDidChangeItemNotification", osx_NSMenuDidChangeItemNotification, 0);
  rb_define_module_function(mOSX, "NSMenuDidEndTrackingNotification", osx_NSMenuDidEndTrackingNotification, 0);
}
