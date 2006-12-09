/*
 *  BridgeSupport.m
 *  RubyCocoa
 *
 *  Created by Laurent Sansonetti on 8/29/06.
 *  Copyright 2006 Apple Computer. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "osx_ruby.h"
#import "osx_intern.h"
#import "BridgeSupport.h"
#import <dlfcn.h>
#import <st.h>
#import <env.h>
#import <objc/objc-class.h>
#import <objc/objc-runtime.h>
#import "ocdata_conv.h"
#import "ffi.h"
#import "RBRuntime.h" // for DLOG
#import "cls_objcid.h"
#import "BridgeSupportLexer.h"
#import "RBClassUtils.h"

static VALUE cOSXBoxed;
static ID ivarEncodingID;

VALUE objboxed_s_class(void)
{
  return cOSXBoxed;
}

static struct st_table *bsBoxed;       // boxed encoding -> struct bsBoxed
static struct st_table *bsBoxed2;      // boxed octype -> struct bsBoxed
static struct st_table *bsCFTypes;     // encoding -> struct bsCFType
static struct st_table *bsCFTypes2;    // CFTypeID -> struct bsCFType
static struct st_table *bsFunctions;   // function name -> struct bsFunction
static struct st_table *bsConstants;   // constant name -> type
static struct st_table *bsClasses;     // class name -> struct bsClass
static struct st_table *bsInformalProtocolClassMethods;         // selector -> struct bsInformalProtocolMethod
static struct st_table *bsInformalProtocolInstanceMethods;      // selector -> struct bsInformalProtocolMethod

struct bsFunction *current_function = NULL;

#define ASSERT_ALLOC(x) do { if (x == NULL) rb_fatal("can't allocate memory"); } while (0)
#define MAX_ENCODE_LEN 1024

#define CAPITALIZE(x)         \
  do {                        \
    if (islower(x[0]))        \
      x[0] = toupper(x[0]);   \
  }                           \
  while (0)

#define DECAPITALIZE(x)       \
  do {                        \
    if (isupper(x[0]))        \
      x[0] = tolower(x[0]);   \
  }                           \
  while (0)

// struct proxies octype constants, each proxy has a unique octype, starting at a given threshold. 
static int bs_boxed_octype_idx = BS_BOXED_OCTYPE_THRESHOLD + 1;

static VALUE
_ocdataconv_err_class()
{
  static VALUE exc = Qnil;
  if (exc == Qnil) {
    VALUE mosx = rb_const_get(rb_cObject, rb_intern("OSX"));
    exc = rb_const_get(mosx, rb_intern("OCDataConvException"));
  }
  return exc;
}

static VALUE
_oc_err_class()
{
  static VALUE exc = Qnil;
  if (exc == Qnil) {
    VALUE mosx = rb_const_get(rb_cObject, rb_intern("OSX"));
    exc = rb_const_get(mosx, rb_intern("OCException"));
  }
  return exc;
}

VALUE
oc_err_new (const char* fname, NSException* nsexcp)
{
  id pool = [[NSAutoreleasePool alloc] init];
  VALUE exc = _oc_err_class();
  char buf[BUFSIZ];
  VALUE result;

  snprintf(buf, BUFSIZ, "%s - %s - %s", fname,
       [[nsexcp name] cString], [[nsexcp reason] cString]);
  result = rb_funcall(exc, rb_intern("new"), 2, ocid_to_rbobj(Qnil, nsexcp), rb_str_new2(buf));
  [pool release];
  return result;
}

void
rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index)
{
  if (!rbobj_to_ocdata(rbarg, octype, nsarg, YES)) {
    if (pool) [pool release];
    rb_raise(_ocdataconv_err_class(), "%s - arg #%d cannot convert to nsobj.", fname, index);
  }
}

VALUE
nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool)
{
  VALUE rbresult;
  if (!ocdata_to_rbobj(Qnil, octype, nsresult, &rbresult, YES)) {
    if (pool) [pool release];
    rb_raise(_ocdataconv_err_class(), "%s - result cannot convert to rbobj.", fname);
  }
  return rbresult;
}

#if HAS_LIBXML2
#include <libxml/xmlreader.h>

static BOOL
next_node(xmlTextReaderPtr reader)
{
  int   retval;

  retval = xmlTextReaderRead(reader);
  if (retval == 0)
    return NO;

  if (retval < 0)
    rb_raise(rb_eRuntimeError, "parsing error: %d", retval);

  return YES;
}

static inline char *
get_attribute(xmlTextReaderPtr reader, const char *name)
{
  return (char *)xmlTextReaderGetAttribute(reader, (const xmlChar *)name);
}

static inline char *
get_attribute_and_check(xmlTextReaderPtr reader, const char *name)
{
  char *  attribute;

  attribute = get_attribute(reader, name); 
  if (attribute == NULL)
    rb_raise(rb_eRuntimeError, "expected attribute `%s' for element `%s'", name, xmlTextReaderConstName(reader));

  if (strlen(name) == 0)
    rb_raise(rb_eRuntimeError, "empty attribute `%s' for element `%s'", name, xmlTextReaderConstName(reader));

  return attribute;
}

static inline char *
get_value_and_check(xmlTextReaderPtr reader)
{
  xmlChar * value;
  
  value = xmlTextReaderValue(reader);
  if (value == NULL)
    rb_raise(rb_eRuntimeError, "expected value for element `%s'", xmlTextReaderConstName(reader));

  return (char *)value;
}

static void
get_c_ary_type_attribute(xmlTextReaderPtr reader, bsCArrayArgType *type, int *value)
{
  char *c_ary_type;

  if ((c_ary_type = get_attribute(reader, "c_array_delimited_by_arg")) != NULL) {
    *type = bsCArrayArgDelimitedByArg;
    *value = atoi(c_ary_type);
  }
  else if ((c_ary_type = get_attribute(reader, "c_array_of_fixed_length")) != NULL) {
    *type = bsCArrayArgFixedLength;
    *value = atoi(c_ary_type);
  }
  else if ((c_ary_type = get_attribute(reader, "c_array_delimited_by_null")) != NULL
           && strcmp(c_ary_type, "true") == 0) {
    *type = bsCArrayArgDelimitedByNull;
    *value = -1;
  }
  else {
    *type = bsCArrayArgUndefined;
    *value = -1;
  }

  if (c_ary_type != NULL)
    free(c_ary_type);
}

static inline BOOL
get_boolean_attribute(xmlTextReaderPtr reader, const char *name, BOOL default_value)
{
  char *value;
  BOOL ret;

  value = get_attribute(reader, name);
  if (value == NULL)
    return default_value;
  ret = strcmp(value, "true") == 0;
  free(value);
  return ret;
}

static void
free_bs_function (struct bsFunction *func)
{
  free(func->name);
  if (func->argv != NULL)
    free(func->argv);
  free(func);
}

static void
free_bs_method (struct bsMethod *method)
{
  free(method->selector);
  if (method->suggestion != NULL)
    free(method->suggestion);
  if (method->argv != NULL)
    free(method->argv);
  free(method);
}

extern struct FRAME *ruby_frame;

static BOOL 
undecorate_encoding(const char *src, char *dest, size_t dest_len, struct bsStructField *fields, size_t fields_count, int *out_fields_count)
{
  const char *p_src;
  char *p_dst;
  char *pos;
  size_t src_len;
  unsigned field_idx;
  unsigned i;

  p_src = src;
  p_dst = dest;
  src_len = strlen(src);
  field_idx = 0;
  if (out_fields_count != NULL)
    *out_fields_count = 0;

  for (;;) {
    struct bsStructField *field;
    size_t len;

    field = field_idx < fields_count ? &fields[field_idx] : NULL;

    // Locate the first field, if any.
    pos = strchr(p_src, '"');

    // Copy what's before the first field, or the rest of the source.
    len = MIN(pos == NULL ? src_len - (p_src - src) + 1 : pos - p_src, dest_len - (p_dst - dest));
    strncpy(p_dst, p_src, len);
    p_dst += len;

    // We can break if there wasn't any field.
    if (pos == NULL)
      break;

    // Jump to the end of the field, saving the field name if necessary.
    p_src = pos + 1;
    pos = strchr(p_src, '"');
    if (pos == NULL) {
      DLOG("MDLOSX", "Can't find the end of field delimiter starting at %d", p_src - src);
      goto bails; 
    }
    if (field != NULL) {
      field->name = (char *)malloc((sizeof(char) * (pos - p_src)) + 1);
      ASSERT_ALLOC(field->name);
      strncpy(field->name, p_src, pos - p_src);
      field->name[pos - p_src] = '\0';
      field_idx++; 
    }
    p_src = pos + 1; 
    pos = NULL;

    // Save the field encoding if necessary.
    if (field != NULL) {
      BOOL is_struct;
      BOOL ok;
      int nested;

      for (i = 0, is_struct = *p_src == '{', ok = NO, nested = 0; 
           i < src_len - (p_src - src) && !ok; 
           i++) {

        char c = p_src[i];
        if (is_struct) {
          // Encoding is a structure, we need to match the closing '}',
          // taking into account that other structures can be nested in it.
          if (c == '}') {
            if (nested == 0)
              ok = YES;
            else
              nested--;  
          }
          else if (c == '{' && i > 0)
            nested++;
        }
        else {
          // Easy case, just match another field delimiter, or the end
          // of the encoding.
          if (c == '"' || c == '}')
            i--;
            ok = YES;
        }
      }

      if (ok == NO) {
        DLOG("MDLOSX", "Can't find the field encoding starting at %d", p_src - src);
        goto bails;
      }

      if (is_struct) {
        char buf[MAX_ENCODE_LEN];
        char buf2[MAX_ENCODE_LEN];
   
        strncpy(buf, p_src, MIN(sizeof buf, i));
        buf[MIN(sizeof buf, i)] = '\0';        
     
        if (!undecorate_encoding(buf, buf2, sizeof buf2, NULL, 0, NULL)) {
          DLOG("MDLOSX", "Can't un-decode the field encoding '%s'", buf);
          goto bails;
        }

        len = strlen(buf2); 
        field->encoding = (char *)malloc((sizeof(char) * len) + 1);
        ASSERT_ALLOC(field->encoding);
        strncpy(field->encoding, buf2, len);
        field->encoding[len] = '\0';
      }
      else {
        field->encoding = (char *)malloc((sizeof(char) * i) + 1);
        ASSERT_ALLOC(field->encoding);
        strncpy(field->encoding, p_src, i);
        field->encoding[i] = '\0';
        len = i;
      }

      strncpy(p_dst, field->encoding, len);

      p_src += i;
      p_dst += len;
    }
  }

  *p_dst = '\0';
  if (out_fields_count != NULL)
    *out_fields_count = field_idx;
  return YES;

bails:
  // Free what we allocated! 
  for (i = 0; i < field_idx; i++) {
    free(fields[i].name);
    free(fields[i].encoding);
  }
  return NO;
}

struct bsBoxed *
find_bs_boxed_for_klass (VALUE klass)
{
  VALUE encoding;

  encoding = rb_ivar_get(klass, ivarEncodingID);
  if (NIL_P(encoding))
    return NULL;

  if (TYPE(encoding) != T_STRING)
    return NULL;

  return find_bs_boxed_by_encoding(StringValuePtr(encoding));
}

static size_t 
bs_struct_size(struct bsBoxed *bs_struct)
{
  if (bs_struct->size == 0) {
    unsigned i;
    size_t size;
  
    for (i = 0, size = 0; i < bs_struct->opt.s.field_count; i++)
      size += ocdata_size(to_octype(bs_struct->opt.s.fields[i].encoding),
                          bs_struct->opt.s.fields[i].encoding);           

    bs_struct->size = size; 
  }
  return bs_struct->size;
}

static ffi_type *
bs_boxed_ffi_type(struct bsBoxed *bs_boxed)
{
  if (bs_boxed->ffi_type == NULL) {
    if (bs_boxed->type == bsBoxedStructType) {
      unsigned i;

      bs_boxed->ffi_type = (ffi_type *)malloc(sizeof(ffi_type));
      ASSERT_ALLOC(bs_boxed->ffi_type);
  
      bs_boxed->ffi_type->size = bs_struct_size(bs_boxed);
      bs_boxed->ffi_type->alignment = 0;
      bs_boxed->ffi_type->type = FFI_TYPE_STRUCT;
      bs_boxed->ffi_type->elements = malloc(bs_boxed->opt.s.field_count * sizeof(ffi_type *));
      ASSERT_ALLOC(bs_boxed->ffi_type->elements);
      for (i = 0; i < bs_boxed->opt.s.field_count; i++) {
        int octype;

        octype = to_octype(bs_boxed->opt.s.fields[i].encoding);
        bs_boxed->ffi_type->elements[i] = ffi_type_for_octype(octype);
      }
      bs_boxed->ffi_type->elements[bs_boxed->opt.s.field_count] = NULL;
    }
    else if (bs_boxed->type == bsBoxedOpaqueType) {
      // FIXME we assume that boxed types are pointers, but maybe we should analyze the encoding.
      bs_boxed->ffi_type = &ffi_type_pointer;
    }
  }

  return bs_boxed->ffi_type;
}

static inline struct bsBoxed *
rb_bs_struct_get_bs_struct (VALUE rcv)
{
  struct bsBoxed *bs_struct;

  bs_struct = find_bs_boxed_for_klass(rcv);
  if (bs_struct == NULL) 
    rb_bug("Can't get bridge support structure for the given klass %p", rcv);
  if (bs_struct->type != bsBoxedStructType)
    rb_bug("Invalid bridge support boxed structure type %d", bs_struct->type);

  return bs_struct;
}

static VALUE
rb_bs_struct_new (int argc, VALUE *argv, VALUE rcv)
{
  struct bsBoxed *bs_struct;
  void *data;
  unsigned i;
  unsigned pos;

  bs_struct = rb_bs_struct_get_bs_struct(rcv);
#if 0
  // Probably not necessary.
  if (argc == 1 && TYPE(argv[0]) == T_ARRAY) {
    argc = RARRAY(argv[0])->len;
    argv = RARRAY(argv[0])->ptr;
  }
#endif

  if (argc > 0 && argc != bs_struct->opt.s.field_count)
    rb_raise(rb_eArgError, "wrong number of arguments (%d for %d)", argc, bs_struct->opt.s.field_count);

  bs_struct_size(bs_struct);
  if (bs_struct->size == 0)
    rb_raise(rb_eRuntimeError, "can't instantiate struct '%s' of 0 size", bs_struct->name);

  data = (void *)calloc(1, bs_struct->size);
  ASSERT_ALLOC(data);

  if (argc > 0) {
    for (i = 0, pos = 0; i < bs_struct->opt.s.field_count; i++) {
      int field_octype;

      field_octype = to_octype(bs_struct->opt.s.fields[i].encoding);

      if (!rbobj_to_ocdata(argv[i], field_octype, data + pos, NO))
        rb_raise(rb_eArgError, "Cannot convert arg #%d of type %d to Objective-C", i, field_octype);

      pos += ocdata_size(field_octype, bs_struct->opt.s.fields[i].encoding);
    }
  }
  
  return Data_Wrap_Struct(rcv, NULL, free, data);
}

VALUE 
rb_bs_boxed_new_from_ocdata (struct bsBoxed *bs_boxed, void *ocdata)
{
  void *data;
    
  if (bs_boxed->type == bsBoxedStructType)
    bs_struct_size(bs_boxed);
  if (bs_boxed->size == 0)
    rb_raise(rb_eRuntimeError, "can't instantiate boxed '%s' of size 0", bs_boxed->name);

  data = (void *)malloc(bs_boxed->size);
  ASSERT_ALLOC(data);
  memcpy(data, ocdata, bs_boxed->size);
  
  return Data_Wrap_Struct(bs_boxed->klass, NULL, free, data);
}

static void *
rb_bs_boxed_struct_get_data(VALUE obj, struct bsBoxed *bs_boxed, size_t *size, BOOL *success)
{
  void *  data;
  int     i;
 
  *success = NO;
 
  if (NIL_P(obj))
    return NULL;

  // Given Ruby object is not a OSX::Boxed type, let's just pass it to the upstream initializer.
  // This is to keep backward compatibility.
  if (rb_obj_is_kind_of(obj, cOSXBoxed) != Qtrue) {
    if (TYPE(obj) != T_ARRAY) {
      // Calling #to_a is forbidden, as it would split a Range object.
      VALUE ary = rb_ary_new();
      rb_ary_push(ary, obj);
      obj = ary;
    }
    obj = rb_funcall2(bs_boxed->klass, rb_intern("new"), RARRAY(obj)->len, RARRAY(obj)->ptr);
  }

  if (rb_obj_is_kind_of(obj, cOSXBoxed) != Qtrue)
    return NULL;

  // Resync the ivars if necessary.
  // This is required as some fields may nest another structure, which
  // could have been modified as a copy in the Ruby world.
  for (i = 0; i < bs_boxed->opt.s.field_count; i++) {
    char buf[128];
    ID ivar_id;

    snprintf(buf, sizeof buf, "@%s", bs_boxed->opt.s.fields[i].name);
    ivar_id = rb_intern(buf);
    if (rb_ivar_defined(obj, ivar_id) == Qtrue) {
      VALUE val;

      val = rb_ivar_get(obj, ivar_id);
      snprintf(buf, sizeof buf, "%s=", bs_boxed->opt.s.fields[i].name);
      rb_funcall(obj, rb_intern(buf), 1, val);
    } 
  }
  Data_Get_Struct(obj, void, data);

  *size = bs_struct_size(bs_boxed);
  *success = YES;

  return data;
}

static void *
rb_bs_boxed_opaque_get_data(VALUE obj, struct bsBoxed *bs_boxed, size_t *size, BOOL *success)
{
  void *data;

  if (NIL_P(obj) && bs_boxed_ffi_type(bs_boxed) == &ffi_type_pointer) {
    data = NULL;
  }
  else if (rb_obj_is_kind_of(obj, cOSXBoxed) == Qtrue) {
    Data_Get_Struct(obj, void, data);
  }
  else {
    *success = NO;
    return NULL;
  }

  *size = bs_boxed->size;
  *success = YES;

  return data;
}

void *
rb_bs_boxed_get_data(VALUE obj, int octype, size_t *psize, BOOL *psuccess)
{
  struct bsBoxed *bs_boxed;
  void *data;
  size_t size;
  BOOL success;

  size = 0;
  data = NULL;
  success = NO;  

  bs_boxed = find_bs_boxed_by_octype(octype);
  if (bs_boxed != NULL) {
    switch (bs_boxed->type) {
      case bsBoxedStructType:
        data = rb_bs_boxed_struct_get_data(obj, bs_boxed, &size, &success);
        break;
      
      case bsBoxedOpaqueType:
        data = rb_bs_boxed_opaque_get_data(obj, bs_boxed, &size, &success);
        break;
  
      default:
        rb_bug("invalid bridge support boxed structure type %d", bs_boxed->type);
    }
  }

  if (psuccess != NULL)
    *psuccess = success;
  if (psize != NULL)
    *psize = size;

  return data;
}

static void *
rb_bs_struct_get_field_data(VALUE rcv, int *field_octype_out)
{
  struct bsBoxed *bs_struct;
  char *field;
  unsigned field_len;
  unsigned i;
  unsigned offset;
  void *struct_data;
  void *data;

  *field_octype_out = -1;
  bs_struct = rb_bs_struct_get_bs_struct(CLASS_OF(rcv));

  if (bs_struct->opt.s.field_count == 0)
    rb_raise(rb_eRuntimeError, "Bridge support structure %p doesn't have any field", bs_struct);

  field = rb_id2name(ruby_frame->orig_func);
  field_len = strlen(field);
  if (field[field_len - 1] == '=')
    field_len--;

  Data_Get_Struct(rcv, void, struct_data);
  if (struct_data == NULL)
    rb_raise(rb_eRuntimeError, "Given structure %p has null data", rcv);

  for (i = 0, data = NULL, offset = 0; 
       i < bs_struct->opt.s.field_count; 
       i++) {
     
    int field_octype;

    field_octype = to_octype(bs_struct->opt.s.fields[i].encoding);
    
    if (strncmp(bs_struct->opt.s.fields[i].name, field, field_len) == 0) {
      *field_octype_out = field_octype;
      data = struct_data + offset;
      break;
    }

    offset += ocdata_size(field_octype, bs_struct->opt.s.fields[i].encoding); 
  }

  if (data == NULL)
    rb_raise(rb_eRuntimeError, "Can't retrieve data for field '%s'", field);

  return data;
}

static ID
rb_bs_struct_field_ivar_id(void)
{
  char ivar_name[128];
  int len;

  len = snprintf(ivar_name, sizeof ivar_name, "@%s", rb_id2name(ruby_frame->orig_func));
  if (ivar_name[len - 1] == '=')
    ivar_name[len - 1] = '\0'; 

  return rb_intern(ivar_name);
}

static VALUE
rb_bs_struct_get (VALUE rcv)
{
  ID ivar_id;  
  VALUE result;

  ivar_id = rb_bs_struct_field_ivar_id();
  if (rb_ivar_defined(rcv, ivar_id) == Qfalse) {
    void *data;
    int octype;

    data = rb_bs_struct_get_field_data(rcv, &octype);
    if (!ocdata_to_rbobj(Qnil, octype, data, &result, NO))
      rb_raise(rb_eRuntimeError, "Can't convert data %p of type %d to Ruby", data, octype);

    rb_ivar_set(rcv, ivar_id, result);
  }
  else {
    result = rb_ivar_get(rcv, ivar_id);
  }

  return result; 
}

static VALUE
rb_bs_struct_set (VALUE rcv, VALUE val)
{
  void *data;
  int octype;

  data = rb_bs_struct_get_field_data(rcv, &octype);
  if (!rbobj_to_ocdata(val, octype, data, NO))
    rb_raise(rb_eRuntimeError, "Can't convert Ruby object %p of type %d to Objective-C", val, octype);

  rb_ivar_set(rcv, rb_bs_struct_field_ivar_id(), val);

  return val;
}

static VALUE
rb_bs_struct_to_a (VALUE rcv)
{
  struct bsBoxed *bs_struct;
  unsigned i;
  VALUE ary;

  bs_struct = rb_bs_struct_get_bs_struct(CLASS_OF(rcv));
  ary = rb_ary_new();

  for (i = 0; i < bs_struct->opt.s.field_count; i++) {
    VALUE obj;

    obj = rb_funcall(rcv, rb_intern(bs_struct->opt.s.fields[i].name), 0, NULL);
    rb_ary_push(ary, obj);
  }

  return ary;
}

static VALUE
rb_bs_struct_is_equal (VALUE rcv, VALUE other)
{
  struct bsBoxed *bs_struct;
  unsigned i;

  if (rcv == other)
    return Qtrue;

  if (rb_obj_is_kind_of(other, CLASS_OF(rcv)) == Qfalse)
    return Qfalse;

  bs_struct = rb_bs_struct_get_bs_struct(CLASS_OF(rcv));

  for (i = 0; i < bs_struct->opt.s.field_count; i++) {
    VALUE lval, rval;
    ID msg;

    msg = rb_intern(bs_struct->opt.s.fields[i].name);
    lval = rb_funcall(rcv, msg, 0, NULL);
    rval = rb_funcall(other, msg, 0, NULL);
    
    if (rb_equal(lval, rval) == Qfalse)
      return Qfalse;
  }

  return Qtrue;
}

static VALUE
rb_define_bs_boxed_class (VALUE mOSX, const char *name, const char *encoding)
{
  VALUE klass;

  // FIXME make sure we don't define the same class twice!
  klass = rb_define_class_under(mOSX, name, cOSXBoxed);
  rb_ivar_set(klass, ivarEncodingID, rb_str_new2(encoding)); 
  
  return klass;
}

static struct bsBoxed *
init_bs_boxed (bsBoxedType type, const char *name, const char *encoding, VALUE klass)
{
  struct bsBoxed *bs_boxed;

  bs_boxed = (struct bsBoxed *)malloc(sizeof(struct bsBoxed)); 
  ASSERT_ALLOC(bs_boxed);

  bs_boxed->type = type; 
  bs_boxed->name = (char *)name;
  bs_boxed->size = 0; // lazy determined
  bs_boxed->encoding = strdup(encoding);
  bs_boxed->klass = klass;
  bs_boxed->octype = bs_boxed_octype_idx++;
  bs_boxed->ffi_type = NULL; // lazy determined

  return bs_boxed;
}

static struct bsBoxed *
init_bs_boxed_struct (VALUE mOSX, const char *name, const char *decorated_encoding)
{
  char encoding[MAX_ENCODE_LEN];
  struct bsStructField fields[128];
  int field_count;
  VALUE klass;
  unsigned i;
  struct bsBoxed *bs_boxed;

  // Undecorate the encoding and its fields.
  if (!undecorate_encoding(decorated_encoding, encoding, MAX_ENCODE_LEN, fields, 128, &field_count)) {
    DLOG("MDLOSX", "Can't handle structure '%s' with encoding '%s'", name, decorated_encoding);
    return NULL;
  }

  // Define proxy class.
  klass = rb_define_bs_boxed_class(mOSX, name, encoding);
  if (NIL_P(klass))
    return NULL;
  for (i = 0; i < field_count; i++) {
    char setter[128];

    snprintf(setter, sizeof setter, "%s=", fields[i].name);
    rb_define_method(klass, fields[i].name, rb_bs_struct_get, 0);
    rb_define_method(klass, setter, rb_bs_struct_set, 1);
  }
  rb_define_singleton_method(klass, "new", rb_bs_struct_new, -1);
  rb_define_method(klass, "==", rb_bs_struct_is_equal, 1);
  rb_define_method(klass, "to_a", rb_bs_struct_to_a, 0);

  // Allocate and return bs_boxed entry.
  bs_boxed = init_bs_boxed(bsBoxedStructType, name, encoding, klass);
  bs_boxed->opt.s.fields = (struct bsStructField *)malloc(sizeof(struct bsStructField) * field_count);
  ASSERT_ALLOC(bs_boxed->opt.s.fields);
  memcpy(bs_boxed->opt.s.fields, fields, sizeof(struct bsStructField) * field_count); 
  bs_boxed->opt.s.field_count = field_count;

  return bs_boxed;
}

static struct bsBoxed *
init_bs_boxed_opaque (VALUE mOSX, const char *name, const char *encoding)
{
  VALUE klass;
  struct bsBoxed *bs_boxed;
  
  klass = rb_define_bs_boxed_class(mOSX, name, encoding);
  if (NIL_P(klass))
    return NULL;

  bs_boxed = init_bs_boxed(bsBoxedOpaqueType, name, encoding, klass);
  if (bs_boxed != NULL)
    bs_boxed->size = sizeof(void *);

  return bs_boxed;
}

static Class
bs_cf_type_create_proxy(const char *name)
{
  Class klass, superclass;

  superclass = objc_getClass("NSCFType");
  if (superclass == NULL)
    rb_bug("can't locate ObjC class NSCFType");
#if MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_4
  klass = objc_class_alloc(name, superclass);
  objc_addClass(klass);
#else
  klass = objc_allocateClassPair(superclass, name, 0);
  objc_registerClassPair(klass); 
#endif
  return klass;
}

ffi_type *
ffi_type_for_octype (int octype)
{
  switch (octype) {
    case _C_ID:
    case _C_CLASS:
    case _C_SEL:
    case _C_CHARPTR:
    case _PRIV_C_ID_PTR:
    case _PRIV_C_PTR:
      return &ffi_type_pointer;
#if defined(_C_BOOL)
    case _C_BOOL:
#endif
    case _PRIV_C_BOOL:
    case _C_UCHR:
      return &ffi_type_uchar;
    case _C_CHR:
      return &ffi_type_schar;
    case _C_SHT:
      return &ffi_type_sshort;
    case _C_USHT:
      return &ffi_type_ushort;
    case _C_INT:
      return &ffi_type_sint;
    case _C_UINT:
      return &ffi_type_uint;
    case _C_LNG:
#if defined(_LNG_LNG)
    case _C_LNG_LNG:    /* XXX: not sure */
