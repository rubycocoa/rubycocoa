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

void rbarg_to_nsarg(VALUE rbarg, int octype, void* nsarg, const char* fname, id pool, int index);
VALUE nsresult_to_rbresult(int octype, const void* nsresult, const char* fname, id pool);
VALUE oc_err_new (const char* fname, NSException* nsexcp);

static struct st_table *bsFunctions;   // function name -> struct bsFunction
static struct st_table *bsConstants;   // constant name -> type

struct bsFunction *current_function = NULL;

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

static ffi_type *
ffi_ret_type_for_octype (int octype)
{
  switch (octype) {
    case _C_ID:
      return &ffi_type_pointer;
  }
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

  // lookup structure
  func_name = rb_id2name(ruby_frame->orig_func);
  if (!st_lookup(bsFunctions, (st_data_t)func_name, (st_data_t *)&func))
    rb_fatal("Unrecognized function '%s'", func_name);
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

  if (func->argc == 0) {
    // easy, we can call it
    @try {
      if (is_void) {
        ((void (*)(void))func->sym)();
      }
      else {
        retval = ((void *(*)(void))func->sym)();
      } 
    }
    @catch(id oc_exception) {
      exception = oc_err_new(func->name, oc_exception);
    } 
  }
  else if (func->argc > 0) {
    // use libffi 
    ffi_cif cif;
    void **values;
    unsigned i;
    
    // prepare arg values
    values = (void **)malloc(sizeof(void *) * argc);
    for (i = 0; i < argc; i++) {
      void *val;

      rbarg_to_nsarg(argv[i], i < func->argc ? func->argv[i] : _C_ID, &val, "", pool, i);  
      DLOG("MDLOSX", "\tset arg #%d to value %p", i, val);
      values[i] = &val;
    }

    // prepare arg types
    if (func->ffi.arg_types == NULL || func->is_variadic) {
      if (func->ffi.arg_types != NULL)
        free(func->ffi.arg_types);
 
      if (argc > 0) {
        func->ffi.arg_types = (ffi_type **)malloc(sizeof(ffi_type *) * argc); 
        if (func->ffi.arg_types == NULL)
          rb_fatal("can't allocate memory");
        for (i = 0; i < argc; i++) {
          func->ffi.arg_types[i] = i < func->argc ? ffi_ret_type_for_octype(func->argv[i]) : &ffi_type_pointer;
          DLOG("MDLOSX", "\tset arg #%d to type %p", i, func->ffi.arg_types[i]);
        }
      }
      else {
        func->ffi.arg_types = NULL;
      }
    }
  
    // prepare ret type
    if (func->ffi.ret_type == NULL) {
      func->ffi.ret_type = ffi_ret_type_for_octype(func->retval);
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
      exception = oc_err_new(func->name, oc_exception);
    }
    free(values);
  }

  // forward exception if needed
  if (!NIL_P(exception)) {
    DLOG("MDLOSX", "got objc exception, forwarding...");
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
    rb_value = retval == NULL ? Qnil : nsresult_to_rbresult(func->retval, &retval, "", pool);
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
  unsigned int        arg_index;

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
          char *  func_argc;
          char *  is_variadic;
          int     argc;

          func_argc = get_attribute_and_check(reader, "argc");
          argc = MAX(0, atoi(func_argc));
          free(func_argc);

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
          func->argc = argc;
          func->retval = -1;

          if (argc > 0) {
            func->argv = (int *)malloc(sizeof(int) * argc);
            if (func->argv == NULL)
              rb_fatal("can't allocate memory");
            memset(func->argv, -1, argc);
          }

          arg_index = 0;
        }
      }
      else if (strcmp("arg", name) == 0) {
        char *  arg_type;
        int     type;
        
        arg_type = get_attribute_and_check(reader, "type");
        type = bridge_support_type_to_octype(arg_type);
        free (arg_type);
        
        if (type != -1) {
          if (arg_index + 1 > func->argc) {
            DLOG("MDLOSX", "Function '%s' has too many args (expected: %d)", func->name, func->argc);
          }
          else {
            func->argv[arg_index++] = type;
          }
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
    }
    else if (node_type == XML_READER_TYPE_END_ELEMENT) {
      if (strcmp("function", name) == 0) {
        if (func->retval == -1) {
          DLOG("MDLOSX", "Function '%s' return type not defined, skipping...", func->name);
          free_bs_function(func);
        }
        else if (arg_index != func->argc) {
          DLOG("MDLOSX", "Function '%s' has not enough args (expected %d, got %d), skipping...", func->name, func->argc, arg_index);
          free_bs_function(func);
        }
        else {
          st_insert(bsFunctions, (st_data_t)func->name, (st_data_t)func);
          rb_define_module_function(mOSX, func->name, bridge_support_dispatcher, -1);
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

void
initialize_bridge_support (VALUE mOSX)
{
  bsFunctions = st_init_strtable();
  bsConstants = st_init_strtable();

  rb_define_module_function(mOSX, "load_bridge_support_file",
			    osx_load_bridge_support_file, 1);
  
  rb_define_module_function(mOSX, "import_c_constant",
          osx_import_c_constant, 1);
}
