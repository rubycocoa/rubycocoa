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
// NSString *NSOutlineViewSelectionDidChangeNotification;
static VALUE
osx_NSOutlineViewSelectionDidChangeNotification(VALUE mdl)
{
  NSString * ns_result = NSOutlineViewSelectionDidChangeNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSOutlineViewColumnDidMoveNotification;
static VALUE
osx_NSOutlineViewColumnDidMoveNotification(VALUE mdl)
{
  NSString * ns_result = NSOutlineViewColumnDidMoveNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSOutlineViewColumnDidResizeNotification;
static VALUE
osx_NSOutlineViewColumnDidResizeNotification(VALUE mdl)
{
  NSString * ns_result = NSOutlineViewColumnDidResizeNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSOutlineViewSelectionIsChangingNotification;
static VALUE
osx_NSOutlineViewSelectionIsChangingNotification(VALUE mdl)
{
  NSString * ns_result = NSOutlineViewSelectionIsChangingNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSOutlineViewItemWillExpandNotification;
static VALUE
osx_NSOutlineViewItemWillExpandNotification(VALUE mdl)
{
  NSString * ns_result = NSOutlineViewItemWillExpandNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSOutlineViewItemDidExpandNotification;
static VALUE
osx_NSOutlineViewItemDidExpandNotification(VALUE mdl)
{
  NSString * ns_result = NSOutlineViewItemDidExpandNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSOutlineViewItemWillCollapseNotification;
static VALUE
osx_NSOutlineViewItemWillCollapseNotification(VALUE mdl)
{
  NSString * ns_result = NSOutlineViewItemWillCollapseNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSOutlineViewItemDidCollapseNotification;
static VALUE
osx_NSOutlineViewItemDidCollapseNotification(VALUE mdl)
{
  NSString * ns_result = NSOutlineViewItemDidCollapseNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
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
