#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString *NSPrintOperationExistsException;
static VALUE
osx_NSPrintOperationExistsException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSPrintOperationExistsException, nil);
}

void init_NSPrintOperation(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSDescendingPageOrder", INT2NUM(NSDescendingPageOrder));
  rb_define_const(mOSX, "NSSpecialPageOrder", INT2NUM(NSSpecialPageOrder));
  rb_define_const(mOSX, "NSAscendingPageOrder", INT2NUM(NSAscendingPageOrder));
  rb_define_const(mOSX, "NSUnknownPageOrder", INT2NUM(NSUnknownPageOrder));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSPrintOperationExistsException", osx_NSPrintOperationExistsException, 0);
}
