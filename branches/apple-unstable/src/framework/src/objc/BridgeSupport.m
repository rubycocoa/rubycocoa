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
#import <objc/runtime.h>
#import "ocdata_conv.h"
#import "ffi.h"
#import "RBRuntime.h" // for DLOG

static struct st_table *bsFunctions;   // function name -> struct bsFunction
static struct st_table *bsConstants;   // constant name -> type
static struct st_table *bsClasses;     // class name -> struct bsClass

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
  if (strcmp(type, "_C_LNG_LNG") == 0) return _C_LNG_LNG;
  if (strcmp(type, "_C_ULNG_LNG") == 0) return _C_ULNG_LNG;
  if (strcmp(type, "_C_FLT") == 0) return _C_FLT;
  if (strcmp(type, "_C_DBL") == 0) return _C_DBL;
  if (strcmp(type, "_C_BFLD") == 0) return _C_BFLD;
  if (strcmp(type, "_C_BOOL") == 0) return _C_BOOL;
  if (strcmp(type, "_C_VOID") == 0) return _C_VOID;
  if (strcmp(type, "_C_UNDEF") == 0) return _C_UNDEF;
  if (strcmp(type, "_C_PTR") == 0) return _C_PTR;
  if (strcmp(type, "_C_CHARPTR") == 0) return _C_CHARPTR;
  if (strcmp(type, "_C_ATOM") == 0) return _C_ATOM;
  if (strcmp(type, "_C_ARY_B") == 0) return _C_ARY_B;
  if (strcmp(type, "_C_ARY_E") == 0) return _C_ARY_E;
  if (strcmp(type, "_C_UNION_B") == 0) return _C_UNION_B;
  if (strcmp(type, "_C_UNION_E") == 0) return _C_UNION_E;
  if (strcmp(type, "_C_STRUCT_B") == 0) return _C_STRUCT_B;
  if (strcmp(type, "_C_STRUCT_E") == 0) return _C_STRUCT_E;
  if (strcmp(type, "_C_VECTOR") == 0) return _C_VECTOR;
  if (strcmp(type, "_C_CONST") == 0) return _C_CONST;

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
    case _C_BOOL:
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
    case _C_LNG_LNG:    /* XXX: not sure */
      return &ffi_type_slong;
    case _C_ULNG:
    case _C_ULNG_LNG:   /* XXX: not sure */
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
    rb_value = nsresult_to_rbresult(func->retval, &retval, func->name, pool);
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
  unsigned int        i, arg_index;
#define MAX_ARGS 128
  int                 args[MAX_ARGS];

  cpath = STR2CSTR(path);

  DLOG("MDLOSX", "Loading bridge support file `%s'", cpath);
  
  reader = xmlNewTextReaderFilename(cpath);
  if (reader == NULL)
    rb_raise(rb_eRuntimeError, "cannot create XML text reader for file at path `%s'", cpath);

  func = NULL;
  arg_index = 0;

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

