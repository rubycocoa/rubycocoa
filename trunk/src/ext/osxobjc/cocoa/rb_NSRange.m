#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** functions ****/
// NSRange NSUnionRange(NSRange range1, NSRange range2);
static VALUE
osx_NSUnionRange(VALUE mdl, VALUE a0, VALUE a1)
{
  rb_notimplement();
}

// NSRange NSIntersectionRange(NSRange range1, NSRange range2);
static VALUE
osx_NSIntersectionRange(VALUE mdl, VALUE a0, VALUE a1)
{
  rb_notimplement();
}

// NSString *NSStringFromRange(NSRange range);
static VALUE
osx_NSStringFromRange(VALUE mdl, VALUE a0)
{
  rb_notimplement();
}

// NSRange NSRangeFromString(NSString *aString);
static VALUE
osx_NSRangeFromString(VALUE mdl, VALUE a0)
{
  rb_notimplement();
}

void init_NSRange(VALUE mOSX)
{
  /**** functions ****/
  rb_define_module_function(mOSX, "NSUnionRange", osx_NSUnionRange, 2);
  rb_define_module_function(mOSX, "NSIntersectionRange", osx_NSIntersectionRange, 2);
  rb_define_module_function(mOSX, "NSStringFromRange", osx_NSStringFromRange, 1);
  rb_define_module_function(mOSX, "NSRangeFromString", osx_NSRangeFromString, 1);
}
