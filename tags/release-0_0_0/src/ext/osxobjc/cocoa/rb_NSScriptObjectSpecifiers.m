#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <Foundation/Foundation.h>

void init_NSScriptObjectSpecifiers(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSNoSpecifierError", INT2NUM(NSNoSpecifierError));
  rb_define_const(mOSX, "NSNoTopLevelContainersSpecifierError", INT2NUM(NSNoTopLevelContainersSpecifierError));
  rb_define_const(mOSX, "NSContainerSpecifierError", INT2NUM(NSContainerSpecifierError));
  rb_define_const(mOSX, "NSUnknownKeySpecifierError", INT2NUM(NSUnknownKeySpecifierError));
  rb_define_const(mOSX, "NSInvalidIndexSpecifierError", INT2NUM(NSInvalidIndexSpecifierError));
  rb_define_const(mOSX, "NSInternalSpecifierError", INT2NUM(NSInternalSpecifierError));
  rb_define_const(mOSX, "NSOperationNotSupportedForKeySpecifierError", INT2NUM(NSOperationNotSupportedForKeySpecifierError));
  rb_define_const(mOSX, "NSPositionAfter", INT2NUM(NSPositionAfter));
  rb_define_const(mOSX, "NSPositionBefore", INT2NUM(NSPositionBefore));
  rb_define_const(mOSX, "NSPositionBeginning", INT2NUM(NSPositionBeginning));
  rb_define_const(mOSX, "NSPositionEnd", INT2NUM(NSPositionEnd));
  rb_define_const(mOSX, "NSPositionReplace", INT2NUM(NSPositionReplace));
  rb_define_const(mOSX, "NSRelativeAfter", INT2NUM(NSRelativeAfter));
  rb_define_const(mOSX, "NSRelativeBefore", INT2NUM(NSRelativeBefore));
  rb_define_const(mOSX, "NSIndexSubelement", INT2NUM(NSIndexSubelement));
  rb_define_const(mOSX, "NSEverySubelement", INT2NUM(NSEverySubelement));
  rb_define_const(mOSX, "NSMiddleSubelement", INT2NUM(NSMiddleSubelement));
  rb_define_const(mOSX, "NSRandomSubelement", INT2NUM(NSRandomSubelement));
  rb_define_const(mOSX, "NSNoSubelement", INT2NUM(NSNoSubelement));

}