#endif
      return &ffi_type_slong;
    case _C_ULNG:
#if defined(_ULNG_LNG)
    case _C_ULNG_LNG:   /* XXX: not sure */
#endif
      return &ffi_type_ulong;
    case _C_FLT:
      return &ffi_type_float;
    case _C_DBL:
      return &ffi_type_double;
    case _C_VOID:
      return &ffi_type_void;  

    default:
      if (octype > BS_BOXED_OCTYPE_THRESHOLD) {
        struct bsBoxed *bs_boxed;

        bs_boxed = find_bs_boxed_by_octype(octype);
        if (bs_boxed != NULL)
          return bs_boxed_ffi_type(bs_boxed);
      }
      break;
  }

  NSLog (@"XXX returning ffi type void for unrecognized octype %d", octype);

  return &ffi_type_void;
}

static VALUE
bridge_support_dispatcher (int argc, VALUE *argv, VALUE self)
{
  char *func_name;
  struct bsFunction *func;
  BOOL is_void;
  void *retval;
  VALUE rb_value;
  NSAutoreleasePool *pool;
  VALUE exception; 
  ffi_cif cif;
  void **values;
  unsigned i;

  // lookup structure
  func_name = rb_id2name(ruby_frame->orig_func);
  if (!st_lookup(bsFunctions, (st_data_t)func_name, (st_data_t *)&func))
    rb_fatal("Unrecognized function '%s'", func_name);
  if (func == NULL)
    rb_fatal("Retrieved func structure is invalid");
  is_void = func->retval == _C_VOID;

  // check args count
  if (argc < func->argc) {
    rb_raise(rb_eArgError, "Not enough arguments (expected %s%d, given %d)", func->is_variadic ? "at least " : "", func->argc, argc);
  }
  else if (argc > func->argc && !func->is_variadic) {
    rb_raise(rb_eArgError, "Too much arguments (expected %d, given %d)", func->argc, argc);
  } 

  // mark as current function 
  current_function = func;
  DLOG("MDLOSX", "dispatching function '%s' argc=%d", func_name, func->argc);

  // lookup function symbol
  if (func->sym == NULL) {
    func->sym = dlsym(RTLD_DEFAULT, func_name);
    if (func->sym == NULL)
      rb_fatal("Can't locate function symbol '%s' : %s", func->name, dlerror());
  }

  pool = [[NSAutoreleasePool alloc] init]; 
  exception = Qnil;
  
  // prepare arg types
  if (func->ffi.arg_types == NULL || func->is_variadic) {
    if (func->ffi.arg_types != NULL)
      free(func->ffi.arg_types);
 
    if (argc > 0) {
      func->ffi.arg_types = (ffi_type **)malloc(sizeof(ffi_type *) * (argc + 1)); 
      if (func->ffi.arg_types == NULL)
        rb_fatal("can't allocate memory");
      for (i = 0; i < argc; i++) {
        func->ffi.arg_types[i] = i < func->argc ? ffi_type_for_octype(func->argv[i]) : &ffi_type_pointer;
        DLOG("MDLOSX", "\tset arg #%d to type %p", i, func->ffi.arg_types[i]);
      }
      func->ffi.arg_types[argc] = NULL;
    }
    else {
      func->ffi.arg_types = NULL;
    }
  }
 
  // prepare arg values
  if (argc > 0) {
    values = (void **)malloc(sizeof(void *) * (argc + 1));
    values[argc] = NULL;
    for (i = 0; i < argc; i++) {
      int octype;
      ffi_type *ffi_type;
  
      octype = i < func->argc ? func->argv[i] : _C_ID;
      ffi_type = func->ffi.arg_types[i];
  
      if (ffi_type->size > 0) {
        DLOG("MSLOSX", "\tallocating %d bytes for arg #%d", ffi_type->size, i);
        values[i] = (void *)malloc(ffi_type->size);
        if (values[i] == NULL)
          rb_fatal("Can't allocate memory");
      } 
      rbarg_to_nsarg(argv[i], octype, values[i], func->name, pool, i);  
  
      DLOG("MDLOSX", "\tset arg #%d to value %p", i, values[i]);
    }
  }
  else {
    values = NULL;
  }

  // prepare ret type/value
  if (func->ffi.ret_type == NULL) {
    func->ffi.ret_type = ffi_type_for_octype(func->retval);
    DLOG("MDLOSX", "\tset return to type %p", func->ffi.ret_type);
  }
  if (!is_void) {
    size_t len = ocdata_size(func->retval, ""); 
    DLOG("MDLOSX", "\tallocating %d bytes for storing the result of type %d", len, func->retval);
    retval = alloca(len);
  }
  else
    retval = NULL;
  
  // prepare cif
  if (ffi_prep_cif(&cif, FFI_DEFAULT_ABI, argc, func->ffi.ret_type, func->ffi.arg_types) != FFI_OK)
    rb_fatal("Can't prepare the cif");

  // call function
  @try {
    DLOG("MDLOSX", "\tFFI call function %p", func->sym);
    ffi_call(&cif, FFI_FN(func->sym), (ffi_arg *)retval, values);
  }
  @catch (id oc_exception) {
    DLOG("MDLOSX", "got objc exception '%@' -- forwarding...", oc_exception);
    exception = oc_err_new(func->name, oc_exception);
  }
  
  if (argc > 0) {
    for (i = 0; i < argc; i++)
      free(values[i]);
    free(values);
  } 

  // forward exception if needed
  if (!NIL_P(exception)) {
    [pool release];
    current_function = NULL;
    rb_exc_raise(exception);
    return Qnil;
  }

  if (is_void) {
    rb_value = self;
  }
  else {
    int retval_type;

    DLOG("MDLOSX", "\tresult: %p", retval);
    if ((func->retval == _C_CHR || func->retval == _C_UCHR) && func->predicate) {
      DLOG("MDLOSX", "\tmethod is a predicate, forcing result as a boolean value");
      retval_type = _PRIV_C_BOOL;
    }
    else {
      retval_type = func->retval;
    }

    rb_value = nsresult_to_rbresult(retval_type, (const void *)retval, func->name, pool);
    // retain the new ObjC object, that will be released once the Ruby object is collected
    if (func->retval == _C_ID) {
      if (func->retval_should_be_retained && !OBJCID_DATA_PTR(rb_value)->retained) {
        DLOG("MDLOSX", "\tretaining objc value");
        [OBJCID_ID(rb_value) retain];
      }
      OBJCID_DATA_PTR(rb_value)->retained = YES;
      OBJCID_DATA_PTR(rb_value)->can_be_released = YES;
    }
  }

  [pool release];
  current_function = NULL;

  DLOG("MDLOSX", "dispatch succeeded");

  return rb_value;
}

