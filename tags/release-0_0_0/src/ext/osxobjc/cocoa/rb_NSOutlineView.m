#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString *NSOutlineViewSelectionDidChangeNotification;
static VALUE
osx_NSOutlineViewSelectionDidChangeNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSOutlineViewSelectionDidChangeNotification);
}

// NSString *NSOutlineViewColumnDidMoveNotification;
static VALUE
osx_NSOutlineViewColumnDidMoveNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSOutlineViewColumnDidMoveNotification);
}

// NSString *NSOutlineViewColumnDidResizeNotification;
static VALUE
osx_NSOutlineViewColumnDidResizeNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSOutlineViewColumnDidResizeNotification);
}

// NSString *NSOutlineViewSelectionIsChangingNotification;
static VALUE
osx_NSOutlineViewSelectionIsChangingNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSOutlineViewSelectionIsChangingNotification);
}

// NSString *NSOutlineViewItemWillExpandNotification;
static VALUE
osx_NSOutlineViewItemWillExpandNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSOutlineViewItemWillExpandNotification);
}

// NSString *NSOutlineViewItemDidExpandNotification;
static VALUE
osx_NSOutlineViewItemDidExpandNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSOutlineViewItemDidExpandNotification);
}

// NSString *NSOutlineViewItemWillCollapseNotification;
static VALUE
osx_NSOutlineViewItemWillCollapseNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSOutlineViewItemWillCollapseNotification);
}

// NSString *NSOutlineViewItemDidCollapseNotification;
static VALUE
osx_NSOutlineViewItemDidCollapseNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSOutlineViewItemDidCollapseNotification);
}

void init_NSOutlineView(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSOutlineViewDropOnItemIndex", INT2NUM(NSOutlineViewDropOnItemIndex));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSOutlineViewSelectionDidChangeNotification", osx_NSOutlineViewSelectionDidChangeNotification, 0);
  rb_define_module_function(mOSX, "NSOutlineViewColumnDidMoveNotification", osx_NSOutlineViewColumnDidMoveNotification, 0);
  rb_define_module_function(mOSX, "NSOutlineViewColumnDidResizeNotification", osx_NSOutlineViewColumnDidResizeNotification, 0);
  rb_define_module_function(mOSX, "NSOutlineViewSelectionIsChangingNotification", osx_NSOutlineViewSelectionIsChangingNotification, 0);
  rb_define_module_function(mOSX, "NSOutlineViewItemWillExpandNotification", osx_NSOutlineViewItemWillExpandNotification, 0);
  rb_define_module_function(mOSX, "NSOutlineViewItemDidExpandNotification", osx_NSOutlineViewItemDidExpandNotification, 0);
  rb_define_module_function(mOSX, "NSOutlineViewItemWillCollapseNotification", osx_NSOutlineViewItemWillCollapseNotification, 0);
  rb_define_module_function(mOSX, "NSOutlineViewItemDidCollapseNotification", osx_NSOutlineViewItemDidCollapseNotification, 0);
}
