#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
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
