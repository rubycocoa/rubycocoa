#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <AppKit/AppKit.h>

  /**** constants ****/
// NSString *NSControlTextDidBeginEditingNotification;
static VALUE
osx_NSControlTextDidBeginEditingNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSControlTextDidBeginEditingNotification);
}

// NSString *NSControlTextDidEndEditingNotification;
static VALUE
osx_NSControlTextDidEndEditingNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSControlTextDidEndEditingNotification);
}

// NSString *NSControlTextDidChangeNotification;
static VALUE
osx_NSControlTextDidChangeNotification(VALUE mdl)
{
  return ocobj_new_with_ocid(NSControlTextDidChangeNotification);
}

void init_NSControl(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSControlTextDidBeginEditingNotification", osx_NSControlTextDidBeginEditingNotification, 0);
  rb_define_module_function(mOSX, "NSControlTextDidEndEditingNotification", osx_NSControlTextDidEndEditingNotification, 0);
  rb_define_module_function(mOSX, "NSControlTextDidChangeNotification", osx_NSControlTextDidChangeNotification, 0);
}
