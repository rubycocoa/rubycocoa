#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>
#import <AppKit/AppKit.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString *NSTextDidBeginEditingNotification;
static VALUE
osx_NSTextDidBeginEditingNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSTextDidBeginEditingNotification, nil);
}

// NSString *NSTextDidEndEditingNotification;
static VALUE
osx_NSTextDidEndEditingNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSTextDidEndEditingNotification, nil);
}

// NSString *NSTextDidChangeNotification;
static VALUE
osx_NSTextDidChangeNotification(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSTextDidChangeNotification, nil);
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
