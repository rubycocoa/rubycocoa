#import <LibRuby/cocoa_ruby.h>
#import "../framework/ocdata_conv.h"
#import <Foundation/Foundation.h>

  /**** constants ****/
// const NSMapTableKeyCallBacks NSIntMapKeyCallBacks;
static VALUE
osx_NSIntMapKeyCallBacks(VALUE mdl)
{
  rb_notimplement();
}

// const NSMapTableKeyCallBacks NSNonOwnedPointerMapKeyCallBacks;
static VALUE
osx_NSNonOwnedPointerMapKeyCallBacks(VALUE mdl)
{
  rb_notimplement();
}

// const NSMapTableKeyCallBacks NSNonOwnedPointerOrNullMapKeyCallBacks;
static VALUE
osx_NSNonOwnedPointerOrNullMapKeyCallBacks(VALUE mdl)
{
  rb_notimplement();
}

// const NSMapTableKeyCallBacks NSNonRetainedObjectMapKeyCallBacks;
static VALUE
osx_NSNonRetainedObjectMapKeyCallBacks(VALUE mdl)
{
  rb_notimplement();
}

// const NSMapTableKeyCallBacks NSObjectMapKeyCallBacks;
static VALUE
osx_NSObjectMapKeyCallBacks(VALUE mdl)
{
  rb_notimplement();
}

// const NSMapTableKeyCallBacks NSOwnedPointerMapKeyCallBacks;
static VALUE
osx_NSOwnedPointerMapKeyCallBacks(VALUE mdl)
{
  rb_notimplement();
}

// const NSMapTableValueCallBacks NSIntMapValueCallBacks;
static VALUE
osx_NSIntMapValueCallBacks(VALUE mdl)
{
  rb_notimplement();
}

// const NSMapTableValueCallBacks NSNonOwnedPointerMapValueCallBacks;
static VALUE
osx_NSNonOwnedPointerMapValueCallBacks(VALUE mdl)
{
  rb_notimplement();
}

// const NSMapTableValueCallBacks NSObjectMapValueCallBacks;
static VALUE
osx_NSObjectMapValueCallBacks(VALUE mdl)
{
  rb_notimplement();
}

// const NSMapTableValueCallBacks NSNonRetainedObjectMapValueCallBacks;
static VALUE
osx_NSNonRetainedObjectMapValueCallBacks(VALUE mdl)
{
  rb_notimplement();
}

// const NSMapTableValueCallBacks NSOwnedPointerMapValueCallBacks;
static VALUE
osx_NSOwnedPointerMapValueCallBacks(VALUE mdl)
{
  rb_notimplement();
}

  /**** functions ****/
