#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSNetServicesErrorCode;
static VALUE
osx_NSNetServicesErrorCode(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSNetServicesErrorCode, "NSNetServicesErrorCode", nil);
}

// NSString * const NSNetServicesErrorDomain;
static VALUE
osx_NSNetServicesErrorDomain(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSNetServicesErrorDomain, "NSNetServicesErrorDomain", nil);
}

void init_NSNetServices(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSNetServicesUnknownError", INT2NUM(NSNetServicesUnknownError));
  rb_define_const(mOSX, "NSNetServicesCollisionError", INT2NUM(NSNetServicesCollisionError));
  rb_define_const(mOSX, "NSNetServicesNotFoundError", INT2NUM(NSNetServicesNotFoundError));
  rb_define_const(mOSX, "NSNetServicesActivityInProgress", INT2NUM(NSNetServicesActivityInProgress));
  rb_define_const(mOSX, "NSNetServicesBadArgumentError", INT2NUM(NSNetServicesBadArgumentError));
  rb_define_const(mOSX, "NSNetServicesCancelledError", INT2NUM(NSNetServicesCancelledError));
  rb_define_const(mOSX, "NSNetServicesInvalidError", INT2NUM(NSNetServicesInvalidError));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSNetServicesErrorCode", osx_NSNetServicesErrorCode, 0);
  rb_define_module_function(mOSX, "NSNetServicesErrorDomain", osx_NSNetServicesErrorDomain, 0);
}
