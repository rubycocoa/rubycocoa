#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

static void
rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index)
{
  if (!rbobj_to_ocdata(rbarg, octype, nsarg)) {
    if (pool) [pool release];
    rb_raise(rb_eArgError, "arg #%d cannot convert to nsobj.", index);
  }
}

static VALUE
nsresult_to_rbresult(int octype, const void* nsresult, id pool)
{
  VALUE rbresult;
  if (octype == _C_ID) {
    rbresult = ocobj_new_with_ocid(*(id*)nsresult);
  }
  else {
    if (!ocdata_to_rbobj(octype, nsresult, &rbresult)) {
      if (pool) [pool release];
      rb_raise(rb_eRuntimeError, "result cannot convert to rbobj.");
    }
  }
  return rbresult;
}


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
