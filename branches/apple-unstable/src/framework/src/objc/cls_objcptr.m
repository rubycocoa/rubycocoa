/** -*-objc-*-
 *
 *   $Id$
 *
 *   Copyright (c) 2001 FUJIMOTO Hisakuni
 *
 **/
#import "cls_objcptr.h"
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>

static VALUE _kObjcPtr = Qnil;

struct _objcptr_data {
  long    allocated_size;
  void *  cptr;
  const char *  encoding; 
};

#define OBJCPTR_DATA_PTR(o) ((struct _objcptr_data*)(DATA_PTR(o)))
#define CPTR_OF(o) (OBJCPTR_DATA_PTR(o)->cptr)
#define ALLOCATED_SIZE_OF(o) (OBJCPTR_DATA_PTR(o)->allocated_size)
#define ENCODING_OF(o) (OBJCPTR_DATA_PTR(o)->encoding)

/** for debugging stuff **/
void cptrlog(const char* s, VALUE obj)
{
  NSStringEncoding* p = (NSStringEncoding*) CPTR_OF(obj);
  NSLog(@"%s: < p,*p > %u(%x) %d(%x)", s, p, p, *p, *p);
}
/** **/

static void
_objcptr_data_free(struct _objcptr_data* dp)
{
  if (dp != NULL) {
    if (dp->allocated_size > 0)
      free (dp->cptr);
    dp->allocated_size = 0;
    dp->cptr = NULL;
    dp->encoding = NULL;
    free (dp);
  }
}

static struct _objcptr_data*
_objcptr_data_new()
{
  struct _objcptr_data* dp = NULL;
  dp = malloc (sizeof(struct _objcptr_data)); // ALLOC?
  dp->allocated_size = 0;
  dp->cptr = NULL;
  dp->encoding = NULL;
  return dp;
}

static VALUE
_objcptr_s_new(VALUE klass, long len)
{
  VALUE obj;
  obj = Data_Wrap_Struct(klass, 0, _objcptr_data_free, _objcptr_data_new());
  rb_obj_taint(obj);
  if (len > 0) {
    CPTR_OF (obj) = (void*) malloc (len);
    if (CPTR_OF (obj)) ALLOCATED_SIZE_OF(obj) = len;
    rb_obj_untaint(obj);
  }
  return obj;
}

static VALUE
rb_objcptr_s_allocate(VALUE klass, VALUE length)
{
  return _objcptr_s_new (klass, NUM2LONG (length));
}

static VALUE
rb_objcptr_s_allocate_as_int8(VALUE klass)
{
  return _objcptr_s_new (klass, sizeof(int8_t));
}

static VALUE
rb_objcptr_s_allocate_as_int16(VALUE klass)
{
  return _objcptr_s_new (klass, sizeof(int16_t));
}

static VALUE
rb_objcptr_s_allocate_as_int32(VALUE klass)
{
  return _objcptr_s_new (klass, sizeof(int32_t));
}

static VALUE
rb_objcptr_inspect(VALUE rcv)
{
  char s[512];
  VALUE rbclass_name;

  rbclass_name = rb_mod_name(CLASS_OF(rcv));
  snprintf(s, sizeof(s), "#<%s:0x%lx cptr=%p allocated_size=%ld>",
	   STR2CSTR(rbclass_name),
	   NUM2ULONG(rb_obj_id(rcv)),
	   CPTR_OF(rcv),
	   ALLOCATED_SIZE_OF(rcv));
  // cptrlog ("rb_objcptr_inspect", rcv);
  return rb_str_new2(s);
}

static VALUE
rb_objcptr_allocated_size(VALUE rcv)
{
  return UINT2NUM (ALLOCATED_SIZE_OF (rcv));
}

long
objcptr_allocated_size(VALUE rcv)
{
  return ALLOCATED_SIZE_OF (rcv);
}

