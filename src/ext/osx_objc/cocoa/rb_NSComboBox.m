#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
#define VA_MAX 4


  /**** constants ****/
// NSString *NSComboBoxWillPopUpNotification;
static VALUE
osx_NSComboBoxWillPopUpNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSComboBoxWillPopUpNotification, nil);
}

// NSString *NSComboBoxWillDismissNotification;
static VALUE
osx_NSComboBoxWillDismissNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSComboBoxWillDismissNotification, nil);
}

// NSString *NSComboBoxSelectionDidChangeNotification;
static VALUE
osx_NSComboBoxSelectionDidChangeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSComboBoxSelectionDidChangeNotification, nil);
}

// NSString *NSComboBoxSelectionIsChangingNotification;
static VALUE
osx_NSComboBoxSelectionIsChangingNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSComboBoxSelectionIsChangingNotification, nil);
}

void init_NSComboBox(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSComboBoxWillPopUpNotification", osx_NSComboBoxWillPopUpNotification, 0);
  rb_define_module_function(mOSX, "NSComboBoxWillDismissNotification", osx_NSComboBoxWillDismissNotification, 0);
  rb_define_module_function(mOSX, "NSComboBoxSelectionDidChangeNotification", osx_NSComboBoxSelectionDidChangeNotification, 0);
  rb_define_module_function(mOSX, "NSComboBoxSelectionIsChangingNotification", osx_NSComboBoxSelectionIsChangingNotification, 0);
}
