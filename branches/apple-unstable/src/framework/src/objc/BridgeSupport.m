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
#import "ocdata_conv.h"
#import "ffi.h"
#import "RBRuntime.h" // for DLOG

static struct st_table *bsFunctions;   // function name -> struct bsFunction
static struct st_table *bsConstants;   // constant name -> type
static struct st_table *bsClasses;     // class name -> struct bsClass
static struct st_table *bsInformalProtocolClassMethods;         // selector -> struct bsInformalProtocolMethod
static struct st_table *bsInformalProtocolInstanceMethods;      // selector -> struct bsInformalProtocolMethod

struct bsFunction *current_function = NULL;

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
  if (!rbobj_to_ocdata(rbarg, octype, nsarg)) {
    if (pool) [pool release];
    rb_raise(_ocdataconv_err_class(), "%s - arg #%d cannot convert to nsobj.", fname, index);
  }
}

VALUE
nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool)
{
  VALUE rbresult;
  if (!ocdata_to_rbobj(Qnil, octype, nsresult, &rbresult)) {
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

static int
bridge_support_type_to_octype (const char *type)
{
  if (strcmp(type, "_C_ID") == 0) return _C_ID;
  if (strcmp(type, "_C_CLASS") == 0) return _C_CLASS;
  if (strcmp(type, "_C_SEL") == 0) return _C_SEL;
  if (strcmp(type, "_C_CHR") == 0) return _C_CHR;
  if (strcmp(type, "_C_UCHR") == 0) return _C_UCHR;
  if (strcmp(type, "_C_SHT") == 0) return _C_SHT;
  if (strcmp(type, "_C_USHT") == 0) return _C_USHT;
  if (strcmp(type, "_C_INT") == 0) return _C_INT;
  if (strcmp(type, "_C_UINT") == 0) return _C_UINT;
  if (strcmp(type, "_C_LNG") == 0) return _C_LNG;
  if (strcmp(type, "_C_ULNG") == 0) return _C_ULNG;
#if defined(_C_LNG_LNG)
  if (strcmp(type, "_C_LNG_LNG") == 0) return _C_LNG_LNG;
#endif
#if defined(_C_ULNG_LNG)
  if (strcmp(type, "_C_ULNG_LNG") == 0) return _C_ULNG_LNG;
#endif
  if (strcmp(type, "_C_FLT") == 0) return _C_FLT;
  if (strcmp(type, "_C_DBL") == 0) return _C_DBL;
  if (strcmp(type, "_C_BFLD") == 0) return _C_BFLD;
#if defined(_C_BOOL)
  if (strcmp(type, "_C_BOOL") == 0) return _C_BOOL;
#endif
  if (strcmp(type, "_C_VOID") == 0) return _C_VOID;
  if (strcmp(type, "_C_UNDEF") == 0) return _C_UNDEF;
  if (strcmp(type, "_C_PTR") == 0) return _C_PTR;
  if (strcmp(type, "_C_CHARPTR") == 0) return _C_CHARPTR;
#if defined(_C_ATOM)
  if (strcmp(type, "_C_ATOM") == 0) return _C_ATOM;
#endif
  if (strcmp(type, "_C_ARY_B") == 0) return _C_ARY_B;
  if (strcmp(type, "_C_ARY_E") == 0) return _C_ARY_E;
  if (strcmp(type, "_C_UNION_B") == 0) return _C_UNION_B;
  if (strcmp(type, "_C_UNION_E") == 0) return _C_UNION_E;
  if (strcmp(type, "_C_STRUCT_B") == 0) return _C_STRUCT_B;
  if (strcmp(type, "_C_STRUCT_E") == 0) return _C_STRUCT_E;
#if defined(_C_VECTOR)
  if (strcmp(type, "_C_VECTOR") == 0) return _C_VECTOR;
#endif
#if defined(_C_CONST)
  if (strcmp(type, "_C_CONST") == 0) return _C_CONST;
#endif

  if (strcmp(type, "_PRIV_C_BOOL") == 0) return _PRIV_C_BOOL;
  if (strcmp(type, "_PRIV_C_NSRECT") == 0) return _PRIV_C_NSRECT;
  if (strcmp(type, "_PRIV_C_NSPOINT") == 0) return _PRIV_C_NSPOINT;
  if (strcmp(type, "_PRIV_C_NSSIZE") == 0) return _PRIV_C_NSSIZE;
  if (strcmp(type, "_PRIV_C_NSRANGE") == 0) return _PRIV_C_NSRANGE;
  if (strcmp(type, "_PRIV_C_PTR") == 0) return _PRIV_C_PTR;
  if (strcmp(type, "_PRIV_C_ID_PTR") == 0) return _PRIV_C_ID_PTR;

  DLOG("MDLOSX", "Unrecognized type '%s'", type);

  return -1;
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

static ffi_type ffi_type_nspoint;
static ffi_type ffi_type_nssize;
static ffi_type ffi_type_nsrect;
static ffi_type ffi_type_nsrange;

static void
initialize_boxed_ffi_types (void)
{
  // TODO: we should not need this with boxed metadata types
  ffi_type_nspoint.size = sizeof(NSPoint); 
  ffi_type_nspoint.alignment = 0; 
  ffi_type_nspoint.type = FFI_TYPE_STRUCT;
  ffi_type_nspoint.elements = malloc(3 * sizeof(ffi_type*));
  ffi_type_nspoint.elements[0] = &ffi_type_float;
  ffi_type_nspoint.elements[1] = &ffi_type_float;
  ffi_type_nspoint.elements[2] = NULL;

  ffi_type_nssize.size = sizeof(NSSize);
  ffi_type_nssize.alignment = 0;
  ffi_type_nssize.type = FFI_TYPE_STRUCT;
  ffi_type_nssize.elements = malloc(3 * sizeof(ffi_type*));
  ffi_type_nssize.elements[0] = &ffi_type_float;
  ffi_type_nssize.elements[1] = &ffi_type_float;
  ffi_type_nssize.elements[2] = NULL;

  ffi_type_nsrect.size = sizeof(NSRect);
  ffi_type_nsrect.alignment = 0;
  ffi_type_nsrect.type = FFI_TYPE_STRUCT;
  ffi_type_nsrect.elements = malloc(3 * sizeof(ffi_type*));
  ffi_type_nsrect.elements[0] = &ffi_type_nspoint;
  ffi_type_nsrect.elements[1] = &ffi_type_nssize;
  ffi_type_nsrect.elements[2] = NULL;
  
  ffi_type_nsrange.size = sizeof(NSRange);
  ffi_type_nsrange.alignment = 0;
  ffi_type_nsrange.type = FFI_TYPE_STRUCT;
  ffi_type_nsrange.elements = malloc(3 * sizeof(ffi_type*));
  ffi_type_nsrange.elements[0] = &ffi_type_uint;
  ffi_type_nsrange.elements[1] = &ffi_type_uint;
  ffi_type_nsrange.elements[2] = NULL;
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

    // TODO: we should not need this with boxed metadata types
    case _PRIV_C_NSPOINT:
      return &ffi_type_nspoint;
    case _PRIV_C_NSSIZE:
      return &ffi_type_nssize;
    case _PRIV_C_NSRECT:
      return &ffi_type_nsrect;
    case _PRIV_C_NSRANGE:
      return &ffi_type_nsrange;
    case _C_VOID:
      return &ffi_type_void;  
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

  retval = NULL;
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

  // prepare ret type
  if (func->ffi.ret_type == NULL) {
    func->ffi.ret_type = ffi_type_for_octype(func->retval);
    DLOG("MDLOSX", "\tset return to type %p", func->ffi.ret_type);
  }
  
  // prepare cif
  if (ffi_prep_cif(&cif, FFI_DEFAULT_ABI, argc, func->ffi.ret_type, func->ffi.arg_types) != FFI_OK)
    rb_fatal("Can't prepare the cif");

  // call function
  @try {
    DLOG("MDLOSX", "\tFFI call function %p", func->sym);
    ffi_call(&cif, FFI_FN(func->sym), (ffi_arg *)&retval, values);
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
    DLOG("MDLOSX", "\tresult: %p", retval);
    rb_value = nsresult_to_rbresult(func->retval, (const void *)&retval, func->name, pool);
    // retain the new ObjC object, that will be released once the Ruby object is collected
    if (func->retval == _C_ID)
      [(id)retval retain];
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

#define ASSERT_ALLOC(x) do { if (x == NULL) rb_fatal("can't allocate memory"); } while (0)

  while (YES) {
    const char *name;
    int node_type = -1;
    BOOL eof;

    do {
      if ((eof = !next_node(reader)))
        break;
      
      node_type = xmlTextReaderNodeType(reader);
    }
    while (node_type != XML_READER_TYPE_ELEMENT && node_type != XML_READER_TYPE_END_ELEMENT);    
    
    if (eof)
      break;

    name = (const char *)xmlTextReaderConstName(reader);
 
    if (node_type == XML_READER_TYPE_ELEMENT) {    
      if (strcmp("constant", name) == 0) {
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
          type = bridge_support_type_to_octype(const_type);
          free (const_type);
          
          if (type == -1) {
            free (const_name);
          }
          else {
            st_insert(bsConstants, (st_data_t)const_name, (st_data_t)type);
          }
        }
      }
      else if (strcmp("enum", name) == 0) {
        char *  enum_name;
        char *  enum_value;        
        VALUE   value;

        enum_name = get_attribute_and_check(reader, "name");
        enum_value = get_attribute_and_check(reader, "value");

        value = rb_cstr_to_inum(enum_value, 16, 1);
        rb_define_const(mOSX, enum_name, value);

        free (enum_name);
        free (enum_value);
      }
      else if (strcmp("informal_protocol", name) == 0) {
        protocol_name = get_attribute_and_check(reader, "name");
      }
      else if (strcmp("function", name) == 0) {
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

        return_type = get_attribute(reader, "returns");
        if (return_type != NULL) {
          func->retval = bridge_support_type_to_octype(return_type);
          free(return_type);
        }
        else {
          func->retval = _C_VOID;
        }

        func->argc = 0;
      }
      else if (strcmp("function_arg", name) == 0) {
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
          type = bridge_support_type_to_octype(arg_type);
          free (arg_type);
        
          func_args[func->argc++] = type;
        }
      }
      else if (strcmp("class", name) == 0) {
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
      else if (strcmp("method_arg", name) == 0) {
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
      else if (strcmp("method_retval", name) == 0) {
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
      else if (strcmp("method", name) == 0) {
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
          method->returns_char = get_boolean_attribute(reader, "returns_char", NO);
          method->ignore = get_boolean_attribute(reader, "ignore", NO);
          method->suggestion = method->ignore ? get_attribute(reader, "suggestion") : NULL;
          method->argc = 0;
          method->argv = NULL;
          method->retval = NULL;
       }
      }
    }
    else if (node_type == XML_READER_TYPE_END_ELEMENT) {
      if (strcmp("informal_protocol", name) == 0) {
        protocol_name = NULL;
      } 
      else if (strcmp("function", name) == 0) {
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
      else if (strcmp("method", name) == 0) {
        if (method->argc > 0) {
          size_t len;
    
          len = sizeof(struct bsMethodArg) * method->argc;
          method->argv = (struct bsMethodArg *)malloc(len);
          ASSERT_ALLOC(method->argv);
          memcpy(method->argv, method_args, len);
        }

        method = NULL;
      }
      else if (strcmp("class", name) == 0) {
        klass = NULL;
      }
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
  int           octype;
  void *        cvalue;
  VALUE         value;
  
  name = rb_id2name(SYM2ID(sym));
  if (!st_lookup(bsConstants, (st_data_t)name, (st_data_t *)&octype))
    rb_raise(rb_eLoadError, "C constant '%s' not found", name);

  cvalue = dlsym(RTLD_DEFAULT, name);
  if (cvalue == NULL)
    rb_fatal("Can't locate constant symbol '%s' : %s", name, dlerror());

  value = nsresult_to_rbresult(octype, cvalue, "", nil);
  
  rb_define_const(self, name, value);
  
  return value;
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

  if (value->returns_char)
    printf("            returns char\n");

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

  initialize_boxed_ffi_types();
}
