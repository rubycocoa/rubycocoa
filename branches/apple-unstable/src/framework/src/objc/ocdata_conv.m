/** -*-objc-*-
 *
 *   $Id$
 *
 *   Copyright (c) 2001 FUJIMOTO Hisakuni
 *
 **/

#import <objc/objc-class.h>
#import <Foundation/Foundation.h>
#import "ocdata_conv.h"
#import "RBObject.h"
#import "mdl_osxobjc.h"
#import <CoreFoundation/CFString.h> // CFStringEncoding
#import "st.h"
#import "BridgeSupport.h"

#define CACHE_LOCKING 0

static struct st_table *rb2ocCache;
static struct st_table *oc2rbCache;

#if CACHE_LOCKING
static pthread_mutex_t rb2ocCacheLock;
static pthread_mutex_t oc2rbCacheLock;
# define CACHE_LOCK(x)      (pthread_mutex_lock(x))
# define CACHE_UNLOCK(x)    (pthread_mutex_unlock(x))
#else
# define CACHE_LOCK(x)
# define CACHE_UNLOCK(x)
#endif

void init_rb2oc_cache(void)
{
  rb2ocCache = st_init_numtable();
#if CACHE_LOCKING
  pthread_mutex_init(&rb2ocCacheLock, NULL);
#endif
}

void init_oc2rb_cache(void)
{
  oc2rbCache = st_init_numtable();
#if CACHE_LOCKING
  pthread_mutex_init(&oc2rbCacheLock, NULL);
#endif
}

void remove_from_oc2rb_cache(id ocid)
{
  CACHE_LOCK(&oc2rbCacheLock);
  st_delete(oc2rbCache, (st_data_t *)&ocid, NULL);
  CACHE_UNLOCK(&oc2rbCacheLock);
}

void remove_from_rb2oc_cache(VALUE rbobj)
{
  CACHE_LOCK(&rb2ocCacheLock);
  st_delete(rb2ocCache, (st_data_t *)&rbobj, NULL);
  CACHE_UNLOCK(&rb2ocCacheLock);
}

int
to_octype(const char* octype_str)
{
  int oct;
  struct bsBoxed *bs_boxed;

  // Avoid first character 'r' which means const.
  if (octype_str[0] == 'r') 
    octype_str++;
  oct = *octype_str;

  // Structures.
  if ((bs_boxed = find_bs_boxed_by_encoding(octype_str)) != NULL) {
    oct = bs_boxed->octype;
  }
  // Type IDs.
  else if (find_bs_cf_type_by_encoding(octype_str) != NULL) {
    oct = _C_ID;
  }
  // Pointers.
  else if (octype_str[0] == '^') {
    if (strcmp(octype_str, "^@") == 0 || strcmp(octype_str, "^r@") == 0)
      oct = _PRIV_C_ID_PTR;
    else
      oct = _PRIV_C_PTR;
  }

  return oct;
}

size_t
ocdata_size(int octype, const char* octype_str)
{
  size_t result = 0;
  switch (octype) {

  case _C_ID:
  case _C_CLASS:
    result = sizeof(id); break;

  case _C_SEL:
    result = sizeof(SEL); break;

  case _C_CHR:
  case _C_UCHR:
    result = sizeof(char); break;

  case _C_SHT:
  case _C_USHT:
    result = sizeof(short); break;

  case _C_INT:
  case _C_UINT:
    result = sizeof(int); break;

  case _C_LNG:
  case _C_ULNG:
    result = sizeof(long); break;

#if HAVE_LONG_LONG
  case _C_LLNG:
  case _C_ULLNG:
    result = sizeof(long long); break;
#endif

  case _C_FLT:
    result = sizeof(float); break;

  case _C_DBL:
    result = sizeof(double); break;

    // case _C_PTR:
  case _C_CHARPTR:
    result = sizeof(char*); break;

  case _C_VOID:
    result = 0; break;

  case _PRIV_C_BOOL:
#if defined(_C_BOOL)
  case _C_BOOL:
#endif
    result = sizeof(BOOL); break;    

  case _PRIV_C_PTR:
    result = sizeof(void*); break;

  case _PRIV_C_ID_PTR:
    result = sizeof(id*); break;

  case _C_BFLD:
  case _C_UNDEF:
  case _C_ARY_B:
  case _C_ARY_E:
  case _C_UNION_B:
  case _C_UNION_E:
  case _C_STRUCT_B:
  case _C_STRUCT_E:

  default: {
    if (octype > BS_BOXED_OCTYPE_THRESHOLD) {
      struct bsBoxed *bs_boxed;

      bs_boxed = find_bs_boxed_by_octype(octype);
      if (bs_boxed != NULL)
        result = bs_boxed->size;
    }
    if (result == 0 && octype_str != NULL) {
      unsigned int size, align;
      NSGetSizeAndAlignment(octype_str, &size, &align);
      result = size;
    }
    break;
  }
  }
  return result;
}

