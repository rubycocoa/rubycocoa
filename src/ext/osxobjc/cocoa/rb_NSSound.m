#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString * const NSSoundPboardType;
static VALUE
osx_NSSoundPboardType(VALUE mdl)
{
  rb_notimplement();
}

void init_NSSound(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSSoundPboardType", osx_NSSoundPboardType, 0);
}
