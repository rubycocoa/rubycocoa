#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString *NSTableViewSelectionDidChangeNotification;
static VALUE
osx_NSTableViewSelectionDidChangeNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSTableViewSelectionDidChangeNotification);
}

// NSString *NSTableViewColumnDidMoveNotification;
static VALUE
osx_NSTableViewColumnDidMoveNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSTableViewColumnDidMoveNotification);
}

// NSString *NSTableViewColumnDidResizeNotification;
static VALUE
osx_NSTableViewColumnDidResizeNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSTableViewColumnDidResizeNotification);
}

// NSString *NSTableViewSelectionIsChangingNotification;
static VALUE
osx_NSTableViewSelectionIsChangingNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSTableViewSelectionIsChangingNotification);
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
