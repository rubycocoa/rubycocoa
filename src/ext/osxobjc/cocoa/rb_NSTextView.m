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
// NSString *NSTextViewWillChangeNotifyingTextViewNotification;
static VALUE
osx_NSTextViewWillChangeNotifyingTextViewNotification(VALUE mdl)
{
  NSString * ns_result = NSTextViewWillChangeNotifyingTextViewNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSTextViewDidChangeSelectionNotification;
static VALUE
osx_NSTextViewDidChangeSelectionNotification(VALUE mdl)
{
  NSString * ns_result = NSTextViewDidChangeSelectionNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
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
