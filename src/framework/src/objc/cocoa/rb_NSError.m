#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSLocalizedDescriptionKey;
static VALUE
osx_NSLocalizedDescriptionKey(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSLocalizedDescriptionKey, "NSLocalizedDescriptionKey", nil);
}

// NSString * const NSUnderlyingErrorKey;
static VALUE
osx_NSUnderlyingErrorKey(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSUnderlyingErrorKey, "NSUnderlyingErrorKey", nil);
}

// NSString * const NSPOSIXErrorDomain;
static VALUE
osx_NSPOSIXErrorDomain(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSPOSIXErrorDomain, "NSPOSIXErrorDomain", nil);
}

// NSString * const NSOSStatusErrorDomain;
static VALUE
osx_NSOSStatusErrorDomain(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSOSStatusErrorDomain, "NSOSStatusErrorDomain", nil);
}

// NSString * const NSMachErrorDomain;
static VALUE
osx_NSMachErrorDomain(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSMachErrorDomain, "NSMachErrorDomain", nil);
}

void init_NSError(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSLocalizedDescriptionKey", osx_NSLocalizedDescriptionKey, 0);
  rb_define_module_function(mOSX, "NSUnderlyingErrorKey", osx_NSUnderlyingErrorKey, 0);
  rb_define_module_function(mOSX, "NSPOSIXErrorDomain", osx_NSPOSIXErrorDomain, 0);
  rb_define_module_function(mOSX, "NSOSStatusErrorDomain", osx_NSOSStatusErrorDomain, 0);
  rb_define_module_function(mOSX, "NSMachErrorDomain", osx_NSMachErrorDomain, 0);
}
