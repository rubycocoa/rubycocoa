#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


  /**** functions ****/
// NSZone * NSDefaultMallocZone ( void );
static VALUE
osx_NSDefaultMallocZone(VALUE mdl)
{
  NSZone * ns_result = NSDefaultMallocZone();
  return nsresult_to_rbresult(_PRIV_C_PTR, &ns_result, "NSDefaultMallocZone", nil);
}

// NSZone * NSCreateZone ( unsigned startSize , unsigned granularity , BOOL canFree );
static VALUE
osx_NSCreateZone(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{
  NSZone * ns_result;

  unsigned ns_a0;
  unsigned ns_a1;
  BOOL ns_a2;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_UINT, &ns_a0, "NSCreateZone", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_UINT, &ns_a1, "NSCreateZone", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_UCHR, &ns_a2, "NSCreateZone", pool, 2);

NS_DURING
  ns_result = NSCreateZone(ns_a0, ns_a1, ns_a2);
NS_HANDLER
  excp = oc_err_new ("NSCreateZone", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_PRIV_C_PTR, &ns_result, "NSCreateZone", pool);
  [pool release];
  return rb_result;
}

// void NSRecycleZone ( NSZone * zone );
static VALUE
osx_NSRecycleZone(VALUE mdl, VALUE a0)
{

  NSZone * ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSRecycleZone", pool, 0);

NS_DURING
  NSRecycleZone(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSRecycleZone", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSSetZoneName ( NSZone * zone , NSString * name );
static VALUE
osx_NSSetZoneName(VALUE mdl, VALUE a0, VALUE a1)
{

  NSZone * ns_a0;
  NSString * ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSSetZoneName", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_ID, &ns_a1, "NSSetZoneName", pool, 1);

NS_DURING
  NSSetZoneName(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSSetZoneName", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// NSString * NSZoneName ( NSZone * zone );
static VALUE
osx_NSZoneName(VALUE mdl, VALUE a0)
{
  NSString * ns_result;

  NSZone * ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSZoneName", pool, 0);

NS_DURING
  ns_result = NSZoneName(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSZoneName", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, "NSZoneName", pool);
  [pool release];
  return rb_result;
}

// NSZone * NSZoneFromPointer ( void * ptr );
static VALUE
osx_NSZoneFromPointer(VALUE mdl, VALUE a0)
{
  NSZone * ns_result;

  void * ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSZoneFromPointer", pool, 0);

NS_DURING
  ns_result = NSZoneFromPointer(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSZoneFromPointer", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_PRIV_C_PTR, &ns_result, "NSZoneFromPointer", pool);
  [pool release];
  return rb_result;
}

// void * NSZoneMalloc ( NSZone * zone , unsigned size );
static VALUE
osx_NSZoneMalloc(VALUE mdl, VALUE a0, VALUE a1)
{
  void * ns_result;

  NSZone * ns_a0;
  unsigned ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSZoneMalloc", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_UINT, &ns_a1, "NSZoneMalloc", pool, 1);

NS_DURING
  ns_result = NSZoneMalloc(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSZoneMalloc", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_PRIV_C_PTR, &ns_result, "NSZoneMalloc", pool);
  [pool release];
  return rb_result;
}

// void * NSZoneCalloc ( NSZone * zone , unsigned numElems , unsigned byteSize );
static VALUE
osx_NSZoneCalloc(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{
  void * ns_result;

  NSZone * ns_a0;
  unsigned ns_a1;
  unsigned ns_a2;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSZoneCalloc", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_UINT, &ns_a1, "NSZoneCalloc", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_UINT, &ns_a2, "NSZoneCalloc", pool, 2);

NS_DURING
  ns_result = NSZoneCalloc(ns_a0, ns_a1, ns_a2);
NS_HANDLER
  excp = oc_err_new ("NSZoneCalloc", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_PRIV_C_PTR, &ns_result, "NSZoneCalloc", pool);
  [pool release];
  return rb_result;
}

// void * NSZoneRealloc ( NSZone * zone , void * ptr , unsigned size );
static VALUE
osx_NSZoneRealloc(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{
  void * ns_result;

  NSZone * ns_a0;
  void * ns_a1;
  unsigned ns_a2;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSZoneRealloc", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSZoneRealloc", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_UINT, &ns_a2, "NSZoneRealloc", pool, 2);

NS_DURING
  ns_result = NSZoneRealloc(ns_a0, ns_a1, ns_a2);
NS_HANDLER
  excp = oc_err_new ("NSZoneRealloc", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_PRIV_C_PTR, &ns_result, "NSZoneRealloc", pool);
  [pool release];
  return rb_result;
}

// void NSZoneFree ( NSZone * zone , void * ptr );
static VALUE
osx_NSZoneFree(VALUE mdl, VALUE a0, VALUE a1)
{

  NSZone * ns_a0;
  void * ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSZoneFree", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSZoneFree", pool, 1);

NS_DURING
  NSZoneFree(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSZoneFree", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// unsigned NSPageSize ( void );
static VALUE
osx_NSPageSize(VALUE mdl)
{
  unsigned ns_result = NSPageSize();
  return nsresult_to_rbresult(_C_UINT, &ns_result, "NSPageSize", nil);
}

// unsigned NSLogPageSize ( void );
static VALUE
osx_NSLogPageSize(VALUE mdl)
{
  unsigned ns_result = NSLogPageSize();
  return nsresult_to_rbresult(_C_UINT, &ns_result, "NSLogPageSize", nil);
}

// unsigned NSRoundUpToMultipleOfPageSize ( unsigned bytes );
static VALUE
osx_NSRoundUpToMultipleOfPageSize(VALUE mdl, VALUE a0)
{
  unsigned ns_result;

  unsigned ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_UINT, &ns_a0, "NSRoundUpToMultipleOfPageSize", pool, 0);

NS_DURING
  ns_result = NSRoundUpToMultipleOfPageSize(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSRoundUpToMultipleOfPageSize", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_UINT, &ns_result, "NSRoundUpToMultipleOfPageSize", pool);
  [pool release];
  return rb_result;
}

// unsigned NSRoundDownToMultipleOfPageSize ( unsigned bytes );
static VALUE
osx_NSRoundDownToMultipleOfPageSize(VALUE mdl, VALUE a0)
{
  unsigned ns_result;

  unsigned ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_UINT, &ns_a0, "NSRoundDownToMultipleOfPageSize", pool, 0);

NS_DURING
  ns_result = NSRoundDownToMultipleOfPageSize(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSRoundDownToMultipleOfPageSize", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_UINT, &ns_result, "NSRoundDownToMultipleOfPageSize", pool);
  [pool release];
  return rb_result;
}

// void * NSAllocateMemoryPages ( unsigned bytes );
static VALUE
osx_NSAllocateMemoryPages(VALUE mdl, VALUE a0)
{
  void * ns_result;

  unsigned ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_UINT, &ns_a0, "NSAllocateMemoryPages", pool, 0);

NS_DURING
  ns_result = NSAllocateMemoryPages(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSAllocateMemoryPages", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_PRIV_C_PTR, &ns_result, "NSAllocateMemoryPages", pool);
  [pool release];
  return rb_result;
}

// void NSDeallocateMemoryPages ( void * ptr , unsigned bytes );
static VALUE
osx_NSDeallocateMemoryPages(VALUE mdl, VALUE a0, VALUE a1)
{

  void * ns_a0;
  unsigned ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSDeallocateMemoryPages", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_UINT, &ns_a1, "NSDeallocateMemoryPages", pool, 1);

NS_DURING
  NSDeallocateMemoryPages(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSDeallocateMemoryPages", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSCopyMemoryPages ( const void * source , void * dest , unsigned bytes );
static VALUE
osx_NSCopyMemoryPages(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{

  const void * ns_a0;
  void * ns_a1;
  unsigned ns_a2;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSCopyMemoryPages", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSCopyMemoryPages", pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_UINT, &ns_a2, "NSCopyMemoryPages", pool, 2);

NS_DURING
  NSCopyMemoryPages(ns_a0, ns_a1, ns_a2);
NS_HANDLER
  excp = oc_err_new ("NSCopyMemoryPages", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// unsigned NSRealMemoryAvailable ( void );
static VALUE
osx_NSRealMemoryAvailable(VALUE mdl)
{
  unsigned ns_result = NSRealMemoryAvailable();
  return nsresult_to_rbresult(_C_UINT, &ns_result, "NSRealMemoryAvailable", nil);
}

void init_NSZone(VALUE mOSX)
{
  /**** functions ****/
  rb_define_module_function(mOSX, "NSDefaultMallocZone", osx_NSDefaultMallocZone, 0);
  rb_define_module_function(mOSX, "NSCreateZone", osx_NSCreateZone, 3);
  rb_define_module_function(mOSX, "NSRecycleZone", osx_NSRecycleZone, 1);
  rb_define_module_function(mOSX, "NSSetZoneName", osx_NSSetZoneName, 2);
  rb_define_module_function(mOSX, "NSZoneName", osx_NSZoneName, 1);
  rb_define_module_function(mOSX, "NSZoneFromPointer", osx_NSZoneFromPointer, 1);
  rb_define_module_function(mOSX, "NSZoneMalloc", osx_NSZoneMalloc, 2);
  rb_define_module_function(mOSX, "NSZoneCalloc", osx_NSZoneCalloc, 3);
  rb_define_module_function(mOSX, "NSZoneRealloc", osx_NSZoneRealloc, 3);
  rb_define_module_function(mOSX, "NSZoneFree", osx_NSZoneFree, 2);
  rb_define_module_function(mOSX, "NSPageSize", osx_NSPageSize, 0);
  rb_define_module_function(mOSX, "NSLogPageSize", osx_NSLogPageSize, 0);
  rb_define_module_function(mOSX, "NSRoundUpToMultipleOfPageSize", osx_NSRoundUpToMultipleOfPageSize, 1);
  rb_define_module_function(mOSX, "NSRoundDownToMultipleOfPageSize", osx_NSRoundDownToMultipleOfPageSize, 1);
  rb_define_module_function(mOSX, "NSAllocateMemoryPages", osx_NSAllocateMemoryPages, 1);
  rb_define_module_function(mOSX, "NSDeallocateMemoryPages", osx_NSDeallocateMemoryPages, 2);
  rb_define_module_function(mOSX, "NSCopyMemoryPages", osx_NSCopyMemoryPages, 3);
  rb_define_module_function(mOSX, "NSRealMemoryAvailable", osx_NSRealMemoryAvailable, 0);
}
