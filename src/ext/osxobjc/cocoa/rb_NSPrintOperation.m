#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

static void
rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index)
{
  if (!rbobj_to_ocdata(rbarg, octype, nsarg)) {
    if (pool) [pool release];
    rb_raise(rb_eArgError, "arg #%d cannot convert to nsobj.", index);
  }
}

static VALUE
nsresult_to_rbresult(int octype, const void* nsresult, id pool)
{
  VALUE rbresult;
  if (octype == _C_ID) {
    rbresult = ocobj_new_with_ocid(*(id*)nsresult);
  }
  else {
    if (!ocdata_to_rbobj(octype, nsresult, &rbresult)) {
      if (pool) [pool release];
      rb_raise(rb_eRuntimeError, "result cannot convert to rbobj.");
    }
  }
  return rbresult;
}


  /**** constants ****/
// NSString *NSPrintOperationExistsException;
static VALUE
osx_NSPrintOperationExistsException(VALUE mdl)
{
  NSString * ns_result = NSPrintOperationExistsException;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
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