static VALUE
osx_load_bridge_support_file (VALUE mOSX, VALUE path)
{
  const char *        cpath;
  xmlTextReaderPtr    reader;
  struct bsFunction * func;
  struct bsClass *    klass;
  struct bsMethod *   method;
  unsigned int        i;
  int                 func_args[MAX_ARGS];
  struct bsMethodArg  method_args[MAX_ARGS];
  char *              protocol_name;

  cpath = STR2CSTR(path);

  DLOG("MDLOSX", "Loading bridge support file `%s'", cpath);
  
  reader = xmlNewTextReaderFilename(cpath);
  if (reader == NULL)
    rb_raise(rb_eRuntimeError, "cannot create XML text reader for file at path `%s'", cpath);

  func = NULL;
  klass = NULL;
  method = NULL;
  protocol_name = NULL;

  while (YES) {
    const char *name;
    unsigned int namelen;
    int node_type = -1;
    BOOL eof;
    struct bs_xml_atom *atom;

    do {
      if ((eof = !next_node(reader)))
        break;
      
      node_type = xmlTextReaderNodeType(reader);
    }
    while (node_type != XML_READER_TYPE_ELEMENT && node_type != XML_READER_TYPE_END_ELEMENT);    
    
    if (eof)
      break;

    name = (const char *)xmlTextReaderConstName(reader);
    namelen = strlen(name); 

    if (node_type == XML_READER_TYPE_ELEMENT) {
      atom = bs_xml_element(name, namelen);
      if (atom == NULL)
        continue;
      switch (atom->val) {
      case BS_XML_CONSTANT: { 
        char *  const_name;
        
        const_name = get_attribute_and_check(reader, "name");

        if (st_lookup(bsConstants, (st_data_t)const_name, NULL)) {
          DLOG("MDLOSX", "Constant '%s' already registered, skipping...", const_name);
          free (const_name);
        }
        else {
          char *  const_type;
          int     type;

          const_type = get_attribute_and_check(reader, "type");
          type = to_octype(const_type);
          free (const_type);
          
          if (type == -1) {
            free (const_name);
          }
          else {
            st_insert(bsConstants, (st_data_t)const_name, (st_data_t)type);
          }
        }
      }
      break;

      case BS_XML_ENUM: { 
        char *  enum_name;

        enum_name = get_attribute_and_check(reader, "name");
        if (rb_const_defined(mOSX, rb_intern(enum_name))) {
          DLOG("MDLOSX", "Enum '%s' already registered, skipping...", enum_name);
        }
        else {
          char *  enum_value;        
          VALUE   value;

          enum_value = get_attribute_and_check(reader, "value");
          value = strchr(enum_value, '.') != NULL
            ? rb_float_new(rb_cstr_to_dbl(enum_value, 1))
            : rb_cstr_to_inum(enum_value, 10, 1); 
          CAPITALIZE(enum_name);
          rb_define_const(mOSX, enum_name, value);

          free (enum_value);
        }
        free (enum_name);
      }
      break;

      case BS_XML_STRUCT: {
        char *           struct_decorated_encoding;
        char *           struct_name;
        struct bsBoxed * bs_boxed;

        struct_decorated_encoding = get_attribute_and_check(reader, "encoding");
        struct_name = get_attribute_and_check(reader, "name");

        bs_boxed = init_bs_boxed_struct(mOSX, struct_name, struct_decorated_encoding);
        if (bs_boxed == NULL) {
          DLOG("MDLOSX", "Can't init structure '%s' -- skipping...", struct_decorated_encoding);
        }
        else {
          st_insert(bsBoxed, (st_data_t)bs_boxed->encoding, (st_data_t)bs_boxed);
          st_insert(bsBoxed2, (st_data_t)bs_boxed->octype, (st_data_t)bs_boxed);
        }

        free(struct_decorated_encoding);
      }
      break;

      case BS_XML_OPAQUE: {
        char *  opaque_encoding;

        opaque_encoding = get_attribute_and_check(reader, "encoding");
        if (st_lookup(bsBoxed, (st_data_t)opaque_encoding, NULL)) {
          DLOG("MDLOSX", "Opaque type with encoding '%s' already defined -- skipping...", opaque_encoding);
          free(opaque_encoding);
        }
        else {
          char *            opaque_name;
          struct bsBoxed *  bs_boxed;
  
          opaque_name = get_attribute_and_check(reader, "name");

          bs_boxed = init_bs_boxed_opaque(mOSX, opaque_name, opaque_encoding);
          if (bs_boxed == NULL) {
            DLOG("MDLOSX", "Can't init opaque '%s' -- skipping...", opaque_encoding);
          }
          else {
            st_insert(bsBoxed, (st_data_t)bs_boxed->encoding, (st_data_t)bs_boxed);
            st_insert(bsBoxed2, (st_data_t)bs_boxed->octype, (st_data_t)bs_boxed);
          }
        }      
      }
      break;

      case BS_XML_CFTYPE: {
        char *typeid_encoding;

        typeid_encoding = get_attribute_and_check(reader, "encoding");
        if (st_lookup(bsCFTypes, (st_data_t)typeid_encoding, NULL)) {
          DLOG("MDLOSX", "CFType with encoding '%s' already defined -- skipping...", typeid_encoding);
          free(typeid_encoding);
        }
        else {
          struct bsCFType *bs_cf_type;
          char *type_id;
          char *toll_free;

          bs_cf_type = (struct bsCFType *)malloc(sizeof(struct bsCFType));
          ASSERT_ALLOC(bs_cf_type);

          bs_cf_type->name = get_attribute_and_check(reader, "name");
          bs_cf_type->encoding = typeid_encoding;
          
          type_id = get_attribute(reader, "typeid");
          if (type_id != NULL) {
            bs_cf_type->type_id = atoi(type_id);
            free(type_id);
          }
          else {
            bs_cf_type->type_id = 0; /* not a type */
          }

          bs_cf_type->bridged_class_name = NULL; 
          toll_free = get_attribute(reader, "tollfree");
          if (toll_free != NULL) {
            if (objc_getClass(toll_free) != nil) {
              bs_cf_type->bridged_class_name = toll_free;
            }
            else {
              DLOG("MDLOSX", "Given CFType toll-free class '%s' doesn't exist -- creating a proxy...", toll_free);
              free(toll_free);
            }
          }
          if (bs_cf_type->bridged_class_name == NULL) {
            bs_cf_type_create_proxy(bs_cf_type->name);
            bs_cf_type->bridged_class_name = bs_cf_type->name;
          }
 
          st_insert(bsCFTypes, (st_data_t)typeid_encoding, (st_data_t)bs_cf_type);
          if (bs_cf_type->type_id > 0) 
            st_insert(bsCFTypes2, (st_data_t)bs_cf_type->type_id, (st_data_t)bs_cf_type);
        }
      }
      break;

      case BS_XML_INFORMAL_PROTOCOL: {
        protocol_name = get_attribute_and_check(reader, "name");
      }
      break;

      case BS_XML_FUNCTION: {
        char *  func_name;
        char *  return_type;
        
        func_name = get_attribute_and_check(reader, "name");
        if (st_delete(bsFunctions, (st_data_t *)&func_name, (st_data_t *)&func)) {
          DLOG("MDLOSX", "Re-defining function '%s'", func_name);
          free_bs_function(func);
        }

        func = (struct bsFunction *)calloc(1, sizeof(struct bsFunction));
        ASSERT_ALLOC(func);

        st_insert(bsFunctions, (st_data_t)func_name, (st_data_t)func);
        rb_define_module_function(mOSX, func_name, bridge_support_dispatcher, -1);

        func->name = func_name;
        func->is_variadic = get_boolean_attribute(reader, "variadic", NO);
        func->predicate = get_boolean_attribute(reader, "predicate", YES);

        return_type = get_attribute(reader, "returns");
        if (return_type != NULL) {
          func->retval = to_octype(return_type);
          func->retval_should_be_retained = func->retval == _C_ID ? !get_boolean_attribute(reader, "retval_retained", NO) : YES;
          free(return_type);
        }
        else {
          func->retval = _C_VOID;
        }

        func->argc = 0;
      }
      break;

      case BS_XML_FUNCTION_ARG: {
        if (func == NULL) {
          DLOG("MDLOSX", "Function argument defined outside a function, skipping...");
        }
        else if (func->argc >= MAX_ARGS) {
          DLOG("MDLOSX", "Maximum number of arguments reached for function '%s' (%d), skipping...", func->name, MAX_ARGS);
        }
        else {
          char *  arg_type;
          int     type;
        
          arg_type = get_attribute_and_check(reader, "type");
          type = to_octype(arg_type);
          free (arg_type);
        
          func_args[func->argc++] = type;
        }
      }
      break;

      case BS_XML_CLASS: {
        char *  class_name;
        
        class_name = get_attribute_and_check(reader, "name");
      
        if (st_lookup(bsClasses, (st_data_t)class_name, (st_data_t *)&klass)) {
          free (class_name);
        }
        else {
          klass = (struct bsClass *)malloc(sizeof(struct bsClass));
          ASSERT_ALLOC(klass);
          
          klass->name = class_name;
          klass->class_methods = st_init_strtable();
          klass->instance_methods = st_init_strtable();
          
          st_insert(bsClasses, (st_data_t)class_name, (st_data_t)klass);
        }
      }
      break;

      case BS_XML_METHOD_ARG: {
        if (method == NULL) {
          DLOG("MDLOSX", "Method argument defined outside a method, skipping...");
        }
        else if (method->argc >= MAX_ARGS) {
          DLOG("MDLOSX", "Maximum number of arguments reached for method '%s' (%d), skipping...", method->selector, MAX_ARGS);
        }
        else {
          char *  type_modifier;
          struct bsMethodArg * arg; 
 
          arg = &method_args[method->argc++];

          arg->index = atoi(get_attribute_and_check(reader, "index"));
  
          type_modifier = get_attribute_and_check(reader, "type_modifier");
          if (strcmp(type_modifier, "in") == 0)
            arg->type_modifier = bsTypeModifierIn;
          else if (strcmp(type_modifier, "out") == 0)       
            arg->type_modifier = bsTypeModifierOut;
          else if (strcmp(type_modifier, "inout") == 0)   
            arg->type_modifier = bsTypeModifierInout;
          else {
            DLOG("MDLOSX", "Given type modifier '%s' is invalid, default'ing to 'out'", type_modifier);
            arg->type_modifier = bsTypeModifierOut;
          }
  
          arg->null_accepted = get_boolean_attribute(reader, "null_accepted", YES);
          get_c_ary_type_attribute(reader, &arg->c_ary_type, &arg->c_ary_type_value); 
        }
      }
      break;

      case BS_XML_METHOD_RETVAL: {
        if (method == NULL) {
          DLOG("MDLOSX", "Method return value defined outside a method, skipping...");
        }
        else if (method->retval != NULL) {
          DLOG("MDLOSX", "Method '%s' return value defined more than once, skipping...", method->selector);
        }
        else {
          bsCArrayArgType type;
          int value;

          get_c_ary_type_attribute(reader, &type, &value);

          if (type == bsCArrayArgUndefined) {
            DLOG("MDLOSX", "Method return value defined without a C-array type attribute, skipping...");
          }
          else {
            method->retval = (struct bsMethodRetval *)malloc(sizeof(struct bsMethodRetval));
            ASSERT_ALLOC(method->retval);
            
            method->retval->c_ary_type = type;
            method->retval->c_ary_type_value = value;
          }
        }
      }
      break;

      case BS_XML_METHOD: {
        if (protocol_name != NULL) {
          char * selector;
          BOOL   is_class_method;
          struct st_table *hash;

          selector = get_attribute_and_check(reader, "selector");
          is_class_method = get_boolean_attribute(reader, "class_method", NO);
          hash = is_class_method ? bsInformalProtocolClassMethods : bsInformalProtocolInstanceMethods;         

          if (st_lookup(hash, (st_data_t)selector, NULL)) {
            DLOG("MDLOSX", "Informal protocol method [NSObject %c%s] already defined, skipping...", is_class_method ? '+' : '-', selector);
            free(selector);
          }
          else {
            struct bsInformalProtocolMethod *informal_method;

            informal_method = (struct bsInformalProtocolMethod *)malloc(sizeof(struct bsInformalProtocolMethod));
            ASSERT_ALLOC(informal_method);

            informal_method->selector = selector;
            informal_method->is_class_method = is_class_method;
            informal_method->encoding = get_attribute_and_check(reader, "encoding");
            informal_method->protocol_name = protocol_name;

            st_insert(hash, (st_data_t)selector, (st_data_t)informal_method);            
          }
        }
        else if (klass == NULL) {
          DLOG("MDLOSX", "Method defined outside a class or informal protocol, skipping...");
        }
        else {
          char * selector;
          BOOL is_class_method;
          struct st_table * methods_hash;

          selector = get_attribute_and_check(reader, "selector");
          is_class_method = get_boolean_attribute(reader, "class_method", NO);

          methods_hash = is_class_method ? klass->class_methods : klass->instance_methods;
          if (st_delete(methods_hash, (st_data_t *)&selector, (st_data_t *)&method)) {
            DLOG("MDLOSX", "Re-defining method '%s' in class '%s'", selector, klass->name);
            free_bs_method(method);
          }

          method = (struct bsMethod *)malloc(sizeof(struct bsMethod));
          ASSERT_ALLOC(method);

          st_insert(methods_hash, (st_data_t)selector, (st_data_t)method);
          
          method->selector = selector;
          method->is_class_method = is_class_method;
          method->predicate = get_boolean_attribute(reader, "predicate", YES);
          method->ignore = get_boolean_attribute(reader, "ignore", NO);
          method->suggestion = method->ignore ? get_attribute(reader, "suggestion") : NULL;
          method->argc = 0;
          method->argv = NULL;
          method->retval = NULL;
        }
      }
      break;

      default: break; // Do nothing.
      } // End of switch. 
    }
    else if (node_type == XML_READER_TYPE_END_ELEMENT) {
      atom = bs_xml_element(name, namelen);
      if (atom == NULL)
        continue;
      switch (atom->val) {
      case BS_XML_INFORMAL_PROTOCOL: {
        protocol_name = NULL;
      }
      break;

      case BS_XML_FUNCTION: { 
        BOOL all_args_ok;
  
        all_args_ok = YES;
  
        for (i = 0; i < func->argc; i++) {
          if (func_args[i] == -1) {
            DLOG("MDLOSX", "Function '%s' argument #%d is not recognized, skipping...", func->name, i);
            all_args_ok = NO;
            break;
          }
        }
  
        if (all_args_ok) {
          if (func->argc > 0) {
            size_t len;
  
            len = sizeof(int) * func->argc;
  
            func->argv = (int *)malloc(len);
            ASSERT_ALLOC(func->argv);
            memcpy(func->argv, func_args, len);
          }  
        } 
        else {
          rb_undef_method(mOSX, func->name);
          st_delete(bsFunctions, (st_data_t *)&func->name, NULL);
          free_bs_function(func);
        }

        func = NULL;
      }
      break;

      case BS_XML_METHOD: {
        if (method->argc > 0) {
          size_t len;
    
          len = sizeof(struct bsMethodArg) * method->argc;
          method->argv = (struct bsMethodArg *)malloc(len);
          ASSERT_ALLOC(method->argv);
          memcpy(method->argv, method_args, len);
        }

        method = NULL;
      }
      break;

      case BS_XML_CLASS: {
        klass = NULL;
      }
      break;

      default: break; // Do nothing.
      } // End of switch.
    }
  }

  xmlFreeTextReader(reader);

  return mOSX;
}

