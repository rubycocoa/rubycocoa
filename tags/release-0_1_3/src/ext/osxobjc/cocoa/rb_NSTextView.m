#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString *NSTextViewWillChangeNotifyingTextViewNotification;
static VALUE
osx_NSTextViewWillChangeNotifyingTextViewNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSTextViewWillChangeNotifyingTextViewNotification, nil);
}

// NSString *NSTextViewDidChangeSelectionNotification;
static VALUE
osx_NSTextViewDidChangeSelectionNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSTextViewDidChangeSelectionNotification, nil);
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