void*
ocdata_malloc(int octype, const char* octype_str)
{
  size_t s = ocdata_size(octype, octype_str);
  if (s == 0) return NULL;
  return malloc(s);
}

BOOL
ocdata_to_rbobj(VALUE context_obj,
		int octype, const void* ocdata, VALUE* result, BOOL from_libffi)
{
  BOOL f_success = YES;
  VALUE rbval = Qnil;

#if BYTE_ORDER == BIG_ENDIAN
  // libffi casts all types as a void pointer, which is problematic on PPC for types sized less than a void pointer (char, uchar, short, ushort, ...), as we have to shift the bytes to get the real value.
  if (from_libffi) {
    int delta = sizeof(void *) - ocdata_size(octype, NULL);
    if (delta > 0)
      ocdata += delta; 
  }
#endif

  switch (octype) {

  case _C_ID:
  case _C_CLASS:
    rbval = ocid_to_rbobj(context_obj, *(id*)ocdata);
    break;

  case _PRIV_C_PTR:
    rbval = objcptr_s_new_with_cptr (*(void**)ocdata);
    break;

  case _PRIV_C_BOOL:
#if defined(_C_BOOL)
  case _C_BOOL:
#endif
    rbval = bool_to_rbobj(*(BOOL*)ocdata);
    break;

  case _C_SEL:
    rbval = rb_str_new2(sel_getName(*(SEL*)ocdata));
    break;

  case _C_CHR:
    rbval = INT2NUM(*(char*)ocdata); break;

  case _C_UCHR:
    rbval = UINT2NUM(*(unsigned char*)ocdata); break;

  case _C_SHT:
    rbval = INT2NUM(*(short*)ocdata); break;

  case _C_USHT:
    rbval = UINT2NUM(*(unsigned short*)ocdata); break;

  case _C_INT:
    rbval = INT2NUM(*(int*)ocdata); break;

  case _C_UINT:
    rbval = UINT2NUM(*(unsigned int*)ocdata); break;

  case _C_LNG:
    rbval = INT2NUM(*(long*)ocdata); break;

  case _C_ULNG:
    rbval = UINT2NUM(*(unsigned long*)ocdata); break;

#if HAVE_LONG_LONG
  case _C_LLNG:
    rbval = LL2NUM(*(long long*)ocdata); break;

  case _C_ULLNG:
    rbval = ULL2NUM(*(unsigned long long*)ocdata); break;
#endif

  case _C_FLT:
    rbval = rb_float_new((double)(*(float*)ocdata)); break;

  case _C_DBL:
    rbval = rb_float_new(*(double*)ocdata); break;

    // case _C_PTR:
  case _C_CHARPTR:
    rbval = rb_str_new2(*(char**)ocdata); break;

  case _C_BFLD:
  case _C_VOID:
  case _C_UNDEF:
    
  case _C_ARY_B:
  case _C_ARY_E:
  case _C_UNION_B:
  case _C_UNION_E:
  case _C_STRUCT_B:
  case _C_STRUCT_E:

  default:
    if (octype > BS_BOXED_OCTYPE_THRESHOLD) {
      struct bsBoxed *bs_boxed;

      bs_boxed = find_bs_boxed_by_octype(octype);
      if (bs_boxed != NULL) {
        f_success = YES;
        rbval = rb_bs_boxed_new_from_ocdata(bs_boxed, (void *)ocdata);
      }
      else {
        f_success = NO;
        rbval = Qnil;
      }
    }
    else {
      f_success = NO;
      rbval = Qnil;
    }
    break;
  }

  if (f_success) *result = rbval;
  return f_success;
}

