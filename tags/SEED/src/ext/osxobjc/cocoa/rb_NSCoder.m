#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <Foundation/Foundation.h>

  /**** functions ****/
// NSObject *NXReadNSObjectFromCoder(NSCoder *decoder);
static VALUE
osx_NXReadNSObjectFromCoder(int argc, VALUE* argv, VALUE mdl)
{
  id pool = [[NSAutoreleasePool alloc] init];
  id ns_result;
  VALUE rb_result;
    int i;
  id oc_args[1];
  for (i = 0; i < argc; i++) {
    if (!rbobj_to_nsobj(argv[i], &oc_args[i])) {
      [pool release];
      rb_raise(rb_eArgError, "arg #%d cannot convert to nsobj.", i);
    }
  }

  ns_result =  NXReadNSObjectFromCoder(oc_args[0]);
  rb_result = ocobj_new_with_ocid(ns_result);
  [pool release];
  return rb_result;
}

void init_NSCoder(VALUE mOSX)
{
  /**** functions ****/
  rb_define_module_function(mOSX, "NXReadNSObjectFromCoder", osx_NXReadNSObjectFromCoder, -1);
}
