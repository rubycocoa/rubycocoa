#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <Foundation/Foundation.h>

void init_NSProcessInfo(VALUE mOSX)
{
  /**** enums ****/
  rb_define_const(mOSX, "NSWindowsNTOperatingSystem", INT2NUM(NSWindowsNTOperatingSystem));
  rb_define_const(mOSX, "NSWindows95OperatingSystem", INT2NUM(NSWindows95OperatingSystem));
  rb_define_const(mOSX, "NSSolarisOperatingSystem", INT2NUM(NSSolarisOperatingSystem));
  rb_define_const(mOSX, "NSHPUXOperatingSystem", INT2NUM(NSHPUXOperatingSystem));
  rb_define_const(mOSX, "NSMACHOperatingSystem", INT2NUM(NSMACHOperatingSystem));
  rb_define_const(mOSX, "NSSunOSOperatingSystem", INT2NUM(NSSunOSOperatingSystem));
  rb_define_const(mOSX, "NSOSF1OperatingSystem", INT2NUM(NSOSF1OperatingSystem));

}