// NSMapTable *NSCreateMapTableWithZone(NSMapTableKeyCallBacks keyCallBacks, NSMapTableValueCallBacks valueCallBacks, unsigned capacity, NSZone *zone);
static VALUE
osx_NSCreateMapTableWithZone(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSMapTable *NSCreateMapTable(NSMapTableKeyCallBacks keyCallBacks, NSMapTableValueCallBacks valueCallBacks, unsigned capacity);
static VALUE
osx_NSCreateMapTable(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSFreeMapTable(NSMapTable *table);
static VALUE
osx_NSFreeMapTable(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSResetMapTable(NSMapTable *table);
static VALUE
osx_NSResetMapTable(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// BOOL NSCompareMapTables(NSMapTable *table1, NSMapTable *table2);
static VALUE
osx_NSCompareMapTables(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSMapTable *NSCopyMapTableWithZone(NSMapTable *table, NSZone *zone);
static VALUE
osx_NSCopyMapTableWithZone(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// BOOL NSMapMember(NSMapTable *table, const void *key, void **originalKey, void **value);
static VALUE
osx_NSMapMember(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void *NSMapGet(NSMapTable *table, const void *key);
static VALUE
osx_NSMapGet(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSMapInsert(NSMapTable *table, const void *key, const void *value);
static VALUE
osx_NSMapInsert(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSMapInsertKnownAbsent(NSMapTable *table, const void *key, const void *value);
static VALUE
osx_NSMapInsertKnownAbsent(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void *NSMapInsertIfAbsent(NSMapTable *table, const void *key, const void *value);
static VALUE
osx_NSMapInsertIfAbsent(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSMapRemove(NSMapTable *table, const void *key);
static VALUE
osx_NSMapRemove(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSMapEnumerator NSEnumerateMapTable(NSMapTable *table);
static VALUE
osx_NSEnumerateMapTable(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// BOOL NSNextMapEnumeratorPair(NSMapEnumerator *enumerator, void **key, void **value);
static VALUE
osx_NSNextMapEnumeratorPair(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// void NSEndMapTableEnumeration(NSMapEnumerator *enumerator);
static VALUE
osx_NSEndMapTableEnumeration(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// unsigned NSCountMapTable(NSMapTable *table);
static VALUE
osx_NSCountMapTable(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSString *NSStringFromMapTable(NSMapTable *table);
static VALUE
osx_NSStringFromMapTable(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSArray *NSAllMapTableKeys(NSMapTable *table);
static VALUE
osx_NSAllMapTableKeys(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

// NSArray *NSAllMapTableValues(NSMapTable *table);
static VALUE
osx_NSAllMapTableValues(int argc, VALUE* argv, VALUE mdl)
{
  rb_notimplement();
}

void init_NSMapTable(VALUE mOSX)
{
  /**** constants ****/
  rb_define_module_function(mOSX, "NSIntMapKeyCallBacks", osx_NSIntMapKeyCallBacks, 0);
  rb_define_module_function(mOSX, "NSNonOwnedPointerMapKeyCallBacks", osx_NSNonOwnedPointerMapKeyCallBacks, 0);
  rb_define_module_function(mOSX, "NSNonOwnedPointerOrNullMapKeyCallBacks", osx_NSNonOwnedPointerOrNullMapKeyCallBacks, 0);
  rb_define_module_function(mOSX, "NSNonRetainedObjectMapKeyCallBacks", osx_NSNonRetainedObjectMapKeyCallBacks, 0);
  rb_define_module_function(mOSX, "NSObjectMapKeyCallBacks", osx_NSObjectMapKeyCallBacks, 0);
  rb_define_module_function(mOSX, "NSOwnedPointerMapKeyCallBacks", osx_NSOwnedPointerMapKeyCallBacks, 0);
  rb_define_module_function(mOSX, "NSIntMapValueCallBacks", osx_NSIntMapValueCallBacks, 0);
  rb_define_module_function(mOSX, "NSNonOwnedPointerMapValueCallBacks", osx_NSNonOwnedPointerMapValueCallBacks, 0);
  rb_define_module_function(mOSX, "NSObjectMapValueCallBacks", osx_NSObjectMapValueCallBacks, 0);
  rb_define_module_function(mOSX, "NSNonRetainedObjectMapValueCallBacks", osx_NSNonRetainedObjectMapValueCallBacks, 0);
  rb_define_module_function(mOSX, "NSOwnedPointerMapValueCallBacks", osx_NSOwnedPointerMapValueCallBacks, 0);
  /**** functions ****/
  rb_define_module_function(mOSX, "NSCreateMapTableWithZone", osx_NSCreateMapTableWithZone, -1);
  rb_define_module_function(mOSX, "NSCreateMapTable", osx_NSCreateMapTable, -1);
  rb_define_module_function(mOSX, "NSFreeMapTable", osx_NSFreeMapTable, -1);
  rb_define_module_function(mOSX, "NSResetMapTable", osx_NSResetMapTable, -1);
  rb_define_module_function(mOSX, "NSCompareMapTables", osx_NSCompareMapTables, -1);
  rb_define_module_function(mOSX, "NSCopyMapTableWithZone", osx_NSCopyMapTableWithZone, -1);
  rb_define_module_function(mOSX, "NSMapMember", osx_NSMapMember, -1);
  rb_define_module_function(mOSX, "NSMapGet", osx_NSMapGet, -1);
  rb_define_module_function(mOSX, "NSMapInsert", osx_NSMapInsert, -1);
  rb_define_module_function(mOSX, "NSMapInsertKnownAbsent", osx_NSMapInsertKnownAbsent, -1);
  rb_define_module_function(mOSX, "NSMapInsertIfAbsent", osx_NSMapInsertIfAbsent, -1);
  rb_define_module_function(mOSX, "NSMapRemove", osx_NSMapRemove, -1);
  rb_define_module_function(mOSX, "NSEnumerateMapTable", osx_NSEnumerateMapTable, -1);
  rb_define_module_function(mOSX, "NSNextMapEnumeratorPair", osx_NSNextMapEnumeratorPair, -1);
  rb_define_module_function(mOSX, "NSEndMapTableEnumeration", osx_NSEndMapTableEnumeration, -1);
  rb_define_module_function(mOSX, "NSCountMapTable", osx_NSCountMapTable, -1);
  rb_define_module_function(mOSX, "NSStringFromMapTable", osx_NSStringFromMapTable, -1);
  rb_define_module_function(mOSX, "NSAllMapTableKeys", osx_NSAllMapTableKeys, -1);
  rb_define_module_function(mOSX, "NSAllMapTableValues", osx_NSAllMapTableValues, -1);
}
