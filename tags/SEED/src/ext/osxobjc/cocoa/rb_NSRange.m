#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <Foundation/Foundation.h>

  /**** functions ****/
// NSRange NSUnionRange(NSRange range1, NSRange range2);
static VALUE
osx_NSUnionRange(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSRange NSIntersectionRange(NSRange range1, NSRange range2);
static VALUE
osx_NSIntersectionRange(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSString *NSStringFromRange(NSRange range);
static VALUE
osx_NSStringFromRange(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSRange NSRangeFromString(NSString *aString);
static VALUE
osx_NSRangeFromString(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

void init_NSRange(VALUE mOSX)
{
  /**** functions ****/
  rb_define_module_function(mOSX, "NSUnionRange", osx_NSUnionRange, -1);
  rb_define_module_function(mOSX, "NSIntersectionRange", osx_NSIntersectionRange, -1);
  rb_define_module_function(mOSX, "NSStringFromRange", osx_NSStringFromRange, -1);
  rb_define_module_function(mOSX, "NSRangeFromString", osx_NSRangeFromString, -1);
}
