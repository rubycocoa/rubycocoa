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

#import "ocdata_conv.h"

#import <objc/objc-class.h>
#import <Foundation/Foundation.h>

struct _ocobj_data {
  id  obj;
  int ownership;
};

#define OCOBJ_DATA_PTR(o) ((struct _ocobj_data*)(DATA_PTR(o)))
#define OCOBJ_ID_OF(o) (OCOBJ_DATA_PTR(o)->obj)

static VALUE rbclass_nsrect()
{
  VALUE mOSX = rb_const_get(rb_cObject, rb_intern("OSX"));
  if (!mOSX) return Qnil;
  return rb_const_get(mOSX, rb_intern("NSRect"));
}

static VALUE rbclass_nspoint()
{
  VALUE mOSX = rb_const_get(rb_cObject, rb_intern("OSX"));
  if (!mOSX) return Qnil;
  return rb_const_get(mOSX, rb_intern("NSPoint"));
}

static VALUE rbclass_nssize()
{
  VALUE mOSX = rb_const_get(rb_cObject, rb_intern("OSX"));
  if (!mOSX) return Qnil;
  return rb_const_get(mOSX, rb_intern("NSSize"));
}

int
to_octype(const char* octype_str)
{
  int oct = *octype_str;

  if (strcmp(octype_str, "r*") == 0) {
    oct = _C_CHARPTR;
  }
  else if (strcmp(octype_str, "{_NSRect={_NSPoint=ff}{_NSSize=ff}}") == 0) {
    oct = _PRIV_C_NSRECT;
  }
  else if (strcmp(octype_str, "{_NSPoint=ff}") == 0) {
    oct = _PRIV_C_NSPOINT;
  }
  else if (strcmp(octype_str, "{_NSSize=ff}") == 0) {
    oct = _PRIV_C_NSSIZE;
  }

  return oct;
}

BOOL octype_object_p(int octype)
{
  return ((octype == _C_ID) || (octype == _C_CLASS));
}

size_t
ocdata_size(int octype)
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

  case _C_FLT:
    result = sizeof(float); break;

  case _C_DBL:
    result = sizeof(double); break;

  case _C_PTR:
  case _C_CHARPTR:
    result = sizeof(char*); break;

  case _C_VOID:
    result = 0; break;

  case _PRIV_C_NSRECT:
    result = sizeof(NSRect); break;
    
  case _PRIV_C_NSPOINT:
    result = sizeof(NSPoint); break;

  case _PRIV_C_NSSIZE:
    result = sizeof(NSSize); break;

  case _C_BFLD:
  case _C_UNDEF:
  case _C_ARY_B:
  case _C_ARY_E:
  case _C_UNION_B:
  case _C_UNION_E:
  case _C_STRUCT_B:
  case _C_STRUCT_E:

  default:
    result = 0; break;
  }
  return result;
}

void*
ocdata_malloc_va_arg(va_list ap, int octype)
{
  void* data = ocdata_malloc(octype);

  switch (octype) {

  case _C_ID:
  case _C_CLASS:
    *(id*)data = va_arg(ap, id); break;
  case _C_SEL:
    *(SEL*)data = va_arg(ap, SEL); break;
  case _C_CHR:
    *(char*)data = va_arg(ap, char); break;
  case _C_UCHR:
    *(unsigned char*)data = va_arg(ap, unsigned char); break;
  case _C_SHT:
    *(short*)data = va_arg(ap, short); break;
  case _C_USHT:
    *(unsigned short*)data = va_arg(ap, unsigned short); break;
  case _C_INT:
    *(int*)data = va_arg(ap, int); break;
  case _C_UINT:
    *(unsigned int*)data = va_arg(ap, unsigned int); break;
  case _C_LNG:
    *(long*)data = va_arg(ap, long); break;
  case _C_ULNG:
    *(unsigned long*)data = va_arg(ap, unsigned long); break;
  case _C_FLT:
    *(float*)data = va_arg(ap, float); break;
  case _C_DBL:
    *(double*)data = va_arg(ap, double); break;
  case _C_PTR:
    *(void**)data = va_arg(ap, void*); break;
  case _C_CHARPTR:
    *(char**)data = va_arg(ap, char*); break;
  case _C_VOID:
    break;
  case _PRIV_C_NSRECT:
    *(NSRect*)data = va_arg(ap, NSRect); break;
  case _PRIV_C_NSPOINT:
    *(NSPoint*)data = va_arg(ap, NSPoint); break;
  case _PRIV_C_NSSIZE:
    *(NSSize*)data = va_arg(ap, NSSize); break;
  case _C_BFLD:
  case _C_UNDEF:
  case _C_ARY_B:
  case _C_ARY_E:
  case _C_UNION_B:
  case _C_UNION_E:
  case _C_STRUCT_B:
  case _C_STRUCT_E:
  default:
    break;
  }
  return data;
}

