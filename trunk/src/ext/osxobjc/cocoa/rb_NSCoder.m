#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** functions ****/
// NSObject *NXReadNSObjectFromCoder(NSCoder *decoder);
static VALUE
osx_NXReadNSObjectFromCoder(VALUE mdl, VALUE a0)
{
  NSObject * ns_result;

  NSCoder * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, pool, 0);

  ns_result = NXReadNSObjectFromCoder(ns_a0);

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, pool);
  [pool release];
  return rb_result;
}

void init_NSCoder(VALUE mOSX)
{
  /**** functions ****/
  rb_define_module_function(mOSX, "NXReadNSObjectFromCoder", osx_NXReadNSObjectFromCoder, 1);
}
