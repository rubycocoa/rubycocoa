#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


void init_NSURLCredential(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSURLCredentialPersistenceNone", INT2NUM(NSURLCredentialPersistenceNone));
  rb_define_const(mOSX, "NSURLCredentialPersistenceForSession", INT2NUM(NSURLCredentialPersistenceForSession));
  rb_define_const(mOSX, "NSURLCredentialPersistencePermanent", INT2NUM(NSURLCredentialPersistencePermanent));

}
