#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <Foundation/Foundation.h>

  /**** constants ****/
// const NSHashTableCallBacks NSIntHashCallBacks;
static VALUE
osx_NSIntHashCallBacks(VALUE mdl)
{
  rb_notimplement();
}

// const NSHashTableCallBacks NSNonOwnedPointerHashCallBacks;
static VALUE
osx_NSNonOwnedPointerHashCallBacks(VALUE mdl)
{
  rb_notimplement();
}

// const NSHashTableCallBacks NSNonRetainedObjectHashCallBacks;
static VALUE
osx_NSNonRetainedObjectHashCallBacks(VALUE mdl)
{
  rb_notimplement();
}

// const NSHashTableCallBacks NSObjectHashCallBacks;
static VALUE
osx_NSObjectHashCallBacks(VALUE mdl)
{
  rb_notimplement();
}

// const NSHashTableCallBacks NSOwnedObjectIdentityHashCallBacks;
static VALUE
osx_NSOwnedObjectIdentityHashCallBacks(VALUE mdl)
{
  rb_notimplement();
}

// const NSHashTableCallBacks NSOwnedPointerHashCallBacks;
static VALUE
osx_NSOwnedPointerHashCallBacks(VALUE mdl)
{
  rb_notimplement();
}

// const NSHashTableCallBacks NSPointerToStructHashCallBacks;
static VALUE
osx_NSPointerToStructHashCallBacks(VALUE mdl)
{
  rb_notimplement();
}

  /**** functions ****/
// NSHashTable *NSCreateHashTableWithZone(NSHashTableCallBacks callBacks, unsigned capacity, NSZone *zone);
static VALUE
osx_NSCreateHashTableWithZone(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSHashTable *NSCreateHashTable(NSHashTableCallBacks callBacks, unsigned capacity);
static VALUE
osx_NSCreateHashTable(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSFreeHashTable(NSHashTable *table);
static VALUE
osx_NSFreeHashTable(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSResetHashTable(NSHashTable *table);
static VALUE
osx_NSResetHashTable(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// BOOL NSCompareHashTables(NSHashTable *table1, NSHashTable *table2);
static VALUE
osx_NSCompareHashTables(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSHashTable *NSCopyHashTableWithZone(NSHashTable *table, NSZone *zone);
static VALUE
osx_NSCopyHashTableWithZone(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void *NSHashGet(NSHashTable *table, const void *pointer);
static VALUE
osx_NSHashGet(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSHashInsert(NSHashTable *table, const void *pointer);
static VALUE
osx_NSHashInsert(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSHashInsertKnownAbsent(NSHashTable *table, const void *pointer);
static VALUE
osx_NSHashInsertKnownAbsent(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void *NSHashInsertIfAbsent(NSHashTable *table, const void *pointer);
static VALUE
osx_NSHashInsertIfAbsent(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSHashRemove(NSHashTable *table, const void *pointer);
static VALUE
osx_NSHashRemove(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSHashEnumerator NSEnumerateHashTable(NSHashTable *table);
static VALUE
osx_NSEnumerateHashTable(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void *NSNextHashEnumeratorItem(NSHashEnumerator *enumerator);
static VALUE
osx_NSNextHashEnumeratorItem(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSEndHashTableEnumeration(NSHashEnumerator *enumerator);
static VALUE
osx_NSEndHashTableEnumeration(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// unsigned NSCountHashTable(NSHashTable *table);
static VALUE
osx_NSCountHashTable(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSString *NSStringFromHashTable(NSHashTable *table);
static VALUE
osx_NSStringFromHashTable(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSArray *NSAllHashTableObjects(NSHashTable *table);
static VALUE
osx_NSAllHashTableObjects(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

void init_NSHashTable(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSIntHashCallBacks", osx_NSIntHashCallBacks, 0);
  rb_define_module_function(mOSX, "NSNonOwnedPointerHashCallBacks", osx_NSNonOwnedPointerHashCallBacks, 0);
  rb_define_module_function(mOSX, "NSNonRetainedObjectHashCallBacks", osx_NSNonRetainedObjectHashCallBacks, 0);
  rb_define_module_function(mOSX, "NSObjectHashCallBacks", osx_NSObjectHashCallBacks, 0);
  rb_define_module_function(mOSX, "NSOwnedObjectIdentityHashCallBacks", osx_NSOwnedObjectIdentityHashCallBacks, 0);
  rb_define_module_function(mOSX, "NSOwnedPointerHashCallBacks", osx_NSOwnedPointerHashCallBacks, 0);
  rb_define_module_function(mOSX, "NSPointerToStructHashCallBacks", osx_NSPointerToStructHashCallBacks, 0);
  /**** functions ****/
  rb_define_module_function(mOSX, "NSCreateHashTableWithZone", osx_NSCreateHashTableWithZone, -1);
  rb_define_module_function(mOSX, "NSCreateHashTable", osx_NSCreateHashTable, -1);
  rb_define_module_function(mOSX, "NSFreeHashTable", osx_NSFreeHashTable, -1);
  rb_define_module_function(mOSX, "NSResetHashTable", osx_NSResetHashTable, -1);
  rb_define_module_function(mOSX, "NSCompareHashTables", osx_NSCompareHashTables, -1);
  rb_define_module_function(mOSX, "NSCopyHashTableWithZone", osx_NSCopyHashTableWithZone, -1);
  rb_define_module_function(mOSX, "NSHashGet", osx_NSHashGet, -1);
  rb_define_module_function(mOSX, "NSHashInsert", osx_NSHashInsert, -1);
  rb_define_module_function(mOSX, "NSHashInsertKnownAbsent", osx_NSHashInsertKnownAbsent, -1);
  rb_define_module_function(mOSX, "NSHashInsertIfAbsent", osx_NSHashInsertIfAbsent, -1);
  rb_define_module_function(mOSX, "NSHashRemove", osx_NSHashRemove, -1);
  rb_define_module_function(mOSX, "NSEnumerateHashTable", osx_NSEnumerateHashTable, -1);
  rb_define_module_function(mOSX, "NSNextHashEnumeratorItem", osx_NSNextHashEnumeratorItem, -1);
  rb_define_module_function(mOSX, "NSEndHashTableEnumeration", osx_NSEndHashTableEnumeration, -1);
  rb_define_module_function(mOSX, "NSCountHashTable", osx_NSCountHashTable, -1);
  rb_define_module_function(mOSX, "NSStringFromHashTable", osx_NSStringFromHashTable, -1);
  rb_define_module_function(mOSX, "NSAllHashTableObjects", osx_NSAllHashTableObjects, -1);
}