#else /* !HAS_LIBXML2 */

static VALUE
osx_load_bridge_support_file (VALUE rcv, VALUE path)
{
  rb_warn("libxml2 is not available, bridge support file `%s' cannot be read", STR2CSTR(path));
  return rcv;
}

#endif

static VALUE
osx_import_c_constant (VALUE self, VALUE sym)
{
  const char *  name;
  char *        real_name;
  int           octype;
  void *        cvalue;
  VALUE         value;
  
  name = rb_id2name(SYM2ID(sym));
  real_name = (char *)name;
  if (!st_lookup(bsConstants, (st_data_t)name, (st_data_t *)&octype)) {
    // Decapitalize the string and try again.
    real_name = strdup(name);
    DECAPITALIZE(real_name);
    if (!st_lookup(bsConstants, (st_data_t)real_name, (st_data_t *)&octype)) {
      free(real_name);
      rb_raise(rb_eLoadError, "C constant '%s' not found", name);
    }
  }

  cvalue = dlsym(RTLD_DEFAULT, real_name);
  value = Qnil;
  if (cvalue != NULL) {
    value = nsresult_to_rbresult(octype, cvalue, "", nil);
    rb_define_const(self, name, value);
    DLOG("MDLOSX", "Imported C constant `%s' with value %p", name, value);
  }

  if (name != real_name)
    free(real_name);
  
  if (cvalue == NULL)
    rb_bug("Can't locate constant symbol '%s' : %s", name, dlerror());
  
  return value;
}

