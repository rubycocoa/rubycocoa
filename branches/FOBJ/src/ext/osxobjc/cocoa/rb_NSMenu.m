#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString *NSMenuWillSendActionNotification;
static VALUE
osx_NSMenuWillSendActionNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSMenuWillSendActionNotification);
}

// NSString *NSMenuDidSendActionNotification;
static VALUE
osx_NSMenuDidSendActionNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSMenuDidSendActionNotification);
}

// NSString *NSMenuDidAddItemNotification;
static VALUE
osx_NSMenuDidAddItemNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSMenuDidAddItemNotification);
}

// NSString *NSMenuDidRemoveItemNotification;
static VALUE
osx_NSMenuDidRemoveItemNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSMenuDidRemoveItemNotification);
}

// NSString *NSMenuDidChangeItemNotification;
static VALUE
osx_NSMenuDidChangeItemNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSMenuDidChangeItemNotification);
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