#define next_value(reader)                      \
  do {                                          \
    if ((eof = !next_node(reader)))             \
      break;                                    \
  }                                             \
  while (xmlTextReaderNodeType(reader) != 3)
    
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
      else if (strcmp("function", name) == 0) {
        char *  func_name;
        
        func_name = get_attribute_and_check(reader, "name");
      
        if (st_lookup(bsFunctions, (st_data_t)func_name, NULL)) {
          DLOG("MDLOSX", "Function '%s' already registered, skipping...", func_name);
          free (func_name);
        }
        else {
          char *  is_variadic;

          func = (struct bsFunction *)calloc(1, sizeof(struct bsFunction));
          if (func == NULL)
            rb_fatal("can't allocate memory");

          is_variadic = get_attribute(reader, "variadic");
          if (is_variadic != NULL) {
            func->is_variadic = atoi(is_variadic) == 1;
            free(is_variadic);
          }
          else {
            func->is_variadic = NO;
          }

          func->name = func_name;
          func->argc = -1;
          func->retval = -1;

          arg_index = 0;
        }
      }
      else if (strcmp("arg", name) == 0) {
        char *  arg_type;
        int     type;
        
        arg_type = get_attribute_and_check(reader, "type");
        type = bridge_support_type_to_octype(arg_type);
        free (arg_type);
        
        if (arg_index >= MAX_ARGS) {
          DLOG("MDLOSX", "Maximum number of arguments reached (%d), skipping...", MAX_ARGS);
        }
        else {
          args[arg_index++] = type;
        }
      }
      else if (strcmp("return", name) == 0) {
        char *  arg_type;
        int     type;
        
        arg_type = get_attribute_and_check(reader, "type");
        type = bridge_support_type_to_octype(arg_type);
        free (arg_type);

        if (type != -1) {
          if (func->retval != -1) {
            DLOG("MDLOSX", "Function '%s' return type already defined, skipping...", func->name);
          }
          else {
            func->retval = type;
          }
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
          if (klass == NULL)
            rb_fatal("can't allocate memory");
          
          klass->name = class_name;
          klass->class_methods = st_init_strtable();
          klass->instance_methods = st_init_strtable();
          
          st_insert(bsClasses, (st_data_t)class_name, (st_data_t)klass);
        }
      }
      else if (strcmp("method", name) == 0) {
        if (klass == NULL) {
          DLOG("MDLOSX", "Method defined outside a class, skipping...");
        }
        else {
          char * selector;
          char * is_class_method;
          BOOL   class_method;
          struct st_table * methods_hash;
 
          selector = get_attribute_and_check(reader, "selector");
          is_class_method = get_attribute(reader, "class_method");
          if (is_class_method != NULL) {
            class_method = strcmp("true", is_class_method) == 0;
            free(is_class_method);          
          }
          else {
            class_method = NO;
          }

          methods_hash = class_method ? klass->class_methods : klass->instance_methods;
          if (st_lookup(methods_hash, (st_data_t)selector, NULL)) {
            DLOG("MDLOSX", "Method %s already defined in class %s, skipping...", selector, klass->name);
            free(selector);
          }
          else {
            struct bsMethod * method;
            char * returns_char;
           
            method = (struct bsMethod *)malloc(sizeof(struct bsMethod));
            if (method == NULL)
              rb_fatal("can't allocate memory");
 
            returns_char = get_attribute(reader, "returns_char"); 
            method->returns_char = returns_char != NULL && strcmp("true", returns_char) == 0;
            free(returns_char);

            method->selector = selector;
            method->is_class_method = class_method;

            st_insert(methods_hash, (st_data_t)selector, (st_data_t)method);
          }
       }
      }
    }
    else if (node_type == XML_READER_TYPE_END_ELEMENT) {
      if (strcmp("function", name) == 0) {
        if (func->retval == -1) {
          DLOG("MDLOSX", "Function '%s' return type not defined, skipping...", func->name);
          free_bs_function(func);
        }
        else {
          BOOL all_args_ok;

          func->argc = arg_index;
          all_args_ok = YES;

          for (i = 0; i < func->argc; i++) {
            if (args[i] == -1) {
              DLOG("MDLOSX", "Function '%s' argument #%d is not recognized, skipping...", func->name, i);
              all_args_ok = NO;
              break;
            }
          }

          if (all_args_ok) {
            func->argv = (int *)malloc(sizeof(int) * func->argc);
            if (func->argv == NULL)
              rb_fatal("can't allocate memory");
            memcpy(func->argv, args, sizeof(int) * func->argc);

            st_insert(bsFunctions, (st_data_t)func->name, (st_data_t)func);
            rb_define_module_function(mOSX, func->name, bridge_support_dispatcher, -1);
          } 
          else {
            free_bs_function(func);
          }
        }
        
        func = NULL;
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

struct bsMethod *
find_bs_method(const char *class_name, const char *selector, BOOL is_class_method)
{
  struct bsClass *klass;
  struct bsMethod *method;

  if (class_name == NULL || selector == NULL)
    return NULL;

  if (!st_lookup(bsClasses, (st_data_t)class_name, (st_data_t *)&klass))
    return NULL;

  if (!st_lookup(is_class_method ? klass->class_methods : klass->instance_methods, (st_data_t)selector, (st_data_t *)&method))
    return NULL;

  return method;
}

void
initialize_bridge_support (VALUE mOSX)
{
  bsFunctions = st_init_strtable();
  bsConstants = st_init_strtable();
  bsClasses = st_init_strtable();

  rb_define_module_function(mOSX, "load_bridge_support_file",
			    osx_load_bridge_support_file, 1);
  
  rb_define_module_function(mOSX, "import_c_constant",
          osx_import_c_constant, 1);

  initialize_boxed_ffi_types();
}