struct bsBoxed *
find_bs_boxed_by_encoding (const char *encoding)
{
  struct bsBoxed *bs_boxed;

  if (!st_lookup(bsBoxed, (st_data_t)encoding, (st_data_t *)&bs_boxed))
    return NULL;

  return bs_boxed;
}

struct bsBoxed *
find_bs_boxed_by_octype (const int octype)
{
  struct bsBoxed *bs_boxed;

  if (!st_lookup(bsBoxed2, (st_data_t)octype, (st_data_t *)&bs_boxed))
    return NULL;

  return bs_boxed;
}

struct bsCFType *
find_bs_cf_type_by_encoding(const char *encoding)
{
  struct bsCFType *cf_type;

  if (!st_lookup(bsCFTypes, (st_data_t)encoding, (st_data_t *)&cf_type))
    return NULL;

  return cf_type;
}

struct bsCFType *
find_bs_cf_type_by_type_id(CFTypeID typeid)
{
  struct bsCFType *cf_type;

  if (!st_lookup(bsCFTypes2, (st_data_t)typeid, (st_data_t *)&cf_type))
    return NULL;

  return cf_type;
}

static struct bsMethod *
__find_bs_method(const char *class_name, const char *selector, BOOL is_class_method)
{
  struct bsClass *bs_class;
  struct bsMethod *method;

  if (!st_lookup(bsClasses, (st_data_t)class_name, (st_data_t *)&bs_class))
    return NULL;

  if (!st_lookup(is_class_method ? bs_class->class_methods : bs_class->instance_methods, (st_data_t)selector, (st_data_t *)&method))
    return NULL;

  return method;
}

