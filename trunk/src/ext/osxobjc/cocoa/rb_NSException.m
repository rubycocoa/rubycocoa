#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


  /**** constants ****/
// NSString * __const NSGenericException;
static VALUE
osx_NSGenericException(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSRangeException;
static VALUE
osx_NSRangeException(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSInvalidArgumentException;
static VALUE
osx_NSInvalidArgumentException(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSInternalInconsistencyException;
static VALUE
osx_NSInternalInconsistencyException(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSMallocException;
static VALUE
osx_NSMallocException(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSObjectInaccessibleException;
static VALUE
osx_NSObjectInaccessibleException(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSObjectNotAvailableException;
static VALUE
osx_NSObjectNotAvailableException(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSDestinationInvalidException;
static VALUE
osx_NSDestinationInvalidException(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSPortTimeoutException;
static VALUE
osx_NSPortTimeoutException(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSInvalidSendPortException;
static VALUE
osx_NSInvalidSendPortException(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSInvalidReceivePortException;
static VALUE
osx_NSInvalidReceivePortException(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSPortSendException;
static VALUE
osx_NSPortSendException(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSPortReceiveException;
static VALUE
osx_NSPortReceiveException(VALUE mdl)
{
  rb_notimplement();
}

// NSString * __const NSOldStyleException;
static VALUE
osx_NSOldStyleException(VALUE mdl)
{
  rb_notimplement();
}

  /**** functions ****/
// void _NSAddHandler2(NSHandler2 *handler);
static VALUE
osx__NSAddHandler2(VALUE mdl, VALUE a0)
{

  NSHandler2 * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);

  _NSAddHandler2(ns_a0);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void _NSRemoveHandler2(NSHandler2 *handler);
static VALUE
osx__NSRemoveHandler2(VALUE mdl, VALUE a0)
{

  NSHandler2 * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);

  _NSRemoveHandler2(ns_a0);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// NSException *_NSExceptionObjectFromHandler2(NSHandler2 *handler);
static VALUE
osx__NSExceptionObjectFromHandler2(VALUE mdl, VALUE a0)
{
  NSException * ns_result;

  NSHandler2 * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);

  ns_result = _NSExceptionObjectFromHandler2(ns_a0);

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, pool);
  [pool release];
  return rb_result;
}

// NSUncaughtExceptionHandler *NSGetUncaughtExceptionHandler(void);
static VALUE
osx_NSGetUncaughtExceptionHandler(VALUE mdl)
{
  NSUncaughtExceptionHandler * ns_result = NSGetUncaughtExceptionHandler();
  return nsresult_to_rbresult(_C_PTR, &ns_result, nil);
}

// void NSSetUncaughtExceptionHandler(NSUncaughtExceptionHandler *);
static VALUE
osx_NSSetUncaughtExceptionHandler(VALUE mdl, VALUE a0)
{

  NSUncaughtExceptionHandler * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);

  NSSetUncaughtExceptionHandler(ns_a0);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

void init_NSException(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSGenericException", osx_NSGenericException, 0);
  rb_define_module_function(mOSX, "NSRangeException", osx_NSRangeException, 0);
  rb_define_module_function(mOSX, "NSInvalidArgumentException", osx_NSInvalidArgumentException, 0);
  rb_define_module_function(mOSX, "NSInternalInconsistencyException", osx_NSInternalInconsistencyException, 0);
  rb_define_module_function(mOSX, "NSMallocException", osx_NSMallocException, 0);
  rb_define_module_function(mOSX, "NSObjectInaccessibleException", osx_NSObjectInaccessibleException, 0);
  rb_define_module_function(mOSX, "NSObjectNotAvailableException", osx_NSObjectNotAvailableException, 0);
  rb_define_module_function(mOSX, "NSDestinationInvalidException", osx_NSDestinationInvalidException, 0);
  rb_define_module_function(mOSX, "NSPortTimeoutException", osx_NSPortTimeoutException, 0);
  rb_define_module_function(mOSX, "NSInvalidSendPortException", osx_NSInvalidSendPortException, 0);
  rb_define_module_function(mOSX, "NSInvalidReceivePortException", osx_NSInvalidReceivePortException, 0);
  rb_define_module_function(mOSX, "NSPortSendException", osx_NSPortSendException, 0);
  rb_define_module_function(mOSX, "NSPortReceiveException", osx_NSPortReceiveException, 0);
  rb_define_module_function(mOSX, "NSOldStyleException", osx_NSOldStyleException, 0);
  /**** functions ****/
  rb_define_module_function(mOSX, "_NSAddHandler2", osx__NSAddHandler2, 1);
  rb_define_module_function(mOSX, "_NSRemoveHandler2", osx__NSRemoveHandler2, 1);
  rb_define_module_function(mOSX, "_NSExceptionObjectFromHandler2", osx__NSExceptionObjectFromHandler2, 1);
  rb_define_module_function(mOSX, "NSGetUncaughtExceptionHandler", osx_NSGetUncaughtExceptionHandler, 0);
  rb_define_module_function(mOSX, "NSSetUncaughtExceptionHandler", osx_NSSetUncaughtExceptionHandler, 1);
}
