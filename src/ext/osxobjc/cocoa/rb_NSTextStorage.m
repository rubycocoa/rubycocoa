#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

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
