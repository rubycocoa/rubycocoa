#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString *NSComboBoxWillPopUpNotification;
static VALUE
osx_NSComboBoxWillPopUpNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSComboBoxWillPopUpNotification);
}

// NSString *NSComboBoxWillDismissNotification;
static VALUE
osx_NSComboBoxWillDismissNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSComboBoxWillDismissNotification);
}

// NSString *NSComboBoxSelectionDidChangeNotification;
static VALUE
osx_NSComboBoxSelectionDidChangeNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSComboBoxSelectionDidChangeNotification);
}

// NSString *NSComboBoxSelectionIsChangingNotification;
static VALUE
osx_NSComboBoxSelectionIsChangingNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSComboBoxSelectionIsChangingNotification);
}

void init_NSComboBox(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSComboBoxWillPopUpNotification", osx_NSComboBoxWillPopUpNotification, 0);
  rb_define_module_function(mOSX, "NSComboBoxWillDismissNotification", osx_NSComboBoxWillDismissNotification, 0);
  rb_define_module_function(mOSX, "NSComboBoxSelectionDidChangeNotification", osx_NSComboBoxSelectionDidChangeNotification, 0);
  rb_define_module_function(mOSX, "NSComboBoxSelectionIsChangingNotification", osx_NSComboBoxSelectionIsChangingNotification, 0);
}
