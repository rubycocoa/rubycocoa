#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString *NSPrintOperationExistsException;
static VALUE
osx_NSPrintOperationExistsException(VALUE mdl)
{
  return ocobj_new_with_ocid(NSPrintOperationExistsException);
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
