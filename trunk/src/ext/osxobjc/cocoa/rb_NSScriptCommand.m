#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


void init_NSScriptCommand(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSNoScriptError", INT2NUM(NSNoScriptError));
  rb_define_const(mOSX, "NSReceiverEvaluationScriptError", INT2NUM(NSReceiverEvaluationScriptError));
  rb_define_const(mOSX, "NSKeySpecifierEvaluationScriptError", INT2NUM(NSKeySpecifierEvaluationScriptError));
  rb_define_const(mOSX, "NSArgumentEvaluationScriptError", INT2NUM(NSArgumentEvaluationScriptError));
  rb_define_const(mOSX, "NSReceiversCantHandleCommandScriptError", INT2NUM(NSReceiversCantHandleCommandScriptError));
  rb_define_const(mOSX, "NSRequiredArgumentsMissingScriptError", INT2NUM(NSRequiredArgumentsMissingScriptError));
  rb_define_const(mOSX, "NSArgumentsWrongScriptError", INT2NUM(NSArgumentsWrongScriptError));
  rb_define_const(mOSX, "NSUnknownKeyScriptError", INT2NUM(NSUnknownKeyScriptError));
  rb_define_const(mOSX, "NSInternalScriptError", INT2NUM(NSInternalScriptError));
  rb_define_const(mOSX, "NSOperationNotSupportedForKeyScriptError", INT2NUM(NSOperationNotSupportedForKeyScriptError));
  rb_define_const(mOSX, "NSCannotCreateScriptCommandError", INT2NUM(NSCannotCreateScriptCommandError));

}
