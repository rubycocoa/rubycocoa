#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);


  /**** functions ****/
// NSZone *NSDefaultMallocZone(void);
static VALUE
osx_NSDefaultMallocZone(VALUE mdl)
{
  NSZone * ns_result = NSDefaultMallocZone();
  return nsresult_to_rbresult(_C_PTR, &ns_result, nil);
}

// NSZone *NSCreateZone(unsigned startSize, unsigned granularity, BOOL canFree);
static VALUE
osx_NSCreateZone(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{
  rb_notimplement();
}

// void NSRecycleZone(NSZone *zone);
static VALUE
osx_NSRecycleZone(VALUE mdl, VALUE a0)
{

  NSZone * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);

  NSRecycleZone(ns_a0);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSSetZoneName(NSZone *zone, NSString *name);
static VALUE
osx_NSSetZoneName(VALUE mdl, VALUE a0, VALUE a1)
{

  NSZone * ns_a0;
  NSString * ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_ID, &ns_a1, pool, 1);

  NSSetZoneName(ns_a0, ns_a1);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// NSString *NSZoneName(NSZone *zone);
static VALUE
osx_NSZoneName(VALUE mdl, VALUE a0)
{
  NSString * ns_result;

  NSZone * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);

  ns_result = NSZoneName(ns_a0);

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, pool);
  [pool release];
  return rb_result;
}

// NSZone *NSZoneFromPointer(void *ptr);
static VALUE
osx_NSZoneFromPointer(VALUE mdl, VALUE a0)
{
  NSZone * ns_result;

  void * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);

  ns_result = NSZoneFromPointer(ns_a0);

  rb_result = nsresult_to_rbresult(_C_PTR, &ns_result, pool);
  [pool release];
  return rb_result;
}

// void *NSZoneMalloc(NSZone *zone, unsigned size);
static VALUE
osx_NSZoneMalloc(VALUE mdl, VALUE a0, VALUE a1)
{
  rb_notimplement();
}

// void *NSZoneCalloc(NSZone *zone, unsigned numElems, unsigned byteSize);
static VALUE
osx_NSZoneCalloc(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{
  rb_notimplement();
}

// void *NSZoneRealloc(NSZone *zone, void *ptr, unsigned size);
static VALUE
osx_NSZoneRealloc(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{
  rb_notimplement();
}

// void NSZoneFree(NSZone *zone, void *ptr);
static VALUE
osx_NSZoneFree(VALUE mdl, VALUE a0, VALUE a1)
{

  NSZone * ns_a0;
  void * ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_PTR, &ns_a1, pool, 1);

  NSZoneFree(ns_a0, ns_a1);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// unsigned NSPageSize(void);
static VALUE
osx_NSPageSize(VALUE mdl)
{
  rb_notimplement();
}

// unsigned NSLogPageSize(void);
static VALUE
osx_NSLogPageSize(VALUE mdl)
{
  rb_notimplement();
}

// unsigned NSRoundUpToMultipleOfPageSize(unsigned bytes);
static VALUE
osx_NSRoundUpToMultipleOfPageSize(VALUE mdl, VALUE a0)
{
  rb_notimplement();
}

// unsigned NSRoundDownToMultipleOfPageSize(unsigned bytes);
static VALUE
osx_NSRoundDownToMultipleOfPageSize(VALUE mdl, VALUE a0)
{
  rb_notimplement();
}

// void *NSAllocateMemoryPages(unsigned bytes);
static VALUE
osx_NSAllocateMemoryPages(VALUE mdl, VALUE a0)
{
  rb_notimplement();
}

// void NSDeallocateMemoryPages(void *ptr, unsigned bytes);
static VALUE
osx_NSDeallocateMemoryPages(VALUE mdl, VALUE a0, VALUE a1)
{
  rb_notimplement();
}

// void NSCopyMemoryPages(const void *source, void *dest, unsigned bytes);
static VALUE
osx_NSCopyMemoryPages(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{
  rb_notimplement();
}

// unsigned NSRealMemoryAvailable(void);
static VALUE
osx_NSRealMemoryAvailable(VALUE mdl)
{
  rb_notimplement();
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
