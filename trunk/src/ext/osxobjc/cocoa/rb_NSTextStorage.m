#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);


  /**** constants ****/
// NSString *NSTextStorageWillProcessEditingNotification;
static VALUE
osx_NSTextStorageWillProcessEditingNotification(VALUE mdl)
{
  NSString * ns_result = NSTextStorageWillProcessEditingNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSTextStorageDidProcessEditingNotification;
static VALUE
osx_NSTextStorageDidProcessEditingNotification(VALUE mdl)
{
  NSString * ns_result = NSTextStorageDidProcessEditingNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
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
