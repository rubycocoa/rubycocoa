#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h>
#import <Foundation/Foundation.h>

extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, id pool);
static const int VA_MAX = 4;


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
osx_NSCreateMapTableWithZone(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3)
{
  rb_notimplement();
}

// NSMapTable *NSCreateMapTable(NSMapTableKeyCallBacks keyCallBacks, NSMapTableValueCallBacks valueCallBacks, unsigned capacity);
static VALUE
osx_NSCreateMapTable(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{
  rb_notimplement();
}

// void NSFreeMapTable(NSMapTable *table);
static VALUE
osx_NSFreeMapTable(VALUE mdl, VALUE a0)
{

  NSMapTable * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);

  NSFreeMapTable(ns_a0);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSResetMapTable(NSMapTable *table);
static VALUE
osx_NSResetMapTable(VALUE mdl, VALUE a0)
{

  NSMapTable * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);

  NSResetMapTable(ns_a0);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// BOOL NSCompareMapTables(NSMapTable *table1, NSMapTable *table2);
static VALUE
osx_NSCompareMapTables(VALUE mdl, VALUE a0, VALUE a1)
{
  BOOL ns_result;

  NSMapTable * ns_a0;
  NSMapTable * ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_PTR, &ns_a1, pool, 1);

  ns_result = NSCompareMapTables(ns_a0, ns_a1);

  rb_result = nsresult_to_rbresult(_PRIV_C_BOOL, &ns_result, pool);
  [pool release];
  return rb_result;
}

// NSMapTable *NSCopyMapTableWithZone(NSMapTable *table, NSZone *zone);
static VALUE
osx_NSCopyMapTableWithZone(VALUE mdl, VALUE a0, VALUE a1)
{
  NSMapTable * ns_result;

  NSMapTable * ns_a0;
  NSZone * ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_PTR, &ns_a1, pool, 1);

  ns_result = NSCopyMapTableWithZone(ns_a0, ns_a1);

  rb_result = nsresult_to_rbresult(_C_PTR, &ns_result, pool);
  [pool release];
  return rb_result;
}

// BOOL NSMapMember(NSMapTable *table, const void *key, void **originalKey, void **value);
static VALUE
osx_NSMapMember(VALUE mdl, VALUE a0, VALUE a1, VALUE a2, VALUE a3)
{
  BOOL ns_result;

  NSMapTable * ns_a0;
  const void * ns_a1;
  void ** ns_a2;
  void ** ns_a3;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_PTR, &ns_a1, pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_PTR, &ns_a2, pool, 2);
  /* a3 */
  rbarg_to_nsarg(a3, _C_PTR, &ns_a3, pool, 3);

  ns_result = NSMapMember(ns_a0, ns_a1, ns_a2, ns_a3);

  rb_result = nsresult_to_rbresult(_PRIV_C_BOOL, &ns_result, pool);
  [pool release];
  return rb_result;
}

// void *NSMapGet(NSMapTable *table, const void *key);
static VALUE
osx_NSMapGet(VALUE mdl, VALUE a0, VALUE a1)
{
  void * ns_result;

  NSMapTable * ns_a0;
  const void * ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_PTR, &ns_a1, pool, 1);

  ns_result = NSMapGet(ns_a0, ns_a1);

  rb_result = nsresult_to_rbresult(_C_PTR, &ns_result, pool);
  [pool release];
  return rb_result;
}

