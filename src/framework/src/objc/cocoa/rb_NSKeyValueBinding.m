#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <AppKit/AppKit.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// id NSMultipleValuesMarker;
static VALUE
osx_NSMultipleValuesMarker(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSMultipleValuesMarker, "NSMultipleValuesMarker", nil);
}

// id NSNoSelectionMarker;
static VALUE
osx_NSNoSelectionMarker(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSNoSelectionMarker, "NSNoSelectionMarker", nil);
}

// id NSNotApplicableMarker;
static VALUE
osx_NSNotApplicableMarker(VALUE mdl)
{
  return nsresult_to_rbresult(_C_ID, &NSNotApplicableMarker, "NSNotApplicableMarker", nil);
}

  /**** functions ****/
// BOOL NSIsControllerMarker ( id object );
static VALUE
osx_NSIsControllerMarker(VALUE mdl, VALUE a0)
{
  BOOL ns_result;

  id ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_ID, &ns_a0, "NSIsControllerMarker", pool, 0);

NS_DURING
  ns_result = NSIsControllerMarker(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSIsControllerMarker", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_PRIV_C_BOOL, &ns_result, "NSIsControllerMarker", pool);
  [pool release];
  return rb_result;
}

void init_NSKeyValueBinding(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSMultipleValuesMarker", osx_NSMultipleValuesMarker, 0);
  rb_define_module_function(mOSX, "NSNoSelectionMarker", osx_NSNoSelectionMarker, 0);
  rb_define_module_function(mOSX, "NSNotApplicableMarker", osx_NSNotApplicableMarker, 0);
  /**** functions ****/
  rb_define_module_function(mOSX, "NSIsControllerMarker", osx_NSIsControllerMarker, 1);
}
