#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString *NSTextViewWillChangeNotifyingTextViewNotification;
static VALUE
osx_NSTextViewWillChangeNotifyingTextViewNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSTextViewWillChangeNotifyingTextViewNotification);
}

// NSString *NSTextViewDidChangeSelectionNotification;
static VALUE
osx_NSTextViewDidChangeSelectionNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSTextViewDidChangeSelectionNotification);
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