static BOOL rbary_to_nsary(VALUE rbary, id* nsary)
{
  long i;
  long len = RARRAY(rbary)->len;
  VALUE* items = RARRAY(rbary)->ptr;
  NSMutableArray* result = [[[NSMutableArray alloc] init] autorelease];
  for (i = 0; i < len; i++) {
    id nsitem;
    if (!rbobj_to_nsobj(items[i], &nsitem)) return NO;
    [result addObject: nsitem];
  }
  *nsary = result;
  return YES;
}

static BOOL rbhash_to_nsdic(VALUE rbhash, id* nsdic)
{
  VALUE ary_keys;
  VALUE* keys;
  VALUE val;
  long i, len;
  NSMutableDictionary* result;
  id nskey, nsval;

  ary_keys = rb_funcall(rbhash, rb_intern("keys"), 0);
  len = RARRAY(ary_keys)->len;
  keys = RARRAY(ary_keys)->ptr;

  result = [[[NSMutableDictionary alloc] init] autorelease];

  for (i = 0; i < len; i++) {
    if (!rbobj_to_nsobj(keys[i], &nskey)) return NO;
    val = rb_hash_aref(rbhash, keys[i]);
    if (!rbobj_to_nsobj(val, &nsval)) return NO;
    [result setObject: nsval forKey: nskey];
  }
  *nsdic = result;
  return YES;
}

static BOOL rbbool_to_nsnum(VALUE rbval, id* nsval)
{
  *nsval = [NSNumber numberWithBool:RTEST(rbval)];
  return YES;
}

static BOOL rbnum_to_nsnum(VALUE rbval, id* nsval)
{
  BOOL result;
  VALUE rbstr = rb_obj_as_string(rbval);
  id nsstr = [NSString stringWithUTF8String: STR2CSTR(rbstr)];
  *nsval = [NSDecimalNumber decimalNumberWithString: nsstr];
  result = [(*nsval) isKindOfClass: [NSDecimalNumber class]];
  return result;
}

static BOOL rbobj_convert_to_nsobj(VALUE obj, id* nsobj)
{
  
  switch (TYPE(obj)) {

  case T_NIL:
    *nsobj = nil;
    return YES;

  case T_STRING:
    obj = rb_obj_as_string(obj);
    *nsobj = rbstr_to_ocstr(obj);
    return YES;

  case T_SYMBOL:
    obj = rb_obj_as_string(obj);
    *nsobj = [NSString stringWithUTF8String: RSTRING(obj)->ptr];
    return YES;

  case T_ARRAY:
    return rbary_to_nsary(obj, nsobj);

  case T_HASH:
    return  rbhash_to_nsdic(obj, nsobj);

  case T_TRUE:
  case T_FALSE:
    return rbbool_to_nsnum(obj, nsobj);     

  case T_FIXNUM:
  case T_BIGNUM:
  case T_FLOAT:
    return rbnum_to_nsnum(obj, nsobj);

  case T_OBJECT:
  case T_CLASS:
  case T_MODULE:
  case T_REGEXP:
  case T_STRUCT:
  case T_FILE:
  case RB_T_DATA:
  default:
    *nsobj = [[[RBObject alloc] initWithRubyObject: obj] autorelease];
    return YES;
  }
  return YES;
}

BOOL rbobj_to_nsobj(VALUE obj, id* nsobj)
{
  BOOL  ok;

  if (obj == Qnil) {
    *nsobj = nil;
    return YES;
  }

  // Cache new Objective-C object addresses in an internal table to 
  // avoid duplication.
  //
  // We are locking the access to the cache twice (lookup + insert) as
  // rbobj_convert_to_nsobj is succeptible to call us again, to avoid
  // a deadlock.

  CACHE_LOCK(&rb2ocCacheLock);
  ok = st_lookup(rb2ocCache, (st_data_t)obj, (st_data_t *)nsobj);
  CACHE_UNLOCK(&rb2ocCacheLock);

  if (!ok) {
    *nsobj = rbobj_get_ocid(obj);
    if (*nsobj != nil || rbobj_convert_to_nsobj(obj, nsobj)) {
      if ([*nsobj isProxy] && [*nsobj isRBObject]) {
        CACHE_LOCK(&rb2ocCacheLock);
        // Check out that the hash is still empty for us, to avoid a race condition.
        if (!st_lookup(rb2ocCache, (st_data_t)obj, (st_data_t *)nsobj))
          st_insert(rb2ocCache, (st_data_t)obj, (st_data_t)*nsobj);
        CACHE_UNLOCK(&rb2ocCacheLock);
      }
      ok = YES;
    }
  }

  return ok;
}