static VALUE
rb_objcptr_bytestr_at(VALUE rcv, VALUE offset, VALUE length)
{
  return rb_tainted_str_new ((char*)CPTR_OF(rcv) + NUM2LONG(offset), NUM2LONG(length));
}

static VALUE
rb_objcptr_bytestr(int argc, VALUE* argv, VALUE rcv)
{
  VALUE  rb_length;
  long length;

  length = ALLOCATED_SIZE_OF(rcv);
  rb_scan_args(argc, argv, "01", &rb_length);
  if (length == 0 || rb_length != Qnil) {
    Check_Type(rb_length, T_FIXNUM);
    length = NUM2LONG(rb_length);
  }
  return rb_tainted_str_new (CPTR_OF(rcv), length);
}

static VALUE
rb_objcptr_int8_at(VALUE rcv, VALUE index)
{
  int8_t* ptr = (int8_t*) CPTR_OF(rcv);
  return INT2NUM ( ptr [NUM2LONG(index)] );
}

static VALUE
rb_objcptr_uint8_at(VALUE rcv, VALUE index)
{
  u_int8_t* ptr = (u_int8_t*) CPTR_OF(rcv);
  return UINT2NUM ( ptr [NUM2LONG(index)] );
}

static VALUE
rb_objcptr_int16_at(VALUE rcv, VALUE index)
{
  int16_t* ptr = (int16_t*) CPTR_OF(rcv);
  return INT2NUM ( ptr [NUM2LONG(index)] );
}

static VALUE
rb_objcptr_uint16_at(VALUE rcv, VALUE index)
{
  u_int16_t* ptr = (u_int16_t*) CPTR_OF(rcv);
  return UINT2NUM ( ptr [NUM2LONG(index)] );
}

static VALUE
rb_objcptr_int32_at(VALUE rcv, VALUE index)
{
  int32_t* ptr = (int32_t*) CPTR_OF(rcv);
  return INT2NUM ( ptr [NUM2LONG(index)] );
}

static VALUE
rb_objcptr_uint32_at(VALUE rcv, VALUE index)
{
  u_int32_t* ptr = (u_int32_t*) CPTR_OF(rcv);
  return UINT2NUM ( ptr [NUM2LONG(index)] );
}


static VALUE
rb_objcptr_int8(VALUE rcv)
{
  return INT2NUM (* (int8_t*) CPTR_OF(rcv));
}

static VALUE
rb_objcptr_uint8(VALUE rcv)
{
  return UINT2NUM (* (u_int8_t*) CPTR_OF(rcv));
}

static VALUE
rb_objcptr_int16(VALUE rcv)
{
  return INT2NUM (* (int16_t*) CPTR_OF(rcv));
}

static VALUE
rb_objcptr_uint16(VALUE rcv)
{
  return UINT2NUM (* (u_int16_t*) CPTR_OF(rcv));
}

static VALUE
rb_objcptr_int32(VALUE rcv)
{
  return INT2NUM (* (int32_t*) CPTR_OF(rcv));
}

static VALUE
rb_objcptr_uint32(VALUE rcv)
{
  return UINT2NUM (* (u_int32_t*) CPTR_OF(rcv));
}


/** class methods called from the Objc World **/
VALUE
objcptr_s_class ()
{
  return _kObjcPtr;
}

VALUE
objcptr_s_new_with_cptr (void* cptr, const char* encoding)
{
  VALUE obj;
  obj = _objcptr_s_new (_kObjcPtr, 0);
  CPTR_OF(obj) = cptr;
  ENCODING_OF(obj) = encoding + 1;  // skipping the first type
  return obj;
}

/** instance methods called from the Objc World **/
void* objcptr_cptr (VALUE rcv)
{
  if (CLASS_OF(rcv) == _kObjcPtr) {
    OBJ_TAINT(rcv);		   // A raw C pointer is passed to the C world, so it may taint.
    return CPTR_OF(rcv);
  }
  return NULL;
}

