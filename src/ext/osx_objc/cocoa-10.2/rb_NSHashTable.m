#import "osx_ruby.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

extern VALUE oc_err_new (const char* fname, NSException* nsexcp);
extern void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
extern VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
static const int VA_MAX = 4;


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
// NSHashTable * NSCreateHashTableWithZone ( NSHashTableCallBacks callBacks , unsigned capacity , NSZone * zone );
static VALUE
osx_NSCreateHashTableWithZone(VALUE mdl, VALUE a0, VALUE a1, VALUE a2)
{
  rb_notimplement();
}

// NSHashTable * NSCreateHashTable ( NSHashTableCallBacks callBacks , unsigned capacity );
static VALUE
osx_NSCreateHashTable(VALUE mdl, VALUE a0, VALUE a1)
{
  rb_notimplement();
}

// void NSFreeHashTable ( NSHashTable * table );
static VALUE
osx_NSFreeHashTable(VALUE mdl, VALUE a0)
{

  NSHashTable * ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSFreeHashTable", pool, 0);

NS_DURING
  NSFreeHashTable(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSFreeHashTable", localException);
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

// void NSResetHashTable ( NSHashTable * table );
static VALUE
osx_NSResetHashTable(VALUE mdl, VALUE a0)
{

  NSHashTable * ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSResetHashTable", pool, 0);

NS_DURING
  NSResetHashTable(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSResetHashTable", localException);
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

// BOOL NSCompareHashTables ( NSHashTable * table1 , NSHashTable * table2 );
static VALUE
osx_NSCompareHashTables(VALUE mdl, VALUE a0, VALUE a1)
{
  BOOL ns_result;

  NSHashTable * ns_a0;
  NSHashTable * ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSCompareHashTables", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSCompareHashTables", pool, 1);

NS_DURING
  ns_result = NSCompareHashTables(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSCompareHashTables", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_PRIV_C_BOOL, &ns_result, "NSCompareHashTables", pool);
  [pool release];
  return rb_result;
}

// NSHashTable * NSCopyHashTableWithZone ( NSHashTable * table , NSZone * zone );
static VALUE
osx_NSCopyHashTableWithZone(VALUE mdl, VALUE a0, VALUE a1)
{
  NSHashTable * ns_result;

  NSHashTable * ns_a0;
  NSZone * ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSCopyHashTableWithZone", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSCopyHashTableWithZone", pool, 1);

NS_DURING
  ns_result = NSCopyHashTableWithZone(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSCopyHashTableWithZone", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_PRIV_C_PTR, &ns_result, "NSCopyHashTableWithZone", pool);
  [pool release];
  return rb_result;
}

// void * NSHashGet ( NSHashTable * table , const void * pointer );
static VALUE
osx_NSHashGet(VALUE mdl, VALUE a0, VALUE a1)
{
  void * ns_result;

  NSHashTable * ns_a0;
  const void * ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSHashGet", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSHashGet", pool, 1);

NS_DURING
  ns_result = NSHashGet(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSHashGet", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_PRIV_C_PTR, &ns_result, "NSHashGet", pool);
  [pool release];
  return rb_result;
}

// void NSHashInsert ( NSHashTable * table , const void * pointer );
static VALUE
osx_NSHashInsert(VALUE mdl, VALUE a0, VALUE a1)
{

  NSHashTable * ns_a0;
  const void * ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSHashInsert", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSHashInsert", pool, 1);

NS_DURING
  NSHashInsert(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSHashInsert", localException);
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

// void NSHashInsertKnownAbsent ( NSHashTable * table , const void * pointer );
static VALUE
osx_NSHashInsertKnownAbsent(VALUE mdl, VALUE a0, VALUE a1)
{

  NSHashTable * ns_a0;
  const void * ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSHashInsertKnownAbsent", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSHashInsertKnownAbsent", pool, 1);

NS_DURING
  NSHashInsertKnownAbsent(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSHashInsertKnownAbsent", localException);
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

// void * NSHashInsertIfAbsent ( NSHashTable * table , const void * pointer );
static VALUE
osx_NSHashInsertIfAbsent(VALUE mdl, VALUE a0, VALUE a1)
{
  void * ns_result;

  NSHashTable * ns_a0;
  const void * ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSHashInsertIfAbsent", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSHashInsertIfAbsent", pool, 1);

NS_DURING
  ns_result = NSHashInsertIfAbsent(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSHashInsertIfAbsent", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_PRIV_C_PTR, &ns_result, "NSHashInsertIfAbsent", pool);
  [pool release];
  return rb_result;
}

// void NSHashRemove ( NSHashTable * table , const void * pointer );
static VALUE
osx_NSHashRemove(VALUE mdl, VALUE a0, VALUE a1)
{

  NSHashTable * ns_a0;
  const void * ns_a1;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSHashRemove", pool, 0);
  /* a1 */
  rbarg_to_nsarg(a1, _PRIV_C_PTR, &ns_a1, "NSHashRemove", pool, 1);

NS_DURING
  NSHashRemove(ns_a0, ns_a1);
NS_HANDLER
  excp = oc_err_new ("NSHashRemove", localException);
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

// NSHashEnumerator NSEnumerateHashTable ( NSHashTable * table );
static VALUE
osx_NSEnumerateHashTable(VALUE mdl, VALUE a0)
{
  rb_notimplement();
}

// void * NSNextHashEnumeratorItem ( NSHashEnumerator * enumerator );
static VALUE
osx_NSNextHashEnumeratorItem(VALUE mdl, VALUE a0)
{
  void * ns_result;

  NSHashEnumerator * ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSNextHashEnumeratorItem", pool, 0);

NS_DURING
  ns_result = NSNextHashEnumeratorItem(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSNextHashEnumeratorItem", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_PRIV_C_PTR, &ns_result, "NSNextHashEnumeratorItem", pool);
  [pool release];
  return rb_result;
}

// void NSEndHashTableEnumeration ( NSHashEnumerator * enumerator );
static VALUE
osx_NSEndHashTableEnumeration(VALUE mdl, VALUE a0)
{

  NSHashEnumerator * ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSEndHashTableEnumeration", pool, 0);

NS_DURING
  NSEndHashTableEnumeration(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSEndHashTableEnumeration", localException);
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

// unsigned NSCountHashTable ( NSHashTable * table );
static VALUE
osx_NSCountHashTable(VALUE mdl, VALUE a0)
{
  unsigned ns_result;

  NSHashTable * ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSCountHashTable", pool, 0);

NS_DURING
  ns_result = NSCountHashTable(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSCountHashTable", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_UINT, &ns_result, "NSCountHashTable", pool);
  [pool release];
  return rb_result;
}

// NSString * NSStringFromHashTable ( NSHashTable * table );
static VALUE
osx_NSStringFromHashTable(VALUE mdl, VALUE a0)
{
  NSString * ns_result;

  NSHashTable * ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSStringFromHashTable", pool, 0);

NS_DURING
  ns_result = NSStringFromHashTable(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSStringFromHashTable", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, "NSStringFromHashTable", pool);
  [pool release];
  return rb_result;
}

// NSArray * NSAllHashTableObjects ( NSHashTable * table );
static VALUE
osx_NSAllHashTableObjects(VALUE mdl, VALUE a0)
{
  NSArray * ns_result;

  NSHashTable * ns_a0;

  VALUE excp = Qnil;
  VALUE rb_result;
  id pool = [[NSAutoreleasePool alloc] init];
  /* a0 */
  rbarg_to_nsarg(a0, _PRIV_C_PTR, &ns_a0, "NSAllHashTableObjects", pool, 0);

NS_DURING
  ns_result = NSAllHashTableObjects(ns_a0);
NS_HANDLER
  excp = oc_err_new ("NSAllHashTableObjects", localException);
NS_ENDHANDLER
  if (excp != Qnil) {
    [pool release];
    rb_exc_raise (excp);
    return Qnil;
  }

  rb_result = nsresult_to_rbresult(_C_ID, &ns_result, "NSAllHashTableObjects", pool);
  [pool release];
  return rb_result;
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
  rb_define_module_function(mOSX, "NSCreateHashTableWithZone", osx_NSCreateHashTableWithZone, 3);
  rb_define_module_function(mOSX, "NSCreateHashTable", osx_NSCreateHashTable, 2);
  rb_define_module_function(mOSX, "NSFreeHashTable", osx_NSFreeHashTable, 1);
  rb_define_module_function(mOSX, "NSResetHashTable", osx_NSResetHashTable, 1);
  rb_define_module_function(mOSX, "NSCompareHashTables", osx_NSCompareHashTables, 2);
  rb_define_module_function(mOSX, "NSCopyHashTableWithZone", osx_NSCopyHashTableWithZone, 2);
  rb_define_module_function(mOSX, "NSHashGet", osx_NSHashGet, 2);
  rb_define_module_function(mOSX, "NSHashInsert", osx_NSHashInsert, 2);
  rb_define_module_function(mOSX, "NSHashInsertKnownAbsent", osx_NSHashInsertKnownAbsent, 2);
  rb_define_module_function(mOSX, "NSHashInsertIfAbsent", osx_NSHashInsertIfAbsent, 2);
  rb_define_module_function(mOSX, "NSHashRemove", osx_NSHashRemove, 2);
  rb_define_module_function(mOSX, "NSEnumerateHashTable", osx_NSEnumerateHashTable, 1);
  rb_define_module_function(mOSX, "NSNextHashEnumeratorItem", osx_NSNextHashEnumeratorItem, 1);
  rb_define_module_function(mOSX, "NSEndHashTableEnumeration", osx_NSEndHashTableEnumeration, 1);
  rb_define_module_function(mOSX, "NSCountHashTable", osx_NSCountHashTable, 1);
  rb_define_module_function(mOSX, "NSStringFromHashTable", osx_NSStringFromHashTable, 1);
  rb_define_module_function(mOSX, "NSAllHashTableObjects", osx_NSAllHashTableObjects, 1);
}