BOOL rbobj_to_bool(VALUE obj)
{
  return ((obj != Qnil) && (obj != Qfalse)) ? YES : NO;
}

VALUE bool_to_rbobj (BOOL val)
{
  return (val ? Qtrue : Qfalse);
}

VALUE sel_to_rbobj (SEL val)
{
  VALUE rbobj;
  if (ocdata_to_rbobj(Qnil, _C_SEL, &val, &rbobj, NO)) {
    rbobj = rb_obj_as_string(rbobj);
    // str.tr!(':','_')
    rb_funcall(rbobj, rb_intern("tr!"), 2, rb_str_new2(":"), rb_str_new2("_"));
    // str.sub!(/_+$/,'')
    rb_funcall(rbobj, rb_intern("sub!"), 2, rb_str_new2("_+$"), rb_str_new2(""));
  }
  else {
    rbobj = Qnil;
  }
  return rbobj;
}

VALUE int_to_rbobj (int val)
{
  return INT2NUM(val);
}

VALUE uint_to_rbobj (unsigned int val)
{
  return UINT2NUM(val);
}

VALUE double_to_rbobj (double val)
{
  return rb_float_new(val);
}

VALUE
ocid_to_rbobj(VALUE context_obj, id ocid)
{
  VALUE result;
  BOOL  ok;

  if (ocid == nil) 
    return Qnil;

  // Cache new Ruby object addresses in an internal table to 
  // avoid duplication.
  //
  // We are locking the access to the cache twice (lookup + insert) as
  // ocobj_s_new is succeptible to call us again, to avoid a deadlock.

  CACHE_LOCK(&oc2rbCacheLock);
  ok = st_lookup(oc2rbCache, (st_data_t)ocid, (st_data_t *)&result);
  CACHE_UNLOCK(&oc2rbCacheLock);

  if (!ok) {
    result = ocid_get_rbobj(ocid);
    if (result == Qnil)
      result = rbobj_get_ocid(context_obj) == ocid ? context_obj : ocobj_s_new(ocid);

    CACHE_LOCK(&oc2rbCacheLock);
    // Check out that the hash is still empty for us, to avoid a race condition.
    if (!st_lookup(oc2rbCache, (st_data_t)ocid, (st_data_t *)&result))
      st_insert(oc2rbCache, (st_data_t)ocid, (st_data_t)result);
    CACHE_UNLOCK(&oc2rbCacheLock);
  }

  return result;
}

const char * rbobj_to_cselstr(VALUE obj)
{
  int i;
  VALUE str = rb_obj_as_string(obj);

  // str[0..0] + str[1..-1].tr('_',':')
  for (i = 1; i < RSTRING(str)->len; i++) {
    if (RSTRING(str)->ptr[i] == '_')
      RSTRING(str)->ptr[i] = ':';
  }
  return STR2CSTR(str);
}

id rbobj_to_nsselstr(VALUE obj)
{
  return [NSString stringWithUTF8String:rbobj_to_cselstr(obj)];
}

SEL rbobj_to_nssel(VALUE obj)
{
  return NIL_P(obj) ? NULL : sel_registerName(rbobj_to_cselstr(obj));
}

static BOOL rbobj_to_objcptr(VALUE obj, void** cptr)
{
  if (TYPE(obj) == T_NIL) {
    *cptr = NULL;
  }
  else if (TYPE(obj) == T_STRING) {
    *cptr = RSTRING(obj)->ptr;
  }
#if 0
  // TODO
  else if (TYPE(obj) == T_ARRAY) {
    if (RARRAY(obj)->len > 0) {
      void *ary;
      unsigned i;

      ary = *cptr;
      for (i = 0; i < RARRAY(obj)->len; i++) {
        rbobj_to_ocdata( )
      }
    }
    else {
      *cptr = NULL;
    }
  }
#endif
  else if (rb_obj_is_kind_of(obj, objid_s_class()) == Qtrue) {
    *cptr = OBJCID_ID(obj);
  }
  else if (rb_obj_is_kind_of(obj, objcptr_s_class()) == Qtrue) {
    *cptr = objcptr_cptr(obj);
  }
  else if (rb_obj_is_kind_of(obj, objboxed_s_class()) == Qtrue) {
    struct bsBoxed *bs_boxed;
    void *data;
    BOOL ok;

    bs_boxed = find_bs_boxed_for_klass(CLASS_OF(obj));
    if (bs_boxed == NULL)
      return NO;

    data = rb_bs_boxed_get_data(obj, bs_boxed->octype, NULL, &ok);
    if (!ok)
      return NO;
    *cptr = data;
  } 
  else {
    return NO;
  }
  return YES;
}

