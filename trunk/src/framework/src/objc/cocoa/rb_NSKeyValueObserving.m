#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * NSKeyValueChangeKindKey;
static VALUE
osx_NSKeyValueChangeKindKey(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSKeyValueChangeKindKey, "NSKeyValueChangeKindKey", nil);
}

// NSString * NSKeyValueChangeNewKey;
static VALUE
osx_NSKeyValueChangeNewKey(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSKeyValueChangeNewKey, "NSKeyValueChangeNewKey", nil);
}

// NSString * NSKeyValueChangeOldKey;
static VALUE
osx_NSKeyValueChangeOldKey(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSKeyValueChangeOldKey, "NSKeyValueChangeOldKey", nil);
}

// NSString * NSKeyValueChangeIndexesKey;
static VALUE
osx_NSKeyValueChangeIndexesKey(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSKeyValueChangeIndexesKey, "NSKeyValueChangeIndexesKey", nil);
}

void init_NSKeyValueObserving(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSKeyValueObservingOptionNew", INT2NUM(NSKeyValueObservingOptionNew));
  rb_define_const(mOSX, "NSKeyValueObservingOptionOld", INT2NUM(NSKeyValueObservingOptionOld));
  rb_define_const(mOSX, "NSKeyValueChangeSetting", INT2NUM(NSKeyValueChangeSetting));
  rb_define_const(mOSX, "NSKeyValueChangeInsertion", INT2NUM(NSKeyValueChangeInsertion));
  rb_define_const(mOSX, "NSKeyValueChangeRemoval", INT2NUM(NSKeyValueChangeRemoval));
  rb_define_const(mOSX, "NSKeyValueChangeReplacement", INT2NUM(NSKeyValueChangeReplacement));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSKeyValueChangeKindKey", osx_NSKeyValueChangeKindKey, 0);
  rb_define_module_function(mOSX, "NSKeyValueChangeNewKey", osx_NSKeyValueChangeNewKey, 0);
  rb_define_module_function(mOSX, "NSKeyValueChangeOldKey", osx_NSKeyValueChangeOldKey, 0);
  rb_define_module_function(mOSX, "NSKeyValueChangeIndexesKey", osx_NSKeyValueChangeIndexesKey, 0);
}
