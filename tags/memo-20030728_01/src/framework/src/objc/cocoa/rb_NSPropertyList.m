#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


void init_NSPropertyList(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSPropertyListImmutable", INT2NUM(NSPropertyListImmutable));
  rb_define_const(mOSX, "NSPropertyListMutableContainers", INT2NUM(NSPropertyListMutableContainers));
  rb_define_const(mOSX, "NSPropertyListMutableContainersAndLeaves", INT2NUM(NSPropertyListMutableContainersAndLeaves));
  rb_define_const(mOSX, "NSPropertyListOpenStepFormat", INT2NUM(NSPropertyListOpenStepFormat));
  rb_define_const(mOSX, "NSPropertyListXMLFormat_v1_0", INT2NUM(NSPropertyListXMLFormat_v1_0));
  rb_define_const(mOSX, "NSPropertyListBinaryFormat_v1_0", INT2NUM(NSPropertyListBinaryFormat_v1_0));

}
