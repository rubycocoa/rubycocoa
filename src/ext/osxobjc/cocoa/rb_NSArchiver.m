#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <Foundation/Foundation.h>

  /**** constants ****/
// NSString * const NSInconsistentArchiveException;
static VALUE
osx_NSInconsistentArchiveException(VALUE mdl)
{
  rb_notimplement();
}

void init_NSArchiver(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSInconsistentArchiveException", osx_NSInconsistentArchiveException, 0);
}