struct bsMethod *
find_bs_method(id klass, const char *selector, BOOL is_class_method)
{
  if (klass == nil || selector == NULL)
    return NULL;

  do {
    struct bsMethod *method;

    method = __find_bs_method(((struct objc_class *)klass)->name, selector, is_class_method);
    if (method != NULL)
      return method;
   
    klass = ((struct objc_class *)klass)->super_class;
  }
  while (klass != NULL);

  return NULL;
}

struct bsMethodArg *
find_bs_method_arg_by_index(struct bsMethod *method, unsigned index)
{
  unsigned i;

  if (method == NULL)
    return NULL;

  for (i = 0; i < method->argc; i++)
    if (method->argv[i].index == index)
      return &method->argv[i];  

  return NULL;
}

struct bsMethodArg *
find_bs_method_arg_by_c_array_len_arg_index(struct bsMethod *method, unsigned index)
{
  unsigned i;
  
  if (method == NULL)
    return NULL;

  for (i = 0; i < method->argc; i++)
    if (method->argv[i].c_ary_type == bsCArrayArgDelimitedByArg && method->argv[i].c_ary_type_value == index)
      return &method->argv[i];  

  return NULL;
}

struct bsInformalProtocolMethod *
find_bs_informal_protocol_method(const char *selector, BOOL is_class_method)
{
  struct st_table *hash;
  struct bsInformalProtocolMethod *method;

  hash = is_class_method ? bsInformalProtocolClassMethods : bsInformalProtocolInstanceMethods;

  return st_lookup(hash, (st_data_t)selector, (st_data_t *)&method) ? method : NULL;
}

