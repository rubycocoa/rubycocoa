#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * NSOutlineViewSelectionDidChangeNotification;
static VALUE
osx_NSOutlineViewSelectionDidChangeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSOutlineViewSelectionDidChangeNotification, "NSOutlineViewSelectionDidChangeNotification", nil);
}

// NSString * NSOutlineViewColumnDidMoveNotification;
static VALUE
osx_NSOutlineViewColumnDidMoveNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSOutlineViewColumnDidMoveNotification, "NSOutlineViewColumnDidMoveNotification", nil);
}

// NSString * NSOutlineViewColumnDidResizeNotification;
static VALUE
osx_NSOutlineViewColumnDidResizeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSOutlineViewColumnDidResizeNotification, "NSOutlineViewColumnDidResizeNotification", nil);
}

// NSString * NSOutlineViewSelectionIsChangingNotification;
static VALUE
osx_NSOutlineViewSelectionIsChangingNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSOutlineViewSelectionIsChangingNotification, "NSOutlineViewSelectionIsChangingNotification", nil);
}

// NSString * NSOutlineViewItemWillExpandNotification;
static VALUE
osx_NSOutlineViewItemWillExpandNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSOutlineViewItemWillExpandNotification, "NSOutlineViewItemWillExpandNotification", nil);
}

// NSString * NSOutlineViewItemDidExpandNotification;
static VALUE
osx_NSOutlineViewItemDidExpandNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSOutlineViewItemDidExpandNotification, "NSOutlineViewItemDidExpandNotification", nil);
}

// NSString * NSOutlineViewItemWillCollapseNotification;
static VALUE
osx_NSOutlineViewItemWillCollapseNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSOutlineViewItemWillCollapseNotification, "NSOutlineViewItemWillCollapseNotification", nil);
}

// NSString * NSOutlineViewItemDidCollapseNotification;
static VALUE
osx_NSOutlineViewItemDidCollapseNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSOutlineViewItemDidCollapseNotification, "NSOutlineViewItemDidCollapseNotification", nil);
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
