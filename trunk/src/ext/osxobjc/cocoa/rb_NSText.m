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
// NSString *NSTextDidBeginEditingNotification;
static VALUE
osx_NSTextDidBeginEditingNotification(VALUE mdl)
{
  NSString * ns_result = NSTextDidBeginEditingNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSTextDidEndEditingNotification;
static VALUE
osx_NSTextDidEndEditingNotification(VALUE mdl)
{
  NSString * ns_result = NSTextDidEndEditingNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

// NSString *NSTextDidChangeNotification;
static VALUE
osx_NSTextDidChangeNotification(VALUE mdl)
{
  NSString * ns_result = NSTextDidChangeNotification;
  return nsresult_to_rbresult(_C_ID, &ns_result, nil);
}

void init_NSText(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSParagraphSeparatorCharacter", INT2NUM(NSParagraphSeparatorCharacter));
  rb_define_const(mOSX, "NSLineSeparatorCharacter", INT2NUM(NSLineSeparatorCharacter));
  rb_define_const(mOSX, "NSTabCharacter", INT2NUM(NSTabCharacter));
  rb_define_const(mOSX, "NSFormFeedCharacter", INT2NUM(NSFormFeedCharacter));
  rb_define_const(mOSX, "NSNewlineCharacter", INT2NUM(NSNewlineCharacter));
  rb_define_const(mOSX, "NSCarriageReturnCharacter", INT2NUM(NSCarriageReturnCharacter));
  rb_define_const(mOSX, "NSEnterCharacter", INT2NUM(NSEnterCharacter));
  rb_define_const(mOSX, "NSBackspaceCharacter", INT2NUM(NSBackspaceCharacter));
  rb_define_const(mOSX, "NSBackTabCharacter", INT2NUM(NSBackTabCharacter));
  rb_define_const(mOSX, "NSDeleteCharacter", INT2NUM(NSDeleteCharacter));
  rb_define_const(mOSX, "NSLeftTextAlignment", INT2NUM(NSLeftTextAlignment));
  rb_define_const(mOSX, "NSRightTextAlignment", INT2NUM(NSRightTextAlignment));
  rb_define_const(mOSX, "NSCenterTextAlignment", INT2NUM(NSCenterTextAlignment));
  rb_define_const(mOSX, "NSJustifiedTextAlignment", INT2NUM(NSJustifiedTextAlignment));
  rb_define_const(mOSX, "NSNaturalTextAlignment", INT2NUM(NSNaturalTextAlignment));
  rb_define_const(mOSX, "NSIllegalTextMovement", INT2NUM(NSIllegalTextMovement));
  rb_define_const(mOSX, "NSReturnTextMovement", INT2NUM(NSReturnTextMovement));
  rb_define_const(mOSX, "NSTabTextMovement", INT2NUM(NSTabTextMovement));
  rb_define_const(mOSX, "NSBacktabTextMovement", INT2NUM(NSBacktabTextMovement));
  rb_define_const(mOSX, "NSLeftTextMovement", INT2NUM(NSLeftTextMovement));
  rb_define_const(mOSX, "NSRightTextMovement", INT2NUM(NSRightTextMovement));
  rb_define_const(mOSX, "NSUpTextMovement", INT2NUM(NSUpTextMovement));
  rb_define_const(mOSX, "NSDownTextMovement", INT2NUM(NSDownTextMovement));

  /**** constants ****/
  rb_define_module_function(mOSX, "NSTextDidBeginEditingNotification", osx_NSTextDidBeginEditingNotification, 0);
  rb_define_module_function(mOSX, "NSTextDidEndEditingNotification", osx_NSTextDidEndEditingNotification, 0);
  rb_define_module_function(mOSX, "NSTextDidChangeNotification", osx_NSTextDidChangeNotification, 0);
}
