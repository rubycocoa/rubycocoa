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
// NSString *NSComboBoxWillPopUpNotification;
static VALUE
osx_NSComboBoxWillPopUpNotification(VALUE mdl)
{
  NSString * ns_result = NSComboBoxWillPopUpNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSComboBoxWillDismissNotification;
static VALUE
osx_NSComboBoxWillDismissNotification(VALUE mdl)
{
  NSString * ns_result = NSComboBoxWillDismissNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSComboBoxSelectionDidChangeNotification;
static VALUE
osx_NSComboBoxSelectionDidChangeNotification(VALUE mdl)
{
  NSString * ns_result = NSComboBoxSelectionDidChangeNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSComboBoxSelectionIsChangingNotification;
static VALUE
osx_NSComboBoxSelectionIsChangingNotification(VALUE mdl)
{
  NSString * ns_result = NSComboBoxSelectionIsChangingNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

void init_NSComboBox(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSComboBoxWillPopUpNotification", osx_NSComboBoxWillPopUpNotification, 0);
  rb_define_module_function(mOSX, "NSComboBoxWillDismissNotification", osx_NSComboBoxWillDismissNotification, 0);
  rb_define_module_function(mOSX, "NSComboBoxSelectionDidChangeNotification", osx_NSComboBoxSelectionDidChangeNotification, 0);
  rb_define_module_function(mOSX, "NSComboBoxSelectionIsChangingNotification", osx_NSComboBoxSelectionIsChangingNotification, 0);
}
