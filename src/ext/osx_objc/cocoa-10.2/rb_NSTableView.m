#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString *NSTableViewSelectionDidChangeNotification;
static VALUE
osx_NSTableViewSelectionDidChangeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSTableViewSelectionDidChangeNotification, nil);
}

// NSString *NSTableViewColumnDidMoveNotification;
static VALUE
osx_NSTableViewColumnDidMoveNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSTableViewColumnDidMoveNotification, nil);
}

// NSString *NSTableViewColumnDidResizeNotification;
static VALUE
osx_NSTableViewColumnDidResizeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSTableViewColumnDidResizeNotification, nil);
}

// NSString *NSTableViewSelectionIsChangingNotification;
static VALUE
osx_NSTableViewSelectionIsChangingNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSTableViewSelectionIsChangingNotification, nil);
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
