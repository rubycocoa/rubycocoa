#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
#define VA_MAX 4


  /**** constants ****/
// NSString *NSMenuWillSendActionNotification;
static VALUE
osx_NSMenuWillSendActionNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSMenuWillSendActionNotification, nil);
}

// NSString *NSMenuDidSendActionNotification;
static VALUE
osx_NSMenuDidSendActionNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSMenuDidSendActionNotification, nil);
}

// NSString *NSMenuDidAddItemNotification;
static VALUE
osx_NSMenuDidAddItemNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSMenuDidAddItemNotification, nil);
}

// NSString *NSMenuDidRemoveItemNotification;
static VALUE
osx_NSMenuDidRemoveItemNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSMenuDidRemoveItemNotification, nil);
}

// NSString *NSMenuDidChangeItemNotification;
static VALUE
osx_NSMenuDidChangeItemNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSMenuDidChangeItemNotification, nil);
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