void*
ocdata_malloc(int octype)
{
  size_t s = ocdata_size(octype);
  if (s == 0) return NULL;
  return malloc(s);
}

BOOL
ocdata_to_rbobj(int octype, const void* ocdata,	VALUE* result)
{
  BOOL f_success = YES;
  VALUE rbval = Qnil;
  switch (octype) {

  case _C_ID:
  case _C_CLASS:
    rbval = OCID2NUM(*(id*)ocdata);
    break;

  case _PRIV_C_BOOL:
    rbval = bool_to_rbobj(*(BOOL*)ocdata);
    break;

  case _C_SEL: {
    id pool = [[NSAutoreleasePool alloc] init];
    NSString* arg_str = NSStringFromSelector(*(SEL*)ocdata);
    rbval = rb_str_new2([arg_str cString]);
    [pool release];
    break;
  }

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

  case _C_FLT:
    rbval = rb_float_new((double)(*(float*)ocdata)); break;

  case _C_DBL:
    rbval = rb_float_new(*(double*)ocdata); break;

  case _C_PTR:
  case _C_CHARPTR:
    rbval = rb_str_new2(*(char**)ocdata); break;

  case _PRIV_C_NSRECT: {
    NSRect* vp = (NSRect*)ocdata;
    VALUE klass = rbclass_nsrect();
    if (klass != Qnil)
      rbval = rb_funcall(klass, rb_intern("new"), 4,
			 rb_float_new((double)vp->origin.x),
			 rb_float_new((double)vp->origin.y),
			 rb_float_new((double)vp->size.width),
			 rb_float_new((double)vp->size.height));
    else
      f_success = NO;
    break;
  }

  case _PRIV_C_NSPOINT: {
    NSPoint* vp = (NSPoint*)ocdata;
    VALUE klass = rbclass_nspoint();
    if (klass != Qnil)
      rbval = rb_funcall(klass, rb_intern("new"), 2,
			 rb_float_new((double)vp->x),
			 rb_float_new((double)vp->y));
    else
      f_success = NO;
    break;
  }

  case _PRIV_C_NSSIZE: {
    NSSize* vp = (NSSize*)ocdata;
    VALUE klass = rbclass_nssize();
    if (klass != Qnil)
      rbval = rb_funcall(klass, rb_intern("new"), 2,
			 rb_float_new((double)vp->width),
			 rb_float_new((double)vp->height));
    else
      f_success = NO;
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
    f_success = NO;
    rbval = Qnil;
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

static BOOL rbnum_to_nsnum(VALUE rbval, id* nsval)
{
  BOOL result;
  VALUE rbstr = rb_obj_as_string(rbval);
  id pool = [[NSAutoreleasePool alloc] init];
  id nsstr = [NSString stringWithCString: STR2CSTR(rbstr)];
  *nsval = [[NSDecimalNumber alloc] initWithString: nsstr];
  result = [(*nsval) isKindOfClass: [NSDecimalNumber class]];
  [pool release];
  return result;
}

static BOOL rbobj_convert_to_nsobj(VALUE obj, id* nsobj)
{
  
  switch (TYPE(obj)) {

  case T_NIL:
    *nsobj = nil;
    return YES;

  case T_STRING:
  case T_SYMBOL:
    *nsobj = [NSString stringWithCString: STR2CSTR(rb_obj_as_string(obj))];
    return YES;

  case T_ARRAY:
    return rbary_to_nsary(obj, nsobj);
    
  case T_HASH:
    return NO;

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
  case T_TRUE:
  case T_FALSE:
  case RB_T_DATA:
  default:
    return NO;
  }
  return YES;
}

BOOL rbobj_to_nsobj(VALUE obj, id* nsobj)
{
  VALUE mOSX, cOCObject, rb_ocobj;

  // Object#__ocid__ (OCObject ?)
  if (rb_respond_to(obj, rb_intern("__ocid__"))) {
    VALUE val = rb_funcall(obj, rb_intern("__ocid__"), 0);
    *nsobj = (id) NUM2ULONG(val);
    return YES;
  }
 
 // Object#to_nsobj
  if (rb_respond_to(obj, rb_intern("to_nsobj"))) {
    VALUE nso = rb_funcall(obj, rb_intern("to_nsobj"), 0);
    VALUE val = rb_funcall(nso, rb_intern("__ocid__"), 0);
    *nsobj = (id) NUM2ULONG(val);
    return YES;
  }

  // OSX::OCObject::rbobj_to_nsobj
  mOSX = rb_const_get(rb_cObject, rb_intern("OSX"));
  if (mOSX != Qnil) {
    cOCObject = rb_const_get(mOSX, rb_intern("OCObject"));
    if (cOCObject != Qnil) {
      RB_ID mid = rb_intern("rbobj_to_nsobj");
      if (rb_respond_to(cOCObject, mid)) {
	rb_ocobj = rb_funcall(cOCObject, mid, 1, obj);
	if (rb_ocobj != Qnil) {
	  *nsobj = (id) OCOBJ_ID_OF(rb_ocobj);
	  return YES;
	}
      }
    }
  }

  // convert
  if (rbobj_convert_to_nsobj(obj, nsobj)) {
    return YES;
  }

  return NO;
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
  if (ocdata_to_rbobj(_C_SEL, &val, &rbobj)) {
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


id rbobj_to_nsselstr(VALUE obj)
{
  VALUE str = rb_obj_as_string(obj);
  // str.tr!('_',':')
  rb_funcall(str, rb_intern("tr!"), 2, rb_str_new2("_"), rb_str_new2(":"));
  return [NSString stringWithCString: STR2CSTR(str)];
}

SEL rbobj_to_nssel(VALUE obj)
{
  id pool = [[NSAutoreleasePool alloc] init];
  id nsstr = rbobj_to_nsselstr(obj);
  SEL nssel = NSSelectorFromString(nsstr);
  [pool release];
  return nssel;
}

static BOOL rbobj_to_nspoint(VALUE obj, NSPoint* result)
{
  if (TYPE(obj) != T_ARRAY)
    obj = rb_funcall(obj, rb_intern("to_a"), 0);
  if (RARRAY(obj)->len != 2) return NO;
  result->x = (float) RFLOAT(rb_Float(rb_ary_entry(obj, 0)))->value;
  result->y = (float) RFLOAT(rb_Float(rb_ary_entry(obj, 1)))->value;
  return YES;
}

static BOOL rbobj_to_nssize(VALUE obj, NSSize* result)
{
  if (TYPE(obj) != T_ARRAY)
    obj = rb_funcall(obj, rb_intern("to_a"), 0);
  if (RARRAY(obj)->len != 2) return NO;
  result->width = (float) RFLOAT(rb_Float(rb_ary_entry(obj, 0)))->value;
  result->height = (float) RFLOAT(rb_Float(rb_ary_entry(obj, 1)))->value;
  return YES;
}

static BOOL rbobj_to_nsrect(VALUE obj, NSRect* result)
{
  if (TYPE(obj) != T_ARRAY)
    obj = rb_funcall(obj, rb_intern("to_a"), 0);
  if (RARRAY(obj)->len == 2) {
    VALUE rb_orig = rb_ary_entry(obj, 0);
    VALUE rb_size = rb_ary_entry(obj, 1);
    if (!rbobj_to_nspoint(rb_orig, &(result->origin))) return NO;
    if (!rbobj_to_nssize(rb_size, &(result->size))) return NO;
  }
  else if (RARRAY(obj)->len == 4) {
    result->origin.x = (float) RFLOAT(rb_Float(rb_ary_entry(obj, 0)))->value;
    result->origin.y = (float) RFLOAT(rb_Float(rb_ary_entry(obj, 1)))->value;
    result->size.width = (float) RFLOAT(rb_Float(rb_ary_entry(obj, 2)))->value;
    result->size.height = (float) RFLOAT(rb_Float(rb_ary_entry(obj, 3)))->value;
  }
  else {
    return NO;
  }
  return YES;
}

BOOL
rbobj_to_ocdata(VALUE obj, int octype, void* ocdata)
{
  BOOL f_success = YES;

  if (TYPE(obj) == T_TRUE) {
    obj = INT2NUM(1);
  }
  else if (TYPE(obj) == T_FALSE) {
    obj = INT2NUM(0);
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

  case _C_FLT:
    *(float*)ocdata = (float) RFLOAT(rb_Float(obj))->value;
    break;

  case _C_DBL:
    *(double*)ocdata = RFLOAT(rb_Float(obj))->value;
    break;

  case _C_PTR:
  case _C_CHARPTR:
    *(char**)ocdata = STR2CSTR(rb_obj_as_string(obj));
    break;

  case _PRIV_C_NSRECT: {
    NSRect nsval;
    f_success = rbobj_to_nsrect(obj, &nsval);
    if (f_success) *(NSRect*)ocdata = nsval;
    break;
  }

  case _PRIV_C_NSPOINT: {
    NSPoint nsval;
    f_success = rbobj_to_nspoint(obj, &nsval);
    if (f_success) *(NSPoint*)ocdata = nsval;
    break;
  }

  case _PRIV_C_NSSIZE: {
    NSSize nsval;
    f_success = rbobj_to_nssize(obj, &nsval);
    if (f_success) *(NSSize*)ocdata = nsval;
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
    f_success = NO;
    break;

  }

  return f_success;
}