static BOOL rbobj_to_idptr(VALUE obj, id** idptr)
{
  if (TYPE(obj) == T_NIL) {
    *idptr = nil;
  }
  else if (TYPE(obj) == T_ARRAY) {
    if (RARRAY(obj)->len > 0) {
      id *ary;
      unsigned i;

      ary = *idptr;
      for (i = 0; i < RARRAY(obj)->len; i++) {
        if (!rbobj_to_nsobj(RARRAY(obj)->ptr[i], &ary[i])) {
          *idptr = nil;
          return NO;
        }
      }
    }
    else {
      *idptr = nil;
    }
  }
  else if (rb_obj_is_kind_of(obj, objid_s_class()) == Qtrue) {
    id old_id = OBJCID_ID(obj);
    if (old_id) [old_id release];
    OBJCID_ID(obj) = nil;
    *idptr = OBJCID_IDPTR(obj);
  }
  else {
    return NO;
  }
  return YES;
}

BOOL
rbobj_to_ocdata(VALUE obj, int octype, void* ocdata, BOOL to_libffi)
{
  BOOL f_success = YES;

#if BYTE_ORDER == BIG_ENDIAN
  // libffi casts all types as a void pointer, which is problematic on PPC for types sized less than a void pointer (char, uchar, short, ushort, ...), as we have to shift the bytes to get the real value.
  if (to_libffi) {
    int delta = sizeof(void *) - ocdata_size(octype, NULL);
    if (delta > 0)
      ocdata += delta; 
  }
#endif

  // Make sure we convert booleans to NSNumber booleans.
  if (octype != _C_ID) {
    if (TYPE(obj) == T_TRUE) {
      obj = INT2NUM(1);
    }
    else if (TYPE(obj) == T_FALSE) {
      obj = INT2NUM(0);
    }
  }

  switch (octype) {

  case _C_ID:
  case _C_CLASS: {
    id nsobj;
    f_success = rbobj_to_nsobj(obj, &nsobj);
    if (f_success) *(id*)ocdata = nsobj;
    break;
  }

  case _C_SEL:
    *(SEL*)ocdata = rbobj_to_nssel(obj);
    break;

  case _C_CHR:
  case _PRIV_C_BOOL:
#if defined(_C_BOOL)
  case _C_BOOL:
#endif
    *(char*)ocdata = (char) NUM2INT(rb_Integer(obj));
    break;

  case _C_UCHR:
    *(unsigned char*)ocdata = (unsigned char) NUM2UINT(rb_Integer(obj));
    break;

  case _C_SHT:
    *(short*)ocdata = (short) NUM2INT(rb_Integer(obj));
    break;

  case _C_USHT:
    *(unsigned short*)ocdata = (unsigned short) NUM2UINT(rb_Integer(obj));
    break;

  case _C_INT:
    *(int*)ocdata = (int) NUM2INT(rb_Integer(obj));
    break;

  case _C_UINT:
    *(unsigned int*)ocdata = (unsigned int) NUM2UINT(rb_Integer(obj));
    break;

  case _C_LNG:
    *(long*)ocdata = (long) NUM2LONG(rb_Integer(obj));
    break;

  case _C_ULNG:
    *(unsigned long*)ocdata = (unsigned long) NUM2ULONG(rb_Integer(obj));
    break;

#if HAVE_LONG_LONG
  case _C_LLNG:
    *(long long*)ocdata = (long long) NUM2LL(rb_Integer(obj));
    break;

  case _C_ULLNG:
    *(unsigned long long*)ocdata = (unsigned long long) NUM2ULL(rb_Integer(obj));
    break;
#endif

  case _C_FLT:
    *(float*)ocdata = (float) RFLOAT(rb_Float(obj))->value;
    break;

  case _C_DBL:
    *(double*)ocdata = RFLOAT(rb_Float(obj))->value;
    break;

    // case _C_PTR:
  case _C_CHARPTR:
    *(char**)ocdata = STR2CSTR(rb_obj_as_string(obj));
    break;

  case _PRIV_C_PTR: {
    //void* cptr = NULL;
    f_success = rbobj_to_objcptr(obj, ocdata/*&cptr*/);
    //if (f_success) *(void**)ocdata = cptr;
    break;
  }

  case _PRIV_C_ID_PTR: {
    //id* idptr = NULL;
    f_success = rbobj_to_idptr(obj, ocdata/*&idptr*/);
    //if (f_success) *(id**)ocdata = idptr;
    break;
  }

  case _C_BFLD:
  case _C_VOID:
  case _C_UNDEF:
  case _C_ARY_B:
  case _C_ARY_E:
  case _C_UNION_B:
  case _C_UNION_E:
  case _C_STRUCT_B:
  case _C_STRUCT_E:

  default:
    if (octype > BS_BOXED_OCTYPE_THRESHOLD) {
      void *data;
      size_t size;

      data = rb_bs_boxed_get_data(obj, octype, &size, &f_success);
      if (f_success) {
        if (data == NULL)
          *(void **)ocdata = NULL;
        else
          memcpy(ocdata, data, size);
      }
    }
    else
      f_success = NO;
    break;
  }

  return f_success;
}

