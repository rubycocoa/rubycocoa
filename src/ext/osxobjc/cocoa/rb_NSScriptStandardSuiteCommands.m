#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <Foundation/Foundation.h>

void init_NSScriptStandardSuiteCommands(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSSaveOptionsYes", INT2NUM(NSSaveOptionsYes));
  rb_define_const(mOSX, "NSSaveOptionsNo", INT2NUM(NSSaveOptionsNo));
  rb_define_const(mOSX, "NSSaveOptionsAsk", INT2NUM(NSSaveOptionsAsk));

}
