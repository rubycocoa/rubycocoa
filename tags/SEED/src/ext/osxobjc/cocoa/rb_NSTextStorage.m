#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString *NSTextStorageWillProcessEditingNotification;
static VALUE
osx_NSTextStorageWillProcessEditingNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSTextStorageWillProcessEditingNotification);
}

// NSString *NSTextStorageDidProcessEditingNotification;
static VALUE
osx_NSTextStorageDidProcessEditingNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSTextStorageDidProcessEditingNotification);
}

void init_NSTextStorage(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSTextStorageEditedAttributes", INT2NUM(NSTextStorageEditedAttributes));
  rb_define_const(mOSX, "NSTextStorageEditedCharacters", INT2NUM(NSTextStorageEditedCharacters));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSTextStorageWillProcessEditingNotification", osx_NSTextStorageWillProcessEditingNotification, 0);
  rb_define_module_function(mOSX, "NSTextStorageDidProcessEditingNotification", osx_NSTextStorageDidProcessEditingNotification, 0);
}