static NSStringEncoding kcode_to_nsencoding(const char* kcode) 
{ 
  if (strcmp(kcode, "UTF8") == 0)
    return NSUTF8StringEncoding;
  else if (strcmp(kcode, "SJIS") == 0)
    return CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingMacJapanese);
  else if (strcmp(kcode, "EUC") == 0)
    return NSJapaneseEUCStringEncoding;
  else // "NONE"
    return NSUTF8StringEncoding;
}
#define KCODE_NSSTRENCODING kcode_to_nsencoding(rb_get_kcode()) 

id
rbstr_to_ocstr(VALUE obj)
{
  return [[[NSString alloc] initWithData:[NSData dataWithBytes:RSTRING(obj)->ptr
			    			 length: RSTRING(obj)->len]
			    encoding:KCODE_NSSTRENCODING] autorelease];
}

VALUE
ocstr_to_rbstr(id ocstr)
{
  NSData * data = [(NSString *)ocstr dataUsingEncoding:KCODE_NSSTRENCODING
				     allowLossyConversion:YES];
  return rb_str_new ([data bytes], [data length]);
}

// 10.4 or lower, use NSMethodSignature.
// Otherwise, use the Objective-C runtime API, which is faster and more reliable with structures encoding.
void
decode_method_encoding(const char *encoding, unsigned *argc, char **retval_type, char ***arg_types, BOOL strip_first_two_args)
{
  unsigned i;
  unsigned l_argc;
  char *l_retval_type;
  char **l_arg_types;

#if MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_4
  NSMethodSignature *methodSignature;
  NSAutoreleasePool *pool;

  pool = [[NSAutoreleasePool alloc] init];
  methodSignature = [NSMethodSignature signatureWithObjCTypes:encoding];
  l_argc = [methodSignature numberOfArguments];
  if (strip_first_two_args)
    l_argc -= 2;
  l_retval_type = strdup([methodSignature methodReturnType]);
  if (l_argc > 0) {
    l_arg_types = (char **)malloc(sizeof(char *) * l_argc);
    for (i = 0; i < l_argc; i++)
      l_arg_types[i] = strdup([methodSignature getArgumentTypeAtIndex:i + (strip_first_two_args ? 2 : 0)]);
  }
  else {
    l_arg_types = NULL;
  }
  [pool release];
#else
  // There is no public API to parse encoding, but we can make a fake method.
  struct objc_method method;
  method.method_types = (char *)encoding;

  l_argc = method_getNumberOfArguments(&method);
  if (strip_first_two_args)
    l_argc -= 2;
  l_retval_type = method_copyReturnType(&method);
  if (l_argc > 0) {
    l_arg_types = (char **)malloc(sizeof(char *) * l_argc);
    for (i = 0; i < l_argc; i++)
      l_arg_types[i] = method_copyArgumentType(&method, i + (strip_first_two_args ? 2 : 0));
  }
  else {
    l_arg_types = NULL;
  }
#endif

  *argc = l_argc;
  *retval_type = l_retval_type;
  *arg_types = l_arg_types;
}
