#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * NSTextViewWillChangeNotifyingTextViewNotification;
static VALUE
osx_NSTextViewWillChangeNotifyingTextViewNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSTextViewWillChangeNotifyingTextViewNotification, "NSTextViewWillChangeNotifyingTextViewNotification", nil);
}

// NSString * NSTextViewDidChangeSelectionNotification;
static VALUE
osx_NSTextViewDidChangeSelectionNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSTextViewDidChangeSelectionNotification, "NSTextViewDidChangeSelectionNotification", nil);
}

// NSString * NSTextViewDidChangeTypingAttributesNotification;
static VALUE
osx_NSTextViewDidChangeTypingAttributesNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSTextViewDidChangeTypingAttributesNotification, "NSTextViewDidChangeTypingAttributesNotification", nil);
}

void init_NSTextView(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSSelectByCharacter", INT2NUM(NSSelectByCharacter));
  rb_define_const(mOSX, "NSSelectByWord", INT2NUM(NSSelectByWord));
  rb_define_const(mOSX, "NSSelectByParagraph", INT2NUM(NSSelectByParagraph));
  rb_define_const(mOSX, "NSSelectionAffinityUpstream", INT2NUM(NSSelectionAffinityUpstream));
  rb_define_const(mOSX, "NSSelectionAffinityDownstream", INT2NUM(NSSelectionAffinityDownstream));
  rb_define_const(mOSX, "NSFindPanelActionShowFindPanel", INT2NUM(NSFindPanelActionShowFindPanel));
  rb_define_const(mOSX, "NSFindPanelActionNext", INT2NUM(NSFindPanelActionNext));
  rb_define_const(mOSX, "NSFindPanelActionPrevious", INT2NUM(NSFindPanelActionPrevious));
  rb_define_const(mOSX, "NSFindPanelActionReplaceAll", INT2NUM(NSFindPanelActionReplaceAll));
  rb_define_const(mOSX, "NSFindPanelActionReplace", INT2NUM(NSFindPanelActionReplace));
  rb_define_const(mOSX, "NSFindPanelActionReplaceAndFind", INT2NUM(NSFindPanelActionReplaceAndFind));
  rb_define_const(mOSX, "NSFindPanelActionSetFindString", INT2NUM(NSFindPanelActionSetFindString));
  rb_define_const(mOSX, "NSFindPanelActionReplaceAllInSelection", INT2NUM(NSFindPanelActionReplaceAllInSelection));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSTextViewWillChangeNotifyingTextViewNotification", osx_NSTextViewWillChangeNotifyingTextViewNotification, 0);
  rb_define_module_function(mOSX, "NSTextViewDidChangeSelectionNotification", osx_NSTextViewDidChangeSelectionNotification, 0);
  rb_define_module_function(mOSX, "NSTextViewDidChangeTypingAttributesNotification", osx_NSTextViewDidChangeTypingAttributesNotification, 0);
}