static int
__inspect_bs_method(char *key, struct bsMethod *value, void *ctx)
{
  unsigned i;

  printf("        %s\n", key);

  if (!value->predicate)
    printf("            not predicate\n");

  if (value->ignore) 
    printf("            ignored (suggestion: '%s')\n", value->suggestion == NULL ? "n/a" : value->suggestion);

  for (i = 0; i < value->argc; i++) {
    struct bsMethodArg *arg;

    arg = &value->argv[i];

    printf("            arg #%d, type modifier '%s'%s", arg->index, arg->type_modifier == bsTypeModifierIn ? "in" : arg->type_modifier == bsTypeModifierOut ? "out" : "inout", arg->null_accepted ? "" : ", NULL is not accepted");
    switch (arg->c_ary_type) {
      case bsCArrayArgUndefined:
        break;
      case bsCArrayArgDelimitedByArg:
        printf(", length is defined by arg #%d value", arg->c_ary_type_value);
        break;
      case bsCArrayArgFixedLength:
        printf(", length is fixed to %d", arg->c_ary_type_value);
        break;
      case bsCArrayArgDelimitedByNull:
        printf(", must be NULL terminated");
        break;
    }
    printf("\n");
  }

  return ST_CONTINUE;
}

static int
__inspect_bs_class(char *key, struct bsClass *value, void *ctx)
{
  printf("%s\n", key);
  printf("    class methods:\n");
  st_foreach(value->class_methods, __inspect_bs_method, 0); 
  printf("    instance methods:\n");
  st_foreach(value->instance_methods, __inspect_bs_method, 0); 

  return ST_CONTINUE;
}

