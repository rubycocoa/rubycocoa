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
// NSString *NSTableViewSelectionDidChangeNotification;
static VALUE
osx_NSTableViewSelectionDidChangeNotification(VALUE mdl)
{
  NSString * ns_result = NSTableViewSelectionDidChangeNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSTableViewColumnDidMoveNotification;
static VALUE
osx_NSTableViewColumnDidMoveNotification(VALUE mdl)
{
  NSString * ns_result = NSTableViewColumnDidMoveNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSTableViewColumnDidResizeNotification;
static VALUE
osx_NSTableViewColumnDidResizeNotification(VALUE mdl)
{
  NSString * ns_result = NSTableViewColumnDidResizeNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSTableViewSelectionIsChangingNotification;
static VALUE
osx_NSTableViewSelectionIsChangingNotification(VALUE mdl)
{
  NSString * ns_result = NSTableViewSelectionIsChangingNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

void init_NSTableView(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSTableViewDropOn", INT2NUM(NSTableViewDropOn));
  rb_define_const(mOSX, "NSTableViewDropAbove", INT2NUM(NSTableViewDropAbove));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSTableViewSelectionDidChangeNotification", osx_NSTableViewSelectionDidChangeNotification, 0);
  rb_define_module_function(mOSX, "NSTableViewColumnDidMoveNotification", osx_NSTableViewColumnDidMoveNotification, 0);
  rb_define_module_function(mOSX, "NSTableViewColumnDidResizeNotification", osx_NSTableViewColumnDidResizeNotification, 0);
  rb_define_module_function(mOSX, "NSTableViewSelectionIsChangingNotification", osx_NSTableViewSelectionIsChangingNotification, 0);
}
