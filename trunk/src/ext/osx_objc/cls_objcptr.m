/** -*-objc-*-
 *
 *   $Id$
 *
 *   Copyright (c) 2001 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
 *
 *   This program is free software.
 *   You can distribute/modify this program under the terms of
 *   the GNU Lesser General Public License version 2.
 *
 **/
#import "cls_objcptr.h"
#import <Foundation/Foundation.h>

static VALUE _kObjcPtr = Qnil;

struct _objcptr_data {
  long  allocate_size;
  void* cptr;
};

#define OBJCPTR_DATA_PTR(o) ((struct _objcptr_data*)(DATA_PTR(o)))
#define CPTR_OF(o) ((void*)(OBJCPTR_DATA_PTR(o)->cptr))
#define ALLOCATE_SIZE_OF(o) (OBJCPTR_DATA_PTR(o)->allocate_size)

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
    if (dp->allocate_size > 0)
      free (dp->cptr);
    dp->allocate_size = 0;
    dp->cptr = NULL;
    free (dp);
  }
}

static struct _objcptr_data*
_objcptr_data_new()
{
  struct _objcptr_data* dp = NULL;
  dp = malloc (sizeof(struct _objcptr_data)); // ALLOC?
  dp->cptr = NULL;
  dp->allocate_size = 0;
  return dp;
}

static VALUE
rb_objcptr_s_allocate(VALUE klass, VALUE length)
{
  VALUE obj;
  long len = NUM2LONG (length);
  obj = Data_Wrap_Struct(klass, 0, _objcptr_data_free, _objcptr_data_new());
  CPTR_OF (obj) = (void*) malloc (len);
  if (CPTR_OF (obj)) ALLOCATE_SIZE_OF(obj) = len;
  return obj;
}

static VALUE
rb_objcptr_inspect(VALUE rcv)
{
  char s[512];
  VALUE rbclass_name;

  rbclass_name = rb_mod_name(CLASS_OF(rcv));
  snprintf(s, sizeof(s), "#<%s:0x%x cptr=%X allocate_size=%d>",
	   STR2CSTR(rbclass_name),
	   NUM2ULONG(rb_obj_id(rcv)),
	   CPTR_OF(rcv),
	   ALLOCATE_SIZE_OF(rcv));
  // cptrlog ("rb_objcptr_inspect", rcv);
  return rb_str_new2(s);
}

static VALUE
rb_objcptr_allocate_size(VALUE rcv)
{
  return UINT2NUM (ALLOCATE_SIZE_OF (rcv));
}

static VALUE
rb_objcptr_bytestr_at(VALUE rcv, VALUE offset, VALUE length)
{
  return rb_str_new ((char*)CPTR_OF(rcv) + NUM2LONG(offset), NUM2LONG(length));
}

static VALUE
rb_objcptr_bytestr(int argc, VALUE* argv, VALUE rcv)
{
  VALUE  rb_length;
  long length;

  length = ALLOCATE_SIZE_OF(rcv);
  rb_scan_args(argc, argv, "01", &rb_length);
  if (length == 0 || rb_length != Qnil) {
    Check_Type(rb_length, T_FIXNUM);
    length = NUM2LONG(rb_length);
  }
  return rb_str_new (CPTR_OF(rcv), length);
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


/** class methods called from the Objc World **/
VALUE
objcptr_s_class ()
{
  return _kObjcPtr;
}

VALUE
objcptr_s_new_with_cptr (void* cptr)
{
  VALUE obj;
  obj = Data_Wrap_Struct(_kObjcPtr, 0, _objcptr_data_free, _objcptr_data_new());
  CPTR_OF(obj) = cptr;
  ALLOCATE_SIZE_OF(obj) = 0;
  // cptrlog ("objcptr_s_new_with_cptr", obj);
  return obj;
}

/** instance methods called from the Objc World **/
void* objcptr_cptr (VALUE rcv)
{
  if (CLASS_OF(rcv) == _kObjcPtr)
    return CPTR_OF(rcv);
  return NULL;
}


/*******/

VALUE
init_cls_ObjcPtr(VALUE outer)
{
  _kObjcPtr = rb_define_class_under (outer, "ObjcPtr", rb_cObject);

  rb_define_singleton_method (_kObjcPtr, "new", rb_objcptr_s_allocate, 1);
  rb_define_singleton_method (_kObjcPtr, "allocate", rb_objcptr_s_allocate, 1);

  rb_define_method (_kObjcPtr, "inspect", rb_objcptr_inspect, 0);
  rb_define_method (_kObjcPtr, "allocate_size", rb_objcptr_allocate_size, 0);

  rb_define_method (_kObjcPtr, "bytestr_at", rb_objcptr_bytestr_at, 2);
  rb_define_method (_kObjcPtr, "bytestr", rb_objcptr_bytestr, -1);

  rb_define_method (_kObjcPtr, "int16_at", rb_objcptr_int16_at, 1);
  rb_define_method (_kObjcPtr, "uint16_at", rb_objcptr_uint16_at, 1);
  rb_define_method (_kObjcPtr, "int32_at", rb_objcptr_int32_at, 1);
  rb_define_method (_kObjcPtr, "uint32_at", rb_objcptr_uint32_at, 1);

  return _kObjcPtr;
}
