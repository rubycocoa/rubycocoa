#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
#define VA_MAX 4


void init_NSPrinter(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSPrinterTableOK", INT2NUM(NSPrinterTableOK));
  rb_define_const(mOSX, "NSPrinterTableNotFound", INT2NUM(NSPrinterTableNotFound));
  rb_define_const(mOSX, "NSPrinterTableError", INT2NUM(NSPrinterTableError));

}