static int
__inspect_bs_function(char *key, struct bsFunction *value, void *ctx)
{
  unsigned i;

  printf("%s\n", key);

  if (value->is_variadic)
    printf("    variadic\n");

  for (i = 0; i < value->argc; i++)
    printf("    arg #%d type %d\n", i, value->argv[i]);

  return ST_CONTINUE;
}

static int
__inspect_bs_constant(char *key, int type, void *ctx)
{
  printf("%s type %d\n", key, type);
  
  return ST_CONTINUE;
}

static VALUE
osx_inspect_metadata (VALUE self)
{
  printf("*** constants ***\n");
  st_foreach(bsConstants, __inspect_bs_constant, 0);

  printf("*** functions ***\n");
  st_foreach(bsFunctions, __inspect_bs_function, 0);

  printf("*** classes ***\n");   
  st_foreach(bsClasses, __inspect_bs_class, 0);
  
  return self;
}

void
initialize_bridge_support (VALUE mOSX)
{
  cOSXBoxed = rb_define_class_under(mOSX, "Boxed", rb_cObject);

  ivarEncodingID = rb_intern("@__encoding__");

  bsBoxed = st_init_strtable();
  bsBoxed2 = st_init_numtable();
  bsCFTypes = st_init_strtable();
  bsCFTypes2 = st_init_numtable();
  bsConstants = st_init_strtable();
  bsFunctions = st_init_strtable();
  bsClasses = st_init_strtable();
  bsInformalProtocolClassMethods = st_init_strtable();
  bsInformalProtocolInstanceMethods = st_init_strtable();

  rb_define_module_function(mOSX, "load_bridge_support_file",
    osx_load_bridge_support_file, 1);
  
  rb_define_module_function(mOSX, "import_c_constant",
    osx_import_c_constant, 1);

  rb_define_module_function(mOSX, "__inspect_metadata__",
    osx_inspect_metadata, 0);        
}
