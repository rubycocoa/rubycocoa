#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <Foundation/Foundation.h>

  /**** functions ****/
// NSZone *NSDefaultMallocZone(void);
static VALUE
osx_NSDefaultMallocZone(VALUE mdl)
{
  rb_notimplement();
}

// NSZone *NSCreateZone(unsigned startSize, unsigned granularity, BOOL canFree);
static VALUE
osx_NSCreateZone(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSRecycleZone(NSZone *zone);
static VALUE
osx_NSRecycleZone(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSSetZoneName(NSZone *zone, NSString *name);
static VALUE
osx_NSSetZoneName(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSString *NSZoneName(NSZone *zone);
static VALUE
osx_NSZoneName(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSZone *NSZoneFromPointer(void *ptr);
static VALUE
osx_NSZoneFromPointer(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void *NSZoneMalloc(NSZone *zone, unsigned size);
static VALUE
osx_NSZoneMalloc(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void *NSZoneCalloc(NSZone *zone, unsigned numElems, unsigned byteSize);
static VALUE
osx_NSZoneCalloc(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void *NSZoneRealloc(NSZone *zone, void *ptr, unsigned size);
static VALUE
osx_NSZoneRealloc(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSZoneFree(NSZone *zone, void *ptr);
static VALUE
osx_NSZoneFree(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
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
osx_NSRoundUpToMultipleOfPageSize(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// unsigned NSRoundDownToMultipleOfPageSize(unsigned bytes);
static VALUE
osx_NSRoundDownToMultipleOfPageSize(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void *NSAllocateMemoryPages(unsigned bytes);
static VALUE
osx_NSAllocateMemoryPages(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSDeallocateMemoryPages(void *ptr, unsigned bytes);
static VALUE
osx_NSDeallocateMemoryPages(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSCopyMemoryPages(const void *source, void *dest, unsigned bytes);
static VALUE
osx_NSCopyMemoryPages(int argc, VALUE* argv, VALUE mdl)
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
  rb_define_module_function(mOSX, "NSCreateZone", osx_NSCreateZone, -1);
  rb_define_module_function(mOSX, "NSRecycleZone", osx_NSRecycleZone, -1);
  rb_define_module_function(mOSX, "NSSetZoneName", osx_NSSetZoneName, -1);
  rb_define_module_function(mOSX, "NSZoneName", osx_NSZoneName, -1);
  rb_define_module_function(mOSX, "NSZoneFromPointer", osx_NSZoneFromPointer, -1);
  rb_define_module_function(mOSX, "NSZoneMalloc", osx_NSZoneMalloc, -1);
  rb_define_module_function(mOSX, "NSZoneCalloc", osx_NSZoneCalloc, -1);
  rb_define_module_function(mOSX, "NSZoneRealloc", osx_NSZoneRealloc, -1);
  rb_define_module_function(mOSX, "NSZoneFree", osx_NSZoneFree, -1);
  rb_define_module_function(mOSX, "NSPageSize", osx_NSPageSize, 0);
  rb_define_module_function(mOSX, "NSLogPageSize", osx_NSLogPageSize, 0);
  rb_define_module_function(mOSX, "NSRoundUpToMultipleOfPageSize", osx_NSRoundUpToMultipleOfPageSize, -1);
  rb_define_module_function(mOSX, "NSRoundDownToMultipleOfPageSize", osx_NSRoundDownToMultipleOfPageSize, -1);
  rb_define_module_function(mOSX, "NSAllocateMemoryPages", osx_NSAllocateMemoryPages, -1);
  rb_define_module_function(mOSX, "NSDeallocateMemoryPages", osx_NSDeallocateMemoryPages, -1);
  rb_define_module_function(mOSX, "NSCopyMemoryPages", osx_NSCopyMemoryPages, -1);
  rb_define_module_function(mOSX, "NSRealMemoryAvailable", osx_NSRealMemoryAvailable, 0);
}
