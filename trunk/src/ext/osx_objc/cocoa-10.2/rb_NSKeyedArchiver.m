#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * const NSInvalidArchiveOperationException;
static VALUE
osx_NSInvalidArchiveOperationException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSInvalidArchiveOperationException, nil);
}

// NSString * const NSInvalidUnarchiveOperationException;
static VALUE
osx_NSInvalidUnarchiveOperationException(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSInvalidUnarchiveOperationException, nil);
}

void init_NSKeyedArchiver(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSInvalidArchiveOperationException", osx_NSInvalidArchiveOperationException, 0);
  rb_define_module_function(mOSX, "NSInvalidUnarchiveOperationException", osx_NSInvalidUnarchiveOperationException, 0);
}
