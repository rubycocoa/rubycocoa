#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


void init_NSByteOrder(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NS_UnknownByteOrder", INT2NUM(NS_UnknownByteOrder));
  rb_define_const(mOSX, "NS_LittleEndian", INT2NUM(NS_LittleEndian));
  rb_define_const(mOSX, "NS_BigEndian", INT2NUM(NS_BigEndian));

}