static VALUE
rb_objcptr_at (VALUE rcv, VALUE key)
{
  unsigned offset;
  VALUE val;

  Check_Type(key, T_FIXNUM);
  if (ENCODING_OF(rcv) == NULL)
    rb_raise(rb_eRuntimeError, "#[] can't be called on this instance");

  offset = FIX2INT(key);  
  offset *= ocdata_size(ENCODING_OF(rcv));

  if (!ocdata_to_rbobj(Qnil, ENCODING_OF(rcv), CPTR_OF(rcv) + offset, &val, NO))
    rb_raise(rb_eRuntimeError, "Can't convert element of type '%s' at index %d offset %d", ENCODING_OF(rcv), FIX2INT(key), offset);

  return val; 
}

/*******/

VALUE
init_cls_ObjcPtr(VALUE outer)
{
  _kObjcPtr = rb_define_class_under (outer, "ObjcPtr", rb_cObject);

  rb_define_singleton_method (_kObjcPtr, "new", rb_objcptr_s_allocate, 1);
  rb_define_singleton_method (_kObjcPtr, "allocate_as_int8", rb_objcptr_s_allocate_as_int8, 0);
  rb_define_singleton_method (_kObjcPtr, "allocate_as_int16", rb_objcptr_s_allocate_as_int16, 0);
  rb_define_singleton_method (_kObjcPtr, "allocate_as_int32", rb_objcptr_s_allocate_as_int32, 0);
  rb_define_singleton_method (_kObjcPtr, "allocate_as_int", rb_objcptr_s_allocate_as_int32, 0);
  rb_define_singleton_method (_kObjcPtr, "allocate_as_bool", rb_objcptr_s_allocate_as_int8, 0);

  rb_define_method (_kObjcPtr, "inspect", rb_objcptr_inspect, 0);
  rb_define_method (_kObjcPtr, "allocated_size", rb_objcptr_allocated_size, 0);

  rb_define_method (_kObjcPtr, "bytestr_at", rb_objcptr_bytestr_at, 2);
  rb_define_method (_kObjcPtr, "bytestr", rb_objcptr_bytestr, -1);

  rb_define_method (_kObjcPtr, "int8_at", rb_objcptr_int8_at, 1);
  rb_define_method (_kObjcPtr, "uint8_at", rb_objcptr_uint8_at, 1);
  rb_define_method (_kObjcPtr, "int16_at", rb_objcptr_int16_at, 1);
  rb_define_method (_kObjcPtr, "uint16_at", rb_objcptr_uint16_at, 1);
  rb_define_method (_kObjcPtr, "int32_at", rb_objcptr_int32_at, 1);
  rb_define_method (_kObjcPtr, "uint32_at", rb_objcptr_uint32_at, 1);
  rb_define_alias (_kObjcPtr, "int_at", "int32_at");
  rb_define_alias (_kObjcPtr, "uint_at", "uint32_at");
  rb_define_alias (_kObjcPtr, "bool_at", "uint8_at");

  rb_define_method (_kObjcPtr, "int8", rb_objcptr_int8, 0);
  rb_define_method (_kObjcPtr, "uint8", rb_objcptr_uint8, 0);
  rb_define_method (_kObjcPtr, "int16", rb_objcptr_int16, 0);
  rb_define_method (_kObjcPtr, "uint16", rb_objcptr_uint16, 0);
  rb_define_method (_kObjcPtr, "int32", rb_objcptr_int32, 0);
  rb_define_method (_kObjcPtr, "uint32", rb_objcptr_uint32, 0);
  rb_define_alias (_kObjcPtr, "int", "int32");
  rb_define_alias (_kObjcPtr, "uint", "uint32");
  rb_define_alias (_kObjcPtr, "bool", "uint8");

  rb_define_method (_kObjcPtr, "[]", rb_objcptr_at, 1);

  return _kObjcPtr;
}
