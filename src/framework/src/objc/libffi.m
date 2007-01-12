//
//  libffi.m
//  RubyCocoa
//
//  Created by Laurent Sansonetti on 1/12/07.
//  Copyright 2007 Apple Computer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "libffi.h"
#import "ocdata_conv.h"
#import "BridgeSupport.h"
#import "ocexception.h"
#import "cls_objcid.h"
#import "cls_objcptr.h"
#import "RBRuntime.h" // for DLOG

#define FFI_LOG(fmt, args...) DLOG("LIBFFI", fmt, ##args)

ffi_type *
bs_boxed_ffi_type(struct bsBoxed *bs_boxed)
{
  if (bs_boxed->ffi_type == NULL) {
    if (bs_boxed->type == bsBoxedStructType) {
      unsigned i;

      bs_boxed->ffi_type = (ffi_type *)malloc(sizeof(ffi_type));
      ASSERT_ALLOC(bs_boxed->ffi_type);
  
      bs_boxed->ffi_type->size = 0; // IMPORTANT: we need to leave this to 0 and not set the real size
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
      return sizeof(int) == sizeof(long) ? &ffi_type_sint : &ffi_type_slong;
#if defined(_C_LNG_LNG)
    case _C_LNG_LNG: 
      return &ffi_type_sint64;
#endif
    case _C_ULNG:
      return sizeof(unsigned int) == sizeof(unsigned long) ? &ffi_type_uint : &ffi_type_ulong;
#if defined(_C_ULNG_LNG)
    case _C_ULNG_LNG: 
      return &ffi_type_uint64;
#endif
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

VALUE
rb_ffi_dispatch (
  struct bsCallEntry *call_entry, 
  char **arg_octypes, 
  int expected_argc, 
  int given_argc, 
  int argc_delta, 
  VALUE *argv, 
  ffi_type **arg_types, 
  void **arg_values, 
  int ret_octype, 
  void *func_sym, 
  void (*retain_if_necessary)(VALUE arg, BOOL retval, void *ctx), 
  void *retain_if_necessary_ctx, 
  VALUE *result)
{
  int         length_args[MAX_ARGS];
  unsigned    length_args_count;
  unsigned    pointers_args_count;
  unsigned    skipped;
  int         i;
  ffi_type *  ret_type;
  void *      retval;
  ffi_cif     cif;
  VALUE       exception;

#define ARG_OCTYPESTR(i) (arg_octypes != NULL ? arg_octypes[i] : call_entry->argv[i].octypestr) 

  FFI_LOG("argc expected %d given %d delta %d", expected_argc, given_argc, argc_delta);

  // Check arguments count.
  length_args_count = pointers_args_count = 0;
  if (call_entry != NULL) {
    for (i = 0; i < call_entry->argc; i++) {
      struct bsArg *arg;
  
      arg = &call_entry->argv[i];
      // The given argument is a C array with a length determined by the value of another argument, like:
      //   [NSArray + arrayWithObjects: length:]
      // If 'in' or 'inout, the 'length' argument is not necessary (but the 'array' is).        
      // If 'out', the 'array' argument is not necessary (but the 'length' is).
      if (arg->c_ary_type == bsCArrayArgDelimitedByArg) {
        unsigned j;
        BOOL already;
        
        if (expected_argc == given_argc)
          rb_warn("argument #%d is no longer necessary (will be ignored)", arg->c_ary_type_value);
  
        // Some methods may accept multiple 'array' 'in' arguments that refer to the same 'length' argument, like:
        //   [NSDictionary + dictionaryWithObjects: forKeys: count:]
        for (j = 0, already = NO; j < length_args_count; j++) {
          if (length_args[j] == arg->c_ary_type_value) {
            already = YES;
            break;
          }
        }
        if (already)
          continue;
        
        length_args[length_args_count++] = arg->c_ary_type_value;
      }
    }
  }

  if (expected_argc - length_args_count != given_argc) {
    for (i = given_argc; i < expected_argc; i++) {
      char *type = ARG_OCTYPESTR(i);
      if (*type == _C_CONST)
        type++;
      if (*type == _C_PTR)
        pointers_args_count++;
    }
    if (pointers_args_count + given_argc != expected_argc)
      return rb_err_new(rb_eArgError, "wrong number of argument(s) (expected %d, got %d)", expected_argc, given_argc);
  }

  for (i = skipped = 0; i < expected_argc; i++) {
    // C-array-length-like argument, which should be already defined
    // (at the same time than the C-array-like argument), unless it's
    // returned by reference.
    if (find_bs_arg_by_c_array_len_arg_index(call_entry, i) != NULL
        && *ARG_OCTYPESTR(i) != _C_PTR) {
      skipped++;
    } 
    // Omitted pointer.
    else if (i - skipped >= given_argc) {
      FFI_LOG("omitted pointer[%d]", i);
      arg_values[i + argc_delta] = &arg_values[i + argc_delta];
      arg_types[i + argc_delta] = &ffi_type_pointer;
    }
    // Regular argument.
    else {
      VALUE arg;
      const char *octype_str;
      int octype;
      void *value;
      struct bsArg *bs_arg;
      BOOL is_c_array;
      int len;

      arg = argv[i - skipped];
      octype_str = ARG_OCTYPESTR(i);
      octype = to_octype(octype_str);
      bs_arg = find_bs_arg_by_index(call_entry, i, expected_argc);

      if (bs_arg != NULL) {
        if (!bs_arg->null_accepted && NIL_P(arg))
          return rb_err_new(rb_eArgError, "Argument #%d cannot be nil", i);
        is_c_array = bs_arg->c_ary_type != bsCArrayArgUndefined;
      }
      else {
        is_c_array = NO;
      }

      // C-array-like argument.
      if (is_c_array) {
        const char * ptype;

        ptype = octype_str;
        if (*ptype == 'r')
          ptype++;
        if (*ptype != '^')
          return rb_err_new(rb_eRuntimeError, "Internal error: argument #%d is not a defined as a pointer in the runtime or it is described as such in the metadata", i);
        ptype++;

        if (TYPE(arg) == T_STRING)
          len = RSTRING(arg)->len;
        else if (TYPE(arg) == T_ARRAY)
          len = RARRAY(arg)->len;
        else if (rb_obj_is_kind_of(arg, objcptr_s_class()))
          len = objcptr_allocated_size(arg); 
        else {
          return rb_err_new(rb_eArgError, "Expected either String/Array/ObjcPtr for argument #%d (but got %s).", i, rb_obj_classname(arg));
        }

        if (bs_arg->c_ary_type == bsCArrayArgFixedLength) {
          int expected_len = bs_arg->c_ary_type_value * ocdata_size(to_octype(ptype), ptype);
          if (expected_len != len)
            return rb_err_new(rb_eArgError, "Argument #%d has an invalid length (expected %d, got %d)", i, expected_len, len); 
        }
        else if (bs_arg->c_ary_type == bsCArrayArgDelimitedByArg) {
          int * prev_len;
        
          prev_len = arg_values[bs_arg->c_ary_type_value + argc_delta];
          if (prev_len != NULL && *prev_len != len)
            return rb_err_new(rb_eArgError, "Incorrect array length of argument #%d (expected %d, got %d)", i, *prev_len, len);
          
          FFI_LOG("arg[%d] (%p) : %s (defined as a C array delimited by arg #%d in the metadata)", i, arg, octype_str, bs_arg->c_ary_type_value);
        }
        value = OCDATA_ALLOCA(octype, octype_str);
        if (len > 0)
          *(void **) value = alloca(ocdata_size(to_octype(ptype), ptype) * len);
      }
      // Regular argument. 
      else {
        FFI_LOG("arg[%d] (%p) : %s", i, arg, octype_str);
        len = 0;
        value = OCDATA_ALLOCA(octype, octype_str);
      }

      if (!rbobj_to_ocdata(arg, octype, value, NO))
        return rb_err_new(ocdataconv_err_class(), "Cannot convert the argument #%d as '%s' to Objective-C", i, octype_str); 
      
      arg_types[i + argc_delta] = ffi_type_for_octype(octype);
      arg_values[i + argc_delta] = value;

      if (is_c_array && bs_arg->c_ary_type == bsCArrayArgDelimitedByArg) {
        int * plen;

        FFI_LOG("arg[%d] defined as the array length (%d)\n", bs_arg->c_ary_type_value, len);
        plen = (int *) alloca(sizeof(int));
        *plen = len;
        arg_values[bs_arg->c_ary_type_value + argc_delta] = plen;
        arg_types[bs_arg->c_ary_type_value + argc_delta] = &ffi_type_uint;
      }
    }
  }

  // Prepare return type/val.
  ret_type = ffi_type_for_octype(ret_octype);
  if (ret_octype != _C_VOID) {
    size_t ret_len = ocdata_size(ret_octype, "");
    FFI_LOG("allocated %ld bytes for the result", ret_len);
    retval = alloca(ret_len);
  }

  // Prepare cif.
  if (ffi_prep_cif(&cif, FFI_DEFAULT_ABI, expected_argc + argc_delta, ret_type, arg_types) != FFI_OK)
    rb_fatal("Can't prepare the cif");

  // Call function.
  exception = Qnil;
  @try {
    FFI_LOG("ffi_call %p with %d args", func_sym, expected_argc + argc_delta);
    ffi_call(&cif, FFI_FN(func_sym), (ffi_arg *)retval, arg_values);
    FFI_LOG("ffi_call done");
  }
  @catch (id oc_exception) {
    FFI_LOG("got objc exception '%@' -- forwarding...", oc_exception);
    exception = oc_err_new(oc_exception);
  }

  // Return exception if catched.
  if (!NIL_P(exception))
    return exception;

  // Get result as argument.
  for (i = 0; i < expected_argc; i++) {
    VALUE arg;

    arg = (i < given_argc) ? argv[i] : Qnil;
    if (arg == Qnil)
      continue;
    if (to_octype(ARG_OCTYPESTR(i)) != _PRIV_C_ID_PTR)
      continue;
    if (rb_obj_is_kind_of(arg, objid_s_class()) != Qtrue)
      continue;
    FFI_LOG("got passed-by-reference argument %d", i);
    (*retain_if_necessary)(arg, NO, retain_if_necessary_ctx);
  }

  // Get result
  if (ret_octype != _C_VOID) {
    FFI_LOG("getting return value (%p of type '%c')", retval, (char)ret_octype);

    if (call_entry != NULL && call_entry->retval != NULL && call_entry->retval->octype != -1 && call_entry->retval->octype != ret_octype) {
      FFI_LOG("coercing result from octype %c to octype %c", (char)ret_octype, (char)call_entry->retval->octype);
      ret_octype = call_entry->retval->octype;
    }

    if (!ocdata_to_rbobj(Qnil, ret_octype, retval, result, YES))
      return rb_err_new(ocdataconv_err_class(), "Cannot convert the result as '%c' to Ruby", (char)ret_octype); 
    
    FFI_LOG("got return value");
    (*retain_if_necessary)(*result, YES, retain_if_necessary_ctx);
  } 
  else {
    *result = Qnil;
  }

  // Get omitted pointers result, and pack them with the result in an array.
  if (pointers_args_count > 0) {
    VALUE retval_ary;

    retval_ary = rb_ary_new();
    if (ret_octype != _C_VOID) { 
      // Don't test if *result is nil, as nil may have been returned!
      rb_ary_push(retval_ary, *result);
    }

    for (i = expected_argc - pointers_args_count; i < expected_argc; i++) {
      void *value;

      value = arg_values[i + argc_delta];
      if (value != NULL) {
        VALUE rbval;
        const char *octype_str;
        int octype;
        struct bsArg *bs_arg;

        octype_str = ARG_OCTYPESTR(i);
        if (octype_str[0] == _C_PTR)
          octype_str++;
        FFI_LOG("got omitted pointer[%d] : %s (%p)", i, octype_str, value);
        octype = to_octype(octype_str);        
        rbval = Qnil;

        if (octype == _PRIV_C_PTR 
            && (bs_arg = find_bs_arg_by_index(call_entry, i, expected_argc)) != NULL) {

          switch (bs_arg->c_ary_type) {
            case bsCArrayArgDelimitedByArg:
              {
                void *length_value = arg_values[bs_arg->c_ary_type_value + argc_delta];
                if (length_value != NULL) {
                  rbval = rb_str_new((char *)value, (int)length_value * ocdata_size(octype, octype_str));
                }
                else {
                  FFI_LOG("array length should have been returned by argument #%d, but it's NULL, defaulting on ObjCPtr", bs_arg->c_ary_type_value);
                }
              }
              break;

            case bsCArrayArgFixedLength:
              rbval = rb_str_new((char *)value, bs_arg->c_ary_type_value);
              break;

            case bsCArrayArgDelimitedByNull:
              rbval = rb_str_new2((char *)value);
              break;

            default:
              // Do nothing.
              break;
          }
        }

        if (NIL_P(rbval)) {
          if (!ocdata_to_rbobj(Qnil, to_octype(octype_str), &value, &rbval, YES))
            return rb_err_new(ocdataconv_err_class(), "Cannot convert the passed-by-reference argument #%d as '%s' to Ruby", i, octype_str);
        }
        (*retain_if_necessary)(rbval, NO, retain_if_necessary_ctx);
        rb_ary_push(retval_ary, rbval);
      }
      else {
        FFI_LOG("omitted pointer[%d] is nil, skipping...", i);
      }
    }

    *result = RARRAY(retval_ary)->len == 1 ? RARRAY(retval_ary)->ptr[0] : RARRAY(retval_ary)->len == 0 ? Qnil : retval_ary;
  }
  
  FFI_LOG("ffi dispatch done");

  return Qnil;
}
