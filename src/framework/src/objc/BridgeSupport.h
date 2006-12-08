/*
 *  BridgeSupport.h
 *  RubyCocoa
 *
 *  Created by Laurent Sansonetti on 8/29/06.
 *  Copyright 2006 Apple Computer. All rights reserved.
 *
 */

/* Ruby and FFI use both autoconf, and some variables collide. */
#if defined(PACKAGE_BUGREPORT)
# undef PACKAGE_BUGREPORT
#endif

#if defined(PACKAGE_NAME) 
# undef PACKAGE_NAME
#endif

#if defined(PACKAGE_STRING)
# undef PACKAGE_STRING
#endif

#if defined(PACKAGE_TARNAME)
# undef PACKAGE_TARNAME
#endif

#if defined(PACKAGE_VERSION)
# undef PACKAGE_VERSION
#endif

#import "ffi.h"

struct bsFunction {
  char *  name;
  int     argc;
  int *   argv;
  int     retval;
  BOOL    retval_should_be_retained;
  BOOL    returns_char;
  void *  sym;
  BOOL    is_variadic;
  struct {
    ffi_type ** arg_types;
    ffi_type *  ret_type;
  } ffi;
};

struct bsClass {
  char *              name;
  struct st_table *   class_methods;
  struct st_table *   instance_methods;
};

typedef enum {
    bsTypeModifierIn,
    bsTypeModifierOut,
    bsTypeModifierInout
} bsTypeModifier;

typedef enum {
    bsCArrayArgUndefined,
    bsCArrayArgDelimitedByArg,
    bsCArrayArgFixedLength,
    bsCArrayArgDelimitedByNull
} bsCArrayArgType;

struct bsMethodArg {
  unsigned          index;
  bsTypeModifier    type_modifier;
  bsCArrayArgType   c_ary_type;
  int               c_ary_type_value;  // not set if arg_type is bsCArrayArgUndefined
  BOOL              null_accepted;
};

struct bsMethodRetval {
  bsCArrayArgType   c_ary_type;
  int               c_ary_type_value;  // not set if arg_type is bsCArrayArgUndefined
};

struct bsMethod {
  char *  selector;
  BOOL    is_class_method;
  BOOL    returns_char;
  BOOL    ignore;
  char *  suggestion;   // only if ignore is true
  int     argc;
#define MAX_ARGS 128
  struct bsMethodArg *      argv;
  struct bsMethodRetval *   retval; // can be NULL
};

struct bsInformalProtocolMethod {
  char *  selector;
  BOOL    is_class_method;
  char *  encoding;
  char *  protocol_name;
};

#define BS_BOXED_OCTYPE_THRESHOLD  1300

struct bsStructField {
  char *    name;
  char *    encoding;
};

struct bsStruct {
  struct bsStructField *fields;
  int field_count;
};

struct bsOpaque {
  // Nothing there yet.
};

typedef enum {
    bsBoxedStructType,
    bsBoxedOpaqueType
} bsBoxedType;

struct bsBoxed {
  bsBoxedType   type;
  char *        name;
  char *        encoding;
  size_t        size;
  int           octype;
  ffi_type *    ffi_type;
  VALUE         klass;
  union {
    struct bsStruct s;
    struct bsOpaque o;
  } opt;
};

struct bsCFType {
  char *    name;
  char *    encoding;
  char *    bridged_class_name;
  CFTypeID  type_id;
};

extern struct bsFunction *current_function;

ffi_type *ffi_type_for_octype(int octype);

VALUE objboxed_s_class(void);
struct bsBoxed *find_bs_boxed_by_encoding(const char *encoding);
struct bsBoxed *find_bs_boxed_by_octype(const int octype);
struct bsBoxed *find_bs_boxed_for_klass (VALUE klass);
VALUE rb_bs_boxed_new_from_ocdata(struct bsBoxed *bs_boxed, void *ocdata);
void *rb_bs_boxed_get_data(VALUE obj, int octype, size_t *size, BOOL *success);

struct bsCFType *find_bs_cf_type_by_encoding(const char *encoding);
struct bsCFType *find_bs_cf_type_by_type_id(CFTypeID type_id);

struct bsMethod *find_bs_method(id klass, const char *selector, BOOL is_class_method);
struct bsMethodArg *find_bs_method_arg_by_index(struct bsMethod *method, unsigned index);
struct bsMethodArg *find_bs_method_arg_by_c_array_len_arg_index(struct bsMethod *method, unsigned index);

struct bsInformalProtocolMethod *find_bs_informal_protocol_method(const char *selector, BOOL is_class_method);

void initialize_bridge_support(VALUE mOSX);

/* On MacOS X, +signatureWithObjCTypes: is a method of NSMethodSignature,
 * but that method is not present in the header files. We add the definition
 * here to avoid warnings.
 *
 * XXX: We use an undocumented API, but we also don't have much choice: we
 * must create the things and this is the only way to do it...
 */
@interface NSMethodSignature (WarningKiller)
+ (id) signatureWithObjCTypes:(const char*)types;
@end
