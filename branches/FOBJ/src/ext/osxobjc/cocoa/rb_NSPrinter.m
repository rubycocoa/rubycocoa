#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

void init_NSPrinter(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSPrinterTableOK", INT2NUM(NSPrinterTableOK));
  rb_define_const(mOSX, "NSPrinterTableNotFound", INT2NUM(NSPrinterTableNotFound));
  rb_define_const(mOSX, "NSPrinterTableError", INT2NUM(NSPrinterTableError));

}
