#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);


  /**** constants ****/
// NSString *NSMenuWillSendActionNotification;
static VALUE
osx_NSMenuWillSendActionNotification(VALUE mdl)
{
  NSString * ns_result = NSMenuWillSendActionNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSMenuDidSendActionNotification;
static VALUE
osx_NSMenuDidSendActionNotification(VALUE mdl)
{
  NSString * ns_result = NSMenuDidSendActionNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSMenuDidAddItemNotification;
static VALUE
osx_NSMenuDidAddItemNotification(VALUE mdl)
{
  NSString * ns_result = NSMenuDidAddItemNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSMenuDidRemoveItemNotification;
static VALUE
osx_NSMenuDidRemoveItemNotification(VALUE mdl)
{
  NSString * ns_result = NSMenuDidRemoveItemNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSMenuDidChangeItemNotification;
static VALUE
osx_NSMenuDidChangeItemNotification(VALUE mdl)
{
  NSString * ns_result = NSMenuDidChangeItemNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

void init_NSMenu(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSMenuWillSendActionNotification", osx_NSMenuWillSendActionNotification, 0);
  rb_define_module_function(mOSX, "NSMenuDidSendActionNotification", osx_NSMenuDidSendActionNotification, 0);
  rb_define_module_function(mOSX, "NSMenuDidAddItemNotification", osx_NSMenuDidAddItemNotification, 0);
  rb_define_module_function(mOSX, "NSMenuDidRemoveItemNotification", osx_NSMenuDidRemoveItemNotification, 0);
  rb_define_module_function(mOSX, "NSMenuDidChangeItemNotification", osx_NSMenuDidChangeItemNotification, 0);
}