// void NSMapInsert(NSMapTable *table, const void *key, const void *value);
static VALUE
osx_NSMapInsert(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{

  NSMapTable * ns_a0;
  const void * ns_a1;
  const void * ns_a2;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_PTR, &ns_a1, pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_PTR, &ns_a2, pool, 2);

  NSMapInsert(ns_a0, ns_a1, ns_a2);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void NSMapInsertKnownAbsent(NSMapTable *table, const void *key, const void *value);
static VALUE
osx_NSMapInsertKnownAbsent(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{

  NSMapTable * ns_a0;
  const void * ns_a1;
  const void * ns_a2;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_PTR, &ns_a1, pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_PTR, &ns_a2, pool, 2);

  NSMapInsertKnownAbsent(ns_a0, ns_a1, ns_a2);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// void *NSMapInsertIfAbsent(NSMapTable *table, const void *key, const void *value);
static VALUE
osx_NSMapInsertIfAbsent(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{
  void * ns_result;

  NSMapTable * ns_a0;
  const void * ns_a1;
  const void * ns_a2;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_PTR, &ns_a1, pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_PTR, &ns_a2, pool, 2);

  ns_result = NSMapInsertIfAbsent(ns_a0, ns_a1, ns_a2);

  rb_result = nsresult_to_rbresult(_C_PTR, &ns_result, pool);
  [pool release];
  return rb_result;
}

// void NSMapRemove(NSMapTable *table, const void *key);
static VALUE
osx_NSMapRemove(VALUE mdl, VALUE a0, VALUE a1)
{

  NSMapTable * ns_a0;
  const void * ns_a1;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_PTR, &ns_a1, pool, 1);

  NSMapRemove(ns_a0, ns_a1);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// NSMapEnumerator NSEnumerateMapTable(NSMapTable *table);
static VALUE
osx_NSEnumerateMapTable(VALUE mdl, VALUE a0)
{
  rb_notimplement();
}

// BOOL NSNextMapEnumeratorPair(NSMapEnumerator *enumerator, void **key, void **value);
static VALUE
osx_NSNextMapEnumeratorPair(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{
  BOOL ns_result;

  NSMapEnumerator * ns_a0;
  void ** ns_a1;
  void ** ns_a2;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _C_PTR, &ns_a1, pool, 1);
  /* a2 */
  rbarg_to_nsarg(a2, _C_PTR, &ns_a2, pool, 2);

  ns_result = NSNextMapEnumeratorPair(ns_a0, ns_a1, ns_a2);

  rb_result = nsresult_to_rbresult(_PRIV_C_BOOL, &ns_result, pool);
  [pool release];
  return rb_result;
}

// void NSEndMapTableEnumeration(NSMapEnumerator *enumerator);
static VALUE
osx_NSEndMapTableEnumeration(VALUE mdl, VALUE a0)
{

  NSMapEnumerator * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);

  NSEndMapTableEnumeration(ns_a0);

  rb_result = Qnil;
  [pool release];
  return rb_result;
}

// unsigned NSCountMapTable(NSMapTable *table);
static VALUE
osx_NSCountMapTable(VALUE mdl, VALUE a0)
{
  unsigned ns_result;

  NSMapTable * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);

  ns_result = NSCountMapTable(ns_a0);

  rb_result = nsresult_to_rbresult(_C_UINT, &ns_result, pool);
  [pool release];
  return rb_result;
}

// NSString *NSStringFromMapTable(NSMapTable *table);
static VALUE
osx_NSStringFromMapTable(VALUE mdl, VALUE a0)
{
  NSString * ns_result;

  NSMapTable * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);

  ns_result = NSStringFromMapTable(ns_a0);

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, pool);
  [pool release];
  return rb_result;
}

// NSArray *NSAllMapTableKeys(NSMapTable *table);
static VALUE
osx_NSAllMapTableKeys(VALUE mdl, VALUE a0)
{
  NSArray * ns_result;

  NSMapTable * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);

  ns_result = NSAllMapTableKeys(ns_a0);

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, pool);
  [pool release];
  return rb_result;
}

// NSArray *NSAllMapTableValues(NSMapTable *table);
static VALUE
osx_NSAllMapTableValues(VALUE mdl, VALUE a0)
{
  NSArray * ns_result;

  NSMapTable * ns_a0;

  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _C_PTR, &ns_a0, pool, 0);

  ns_result = NSAllMapTableValues(ns_a0);

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, pool);
  [pool release];
  return rb_result;
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
  rb_define_module_function(mOSX, "NSCreateMapTableWithZone", osx_NSCreateMapTableWithZone, 4);
  rb_define_module_function(mOSX, "NSCreateMapTable", osx_NSCreateMapTable, 3);
  rb_define_module_function(mOSX, "NSFreeMapTable", osx_NSFreeMapTable, 1);
  rb_define_module_function(mOSX, "NSResetMapTable", osx_NSResetMapTable, 1);
  rb_define_module_function(mOSX, "NSCompareMapTables", osx_NSCompareMapTables, 2);
  rb_define_module_function(mOSX, "NSCopyMapTableWithZone", osx_NSCopyMapTableWithZone, 2);
  rb_define_module_function(mOSX, "NSMapMember", osx_NSMapMember, 4);
  rb_define_module_function(mOSX, "NSMapGet", osx_NSMapGet, 2);
  rb_define_module_function(mOSX, "NSMapInsert", osx_NSMapInsert, 3);
  rb_define_module_function(mOSX, "NSMapInsertKnownAbsent", osx_NSMapInsertKnownAbsent, 3);
  rb_define_module_function(mOSX, "NSMapInsertIfAbsent", osx_NSMapInsertIfAbsent, 3);
  rb_define_module_function(mOSX, "NSMapRemove", osx_NSMapRemove, 2);
  rb_define_module_function(mOSX, "NSEnumerateMapTable", osx_NSEnumerateMapTable, 1);
  rb_define_module_function(mOSX, "NSNextMapEnumeratorPair", osx_NSNextMapEnumeratorPair, 3);
  rb_define_module_function(mOSX, "NSEndMapTableEnumeration", osx_NSEndMapTableEnumeration, 1);
  rb_define_module_function(mOSX, "NSCountMapTable", osx_NSCountMapTable, 1);
  rb_define_module_function(mOSX, "NSStringFromMapTable", osx_NSStringFromMapTable, 1);
  rb_define_module_function(mOSX, "NSAllMapTableKeys", osx_NSAllMapTableKeys, 1);
  rb_define_module_function(mOSX, "NSAllMapTableValues", osx_NSAllMapTableValues, 1);
}
