#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * NSTextStorageWillProcessEditingNotification;
static VALUE
osx_NSTextStorageWillProcessEditingNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSTextStorageWillProcessEditingNotification, "NSTextStorageWillProcessEditingNotification", nil);
}

// NSString * NSTextStorageDidProcessEditingNotification;
static VALUE
osx_NSTextStorageDidProcessEditingNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSTextStorageDidProcessEditingNotification, "NSTextStorageDidProcessEditingNotification", nil);
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
