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

void init_NSTextView(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSSelectByCharacter", INT2NUM(NSSelectByCharacter));
  rb_define_const(mOSX, "NSSelectByWord", INT2NUM(NSSelectByWord));
  rb_define_const(mOSX, "NSSelectByParagraph", INT2NUM(NSSelectByParagraph));
  rb_define_const(mOSX, "NSSelectionAffinityUpstream", INT2NUM(NSSelectionAffinityUpstream));
  rb_define_const(mOSX, "NSSelectionAffinityDownstream", INT2NUM(NSSelectionAffinityDownstream));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSTextViewWillChangeNotifyingTextViewNotification", osx_NSTextViewWillChangeNotifyingTextViewNotification, 0);
  rb_define_module_function(mOSX, "NSTextViewDidChangeSelectionNotification", osx_NSTextViewDidChangeSelectionNotification, 0);
}
