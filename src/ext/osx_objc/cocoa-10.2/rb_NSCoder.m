#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** functions ****/
// NSObject * NXReadNSObjectFromCoder ( NSCoder * decoder );
static VALUE
osx_NXReadNSObjectFromCoder(VALUE mdl, VALUE a0)
{
  NSObject * ns_result;

  NSCoder * ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, "NXReadNSObjectFromCoder", pool, 0);

NS_DURING
  ns_result = NXReadNSObjectFromCoder(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NXReadNSObjectFromCoder", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, "NXReadNSObjectFromCoder", pool);
  [pool release];
  return rb_result;
}

void init_NSCoder(VALUE mOSX)
{
  /**** functions ****/
  rb_define_module_function(mOSX, "NXReadNSObjectFromCoder", osx_NXReadNSObjectFromCoder, 1);
}
