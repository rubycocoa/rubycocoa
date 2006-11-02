/** -*-objc-*-
 *
 *   $Id$
 *
 *   Copyright (c) 2001 FUJIMOTO Hisakuni
 *
 **/

#import "osx_ruby.h"
#import "ocdata_conv.h"
#import "mdl_osxobjc.h"
#import <Foundation/Foundation.h>
#import <string.h>
#import <stdlib.h>
#import <stdarg.h>
#import <objc/objc-runtime.h>
#import "BridgeSupport.h"
#import "RBRuntime.h" // for DLOG

static VALUE _mObjWrapper = Qnil;
static VALUE _mClsWrapper = Qnil;

static VALUE wrapper_ocm_send(int argc, VALUE* argv, VALUE rcv);

#define OBJWRP_LOG(fmt, args...) DLOG("OBJWRP", fmt, ##args)

static VALUE
_oc_exception_class(const char* name)
{
  VALUE mosx = rb_const_get(rb_cObject, rb_intern("OSX"));;
  return rb_const_get(mosx, rb_intern(name));
}

static VALUE
_oc_exception_new(VALUE exc, id rcv, SEL sel, const char *fmt, va_list args)
{
  char buf_a[BUFSIZ];
  char buf_b[BUFSIZ];
  snprintf(buf_a, BUFSIZ, "%s#%s - %s", rcv == NULL ? "null class" : rcv->isa->name, (char*)sel, fmt);
  vsnprintf(buf_b, BUFSIZ, buf_a, args);
  return rb_exc_new2(exc, buf_b);
}

static VALUE
oc_err_new(id rcv, SEL sel, NSException* nsexcp)
{
  id pool;
  char buf[BUFSIZ];
  static VALUE klass = Qnil;

  if ([[nsexcp name] hasPrefix: @"RBException_"]) {
      // This is a wrapped Ruby exception
      id rberr = [[nsexcp userInfo] objectForKey: @"$!"];
      if (rberr) {
          VALUE err = ocid_get_rbobj(rberr);
          if (err != Qnil)
              return err;
      }
  }
  
  if (klass == Qnil) klass = _oc_exception_class ("OCException");
  pool = [[NSAutoreleasePool alloc] init];
  snprintf(buf, BUFSIZ, "%s#%s - %s - %s",
	   rcv->isa->name, (char*)sel, [[nsexcp name] UTF8String], [[nsexcp reason] UTF8String]);
  [pool release];
  return rb_funcall(klass, rb_intern("new"), 2, ocid_to_rbobj(Qnil, nsexcp), rb_str_new2(buf));
}

static VALUE
ocdataconv_err_new(id rcv, SEL sel, const char *fmt, ...)
{
  va_list args;
  VALUE ret;
  static VALUE klass = Qnil;

  if (klass == Qnil) klass = _oc_exception_class ("OCDataConvException");
  va_start(args,fmt);
  ret = _oc_exception_new (klass, rcv, sel, fmt, args);
  va_end(args);
  return ret;
}

static VALUE
ocmsend_err_new(id rcv, SEL sel, const char *fmt, ...)
{
  va_list args;
  VALUE ret;
  static VALUE klass = Qnil;

  if (klass == Qnil) klass = _oc_exception_class ("OCMessageSendException");
  va_start(args,fmt);
  ret = _oc_exception_new (klass, rcv, sel, fmt, args);
  va_end(args);
  return ret;
}

struct _ocm_send_context
{
  id                  rcv;
  SEL                 selector;
  NSMethodSignature * methodSignature;
  unsigned            numberOfArguments;
  const char *        methodReturnType;
  const char **       argumentsTypes;
};

static struct _ocm_send_context *
ocm_create_send_context(VALUE rcv, SEL selector, char *error, size_t error_len)
{
  id oc_rcv;
  NSMethodSignature *methodSignature;
  struct _ocm_send_context * ctx;
  unsigned i;

  oc_rcv = rbobj_get_ocid(rcv);
  if (oc_rcv == nil) {
    snprintf(error, error_len, "Can't get Objective-C object in %s", RSTRING(rb_inspect(rcv))->ptr);
    return NULL;
  }

  methodSignature = [oc_rcv methodSignatureForSelector:selector];
  if (methodSignature == nil) {
    snprintf(error, error_len, "Can't get Objective-C method signature for selector '%s' of receiver %s", (char *) selector, RSTRING(rb_inspect(rcv))->ptr);
    return NULL;
  }

  ctx = (struct _ocm_send_context *)malloc(sizeof(struct _ocm_send_context));
  
  ctx->rcv = oc_rcv;
  ctx->selector = selector;
  ctx->methodSignature = [methodSignature retain];
  ctx->numberOfArguments = [methodSignature numberOfArguments] - 2;
  ctx->methodReturnType = [methodSignature methodReturnType];
  if (ctx->numberOfArguments == 0) {
    ctx->argumentsTypes = NULL;
  }
  else {
    ctx->argumentsTypes = (const char **)malloc(sizeof(const char) * ctx->numberOfArguments);
    for (i = 0; i < ctx->numberOfArguments; i++)
      ctx->argumentsTypes[i] = [methodSignature getArgumentTypeAtIndex:i+2];
  }
  
  return ctx;
}

static void
ocm_free_send_context(struct _ocm_send_context *ctx)
{
  [ctx->methodSignature release];
  if (ctx->argumentsTypes != NULL)
    free(ctx->argumentsTypes);
  free(ctx);
}

static void
ocm_retain_result_if_necessary(VALUE result, SEL selector)
{
  // Retain if necessary the returned ObjC value unless it was generated 
  // by "alloc/allocWithZone/new/copy/mutableCopy". 
  if (!NIL_P(result) && rb_obj_is_kind_of(result, objid_s_class()) == Qtrue) {
    if (!OBJCID_DATA_PTR(result)->retained
        && selector != @selector(alloc)
        && selector != @selector(allocWithZone:)
        && selector != @selector(new)
        && selector != @selector(copy)
        && selector != @selector(mutableCopy)) {

      OBJWRP_LOG("\tretaining %p", OBJCID_ID(result));  
      [OBJCID_ID(result) retain];
    }
    // We assume that the object is retained at that point. Some classes may always return a static dummy
    // object (placeholder) for every [-alloc], so we shouldn't release the return value of these messages.
    OBJCID_DATA_PTR(result)->retained = YES; 
    if (selector != @selector(alloc) && selector != @selector(allocWithZone:))
      OBJCID_DATA_PTR(result)->can_be_released = YES;
  }
}

static VALUE
ocm_ffi_dispatch(int argc, VALUE* argv, VALUE rcv, VALUE* result, struct _ocm_send_context *ctx)
{
  BOOL is_class_method;
  id klass;
  struct bsMethod *bs_method;
  Method method;
  ffi_cif cif;
  ffi_type ** arg_types;
  void ** arg_values;
  ffi_type * ret_type;
  int ret_octype;
  unsigned i;
  unsigned pointers_args_count;
  unsigned c_ary_length_args_count;
  void * retval;
  VALUE exception;

  is_class_method = TYPE(rcv) == T_CLASS;
  klass = is_class_method ? (struct objc_class *) ctx->rcv : ((struct objc_class *) ctx->rcv)->isa;
  bs_method = ctx->numberOfArguments > 0 ? find_bs_method(klass, (const char *) ctx->selector, is_class_method) : NULL;

  OBJWRP_LOG("ocm_ffi_dispatch (%s%c%s): args_count=%d ret_type=%s", ((struct objc_class *) klass)->name, is_class_method ? '.' : '#', ctx->selector, argc, ctx->methodReturnType);

  // Sanity check (arg count etc...).
  pointers_args_count = c_ary_length_args_count = 0;
  if (bs_method != NULL) {
    OBJWRP_LOG("\tfound metadata description\n");

    if (bs_method->ignore)
      rb_raise(rb_eRuntimeError,
        "Method '%s' is not supported (suggested alternative: '%s')",
        ctx->selector,
        bs_method->suggestion != NULL ? bs_method->suggestion : "n/a");

    if (bs_method->argc > 0) {
      int length_args[MAX_ARGS];
      int length_args_count = 0;

      for (i = 0; i < bs_method->argc; i++) {
        struct bsMethodArg *arg;

        arg = &bs_method->argv[i];
        // The given argument is a C array with a length determined by the value of another argument, like:
        //   [NSArray + arrayWithObjects: length:]
        // If 'in' or 'inout, the 'length' argument is not necessary (but the 'array' is).
        // If 'out', the 'array' argument is not necessary (but the 'length' is).
        if (arg->c_ary_type == bsCArrayArgDelimitedByArg) {
          unsigned j;
          BOOL already;
          
          if (ctx->numberOfArguments == argc)
            rb_warn("%s%c%s argument #%d is no longer necessary (will be ignored)", ((struct objc_class *) klass)->name, is_class_method ? '.' : '#', ctx->selector, arg->c_ary_type_value);

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
          c_ary_length_args_count++;
        }
      }
    }
  }

  if (ctx->numberOfArguments - c_ary_length_args_count != argc) {
    BOOL bad = YES;
    if (argc < ctx->numberOfArguments - c_ary_length_args_count) {
      for (i = argc; i < ctx->numberOfArguments; i++) {
        const char *type = ctx->argumentsTypes[i];
        if (*type == 'r')
            type++;
        if (*type == '^')
          pointers_args_count++;
      }
      if (pointers_args_count + argc == ctx->numberOfArguments)
        bad = NO;
    }
    if (bad)
      rb_raise(rb_eArgError, "bad number of argument(s) (expected %d, got %d)", ctx->numberOfArguments, argc);
  }
  OBJWRP_LOG("\t%d ary length argument(s), %d omitted pointer(s)", c_ary_length_args_count, pointers_args_count);

  // Easy case: a method returning ID (or nothing) _and_ without argument.
  // We don't need libffi here, we can just call it (faster).
  if (ctx->numberOfArguments == 0 && (*ctx->methodReturnType == _C_VOID || *ctx->methodReturnType == _C_ID)) {
    id val;

    method = class_getInstanceMethod(((struct objc_class *) ctx->rcv)->isa, ctx->selector);
    exception = Qnil;
    @try {
      OBJWRP_LOG("\tdirect call easy method %s types %s imp %p", (const char *)method->method_name, method->method_types, method->method_imp);
      val = (*method->method_imp)(ctx->rcv, ctx->selector);
    }
    @catch (id oc_exception) {
      OBJWRP_LOG("got objc exception '%@' -- forwarding...", oc_exception);
      exception = oc_err_new(ctx->rcv, ctx->selector, oc_exception);
    }

    // Return exception if catched.
    if (!NIL_P(exception))
      return exception;

    if (*ctx->methodReturnType == _C_ID) {
      if (!ocdata_to_rbobj(rcv, _C_ID, &val, result, NO))
        return ocdataconv_err_new(ctx->rcv, ctx->selector, "cannot convert the result as '%s' to Ruby Object.", ctx->methodReturnType);
      ocm_retain_result_if_necessary(*result, ctx->selector);
    }
    else {
      *result = Qnil;
    }
    return Qnil;
  }
 
  // Prepare arg types / values.
  arg_types = (ffi_type **) calloc(ctx->numberOfArguments + 3, sizeof(ffi_type *));
  arg_values = (void **) calloc(ctx->numberOfArguments + 3, sizeof(void *));
  if (arg_types == NULL || arg_values == NULL)
    rb_fatal("can't allocate memory");

  arg_types[0] = &ffi_type_pointer;
  arg_values[0] = &ctx->rcv;
  arg_types[1] = &ffi_type_pointer;
  arg_values[1] = &ctx->selector;

  if (ctx->numberOfArguments > 0) {
    unsigned skipped = 0;
    for (i = 0; i < ctx->numberOfArguments; i++) {
      // C-array-length-like argument, which should be already defined
      // (at the same time than the C-array-like argument), unless it's
      // returned by reference.
      if (bs_method != NULL
          && find_bs_method_arg_by_c_array_len_arg_index(bs_method, i) != NULL
          && ctx->argumentsTypes[i][0] != '^') {
        skipped++;
      } 
      // Omitted pointer.
      else if (i - skipped >= argc) {
        OBJWRP_LOG("\tomitted pointer[%d]", i);
        arg_values[i + 2] = &arg_values[i + 2];
        arg_types[i + 2] = &ffi_type_pointer;
      }
      // Regular argument.
      else {
        VALUE arg;
        const char *octype_str;
        int octype;
        void *value;
        struct bsMethodArg *bs_arg;
        BOOL is_c_array;
        int len;

        arg = argv[i - skipped];
        octype_str = ctx->argumentsTypes[i];
        octype = to_octype(octype_str);
        bs_arg = bs_method != NULL ? find_bs_method_arg_by_index(bs_method, i) : NULL;

        if (bs_arg != NULL && !bs_arg->null_accepted && NIL_P(arg)) {
            exception = ocdataconv_err_new(ctx->rcv, ctx->selector, "argument #%d can't be nil", i);
            goto bails;
        }

        is_c_array = bs_arg != NULL && bs_arg->c_ary_type != bsCArrayArgUndefined;

        // C-array-like argument.
        if (is_c_array) {
          const char * ptype;

          ptype = octype_str;
          if (*ptype == 'r')
            ptype++;
          if (*ptype != '^') {
            exception = ocdataconv_err_new(ctx->rcv, ctx->selector, "internal error: argument #%d is not a defined as a pointer in the runtime or it is described as such in the metadata", i);
            goto bails;
          }
          ptype++;

          if (TYPE(arg) == T_STRING)
            len = RSTRING(arg)->len;
          else if (TYPE(arg) == T_ARRAY)
            len = RARRAY(arg)->len;
          else if (rb_obj_is_kind_of(arg, objcptr_s_class()))
            len = objcptr_allocated_size(arg); 
          else {
            exception = ocdataconv_err_new(ctx->rcv, ctx->selector, "argument #%d is not a String/Array/ObjcPtr as it should be (but '%s').", i, rb_obj_classname(arg));
            goto bails;
          }

          if (bs_arg->c_ary_type == bsCArrayArgFixedLength) {
            int expected_len = bs_arg->c_ary_type_value * ocdata_size(to_octype(ptype), ptype);
            if (expected_len != len) { 
              exception = ocdataconv_err_new(ctx->rcv, ctx->selector, "argument #%d has an invalid length (expected %d, got %d)", i, expected_len, len);
              goto bails;
            }
          }
          else if (bs_arg->c_ary_type == bsCArrayArgDelimitedByArg) {
            int * prev_len;
          
            prev_len = arg_values[bs_arg->c_ary_type_value + 2];
            if (prev_len != NULL && *prev_len != len) {
              exception = ocdataconv_err_new(ctx->rcv, ctx->selector, "incorrect array length of argument #%d (expected %d, got %d)", i, *prev_len, len);
              goto bails;
            }
            OBJWRP_LOG("\targ_type[%d] (%p) : %s (defined as a C array delimited by arg #%d in the metadata)", i, arg, octype_str, bs_arg->c_ary_type_value);
          }
          value = OCDATA_ALLOCA(octype, octype_str);
          if (len > 0)
            *(void **) value = alloca(ocdata_size(to_octype(ptype), ptype) * len);
        } 
        else {
          OBJWRP_LOG("\targ_type[%d] (%p) : %s", i, arg, octype_str);
          len = 0;
          value = OCDATA_ALLOCA(octype, octype_str);
        }

        if (!rbobj_to_ocdata(arg, octype, value, NO)) {
          exception = ocdataconv_err_new(ctx->rcv, ctx->selector, "cannot convert the argument #%d as '%s' to NS argument.", i, octype_str);
          goto bails;
        }
        arg_types[i + 2] = ffi_type_for_octype(octype);
        arg_values[i + 2] = value;

        if (is_c_array && bs_arg->c_ary_type == bsCArrayArgDelimitedByArg) {
          int * plen;

          OBJWRP_LOG("\targ_type[%d] defined as the array length (%d)\n", bs_arg->c_ary_type_value, len);
          plen = (int *) alloca(sizeof(int));
          *plen = len;
          arg_values[bs_arg->c_ary_type_value + 2] = plen;
          arg_types[bs_arg->c_ary_type_value + 2] = &ffi_type_uint;
        }
      }
    }
  }
  arg_types[ctx->numberOfArguments + 2] = NULL;
  arg_values[ctx->numberOfArguments + 2] = NULL;

  // Prepare return type/val.
  ret_octype = to_octype(ctx->methodReturnType);
  ret_type = ffi_type_for_octype(ret_octype);
  if (ret_octype != _C_VOID)
    retval = alloca(ocdata_size(ret_octype, ctx->methodReturnType));

  // Prepare cif.
  if (ffi_prep_cif(&cif, FFI_DEFAULT_ABI, ctx->numberOfArguments + 2, ret_type, arg_types) != FFI_OK)
    rb_fatal("Can't prepare the cif");

  // Call function.
  exception = Qnil;
  @try {
    method = class_getInstanceMethod(((struct objc_class *) ctx->rcv)->isa, ctx->selector);
    OBJWRP_LOG("\tffi_call method %s types %s imp %p", (const char *)method->method_name, method->method_types, method->method_imp);
    ffi_call(&cif, FFI_FN(method->method_imp), (ffi_arg *)&retval, arg_values);
    OBJWRP_LOG("\tffi_call done");
  }
  @catch (id oc_exception) {
    OBJWRP_LOG("got objc exception '%@' -- forwarding...", oc_exception);
    exception = oc_err_new(ctx->rcv, ctx->selector, oc_exception);
  }

  // Return exception if catched.
  if (!NIL_P(exception))
    goto bails;

  // Get result as argument.
  for (i = 0; i < ctx->numberOfArguments; i++) {
    VALUE arg;

    arg = (i < argc) ? argv[i] : Qnil;
    if (arg == Qnil)
      continue;
    if (to_octype(ctx->argumentsTypes[i]) != _PRIV_C_ID_PTR)
      continue;
    if (rb_obj_is_kind_of(arg, objid_s_class()) != Qtrue)
      continue;
    OBJWRP_LOG("\tgot passed-by-reference argument %d", i);
    ocm_retain_result_if_necessary(arg, ctx->selector);
  }

  // Get result
  if (ret_octype != _C_VOID) {
    OBJWRP_LOG("\tgetting return value (%p of type '%s')", retval, ctx->methodReturnType);

    // We assume that every method returning 'char' is in fact meant to return a boolean value, unless
    // specified in the metadata files as such.
    if (ret_octype == _C_CHR) {
      if (bs_method == NULL)
        bs_method = find_bs_method(klass, (const char *) ctx->selector, is_class_method);
      if (bs_method == NULL || !bs_method->returns_char) {
        OBJWRP_LOG("\tmethod is a predicate, forcing result as a boolean value");
        ret_octype = _PRIV_C_BOOL;
      }
    }

    if (!ocdata_to_rbobj(rcv, ret_octype, &retval, result, YES)) {
      exception = ocdataconv_err_new(ctx->rcv, ctx->selector, "cannot convert the result as '%s' to Ruby Object.", ctx->methodReturnType);
      goto bails;
    }
    OBJWRP_LOG("\tgot return value (%p of type '%s')", retval, ctx->methodReturnType);
    ocm_retain_result_if_necessary(*result, ctx->selector);
  } 
  else {
    *result = Qnil;
  }

  // Get omitted pointers result, and pack them with the result in an array.
  if (pointers_args_count > 0) {
    VALUE retval_ary;

    retval_ary = rb_ary_new();
    if ([ctx->methodSignature methodReturnLength] > 0)
      // Don't test if *result is nil, as nil may have been returned!
      rb_ary_push(retval_ary, *result);

    for (i = ctx->numberOfArguments - pointers_args_count; i < ctx->numberOfArguments; i++) {
      void *value;

      value = arg_values[i + 2];
      if (value != NULL) {
        VALUE rbval;
        const char *octype_str;
        int octype;
        struct bsMethodArg *bs_arg;

        octype_str = ctx->argumentsTypes[i];
        if (octype_str[0] == '^')
          octype_str++;
        OBJWRP_LOG("\tgot omitted pointer[%d] : %s (%p)", i, octype_str, value);
        octype = to_octype(octype_str);        
        rbval = Qnil;

        if (octype == _PRIV_C_PTR 
            && bs_method != NULL
            && (bs_arg = find_bs_method_arg_by_index(bs_method, i)) != NULL) {

          switch (bs_arg->c_ary_type) {
            case bsCArrayArgDelimitedByArg:
              {
                void *length_value = arg_values[bs_arg->c_ary_type_value + 2];
                if (length_value != NULL) {
                  rbval = rb_str_new((char *)value, (int)length_value * ocdata_size(octype, octype_str));
                }
                else {
                  OBJWRP_LOG("\tarray length should have been returned by argument #%d, but it's NULL, defaulting on ObjCPtr", bs_arg->c_ary_type_value);
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
          if (!ocdata_to_rbobj(Qnil, to_octype(octype_str), &value, &rbval, YES)) {
            exception = ocdataconv_err_new(ctx->rcv, ctx->selector, "cannot convert pass-by-ref argument #%d result as '%s' to Ruby Object.", i, octype_str);
            goto bails;
          }
        }
        ocm_retain_result_if_necessary(rbval, ctx->selector);
        rb_ary_push(retval_ary, rbval);
      }
      else {
        OBJWRP_LOG("\tomitted pointer[%d] is nil, skipping...", i);
      }
    }

    *result = RARRAY(retval_ary)->len == 1 ? RARRAY(retval_ary)->ptr[0] : RARRAY(retval_ary)->len == 0 ? Qnil : retval_ary;
  }
  OBJWRP_LOG("ocm_ffi_dispatch done%s", NIL_P(exception) ? "" : " with exception");

bails:
  free(arg_types);
  free(arg_values);

  return exception;
}

static VALUE
ocm_send(int argc, VALUE* argv, VALUE rcv, VALUE* result)
{
  VALUE exc;
  struct _ocm_send_context *ctx;
  SEL sel;
  id pool;
  char error[256];

  if (argc < 1) 
    return Qnil;

  pool = [[NSAutoreleasePool alloc] init];
  
  sel = rbobj_to_nssel(argv[0]);
  exc = Qnil;
  ctx = ocm_create_send_context(rcv, sel, error, sizeof error);
  
  OBJWRP_LOG("ocm_send (%s) ...", (const char *)sel);
  if (ctx == NULL) {
    exc = ocmsend_err_new (rbobj_get_ocid(rcv), sel, error);
  }
  else {
    argc--;
    argv++;

    exc = ocm_ffi_dispatch(argc, argv, rcv, result, ctx);
    ocm_free_send_context(ctx);
  }

  [pool release];

  OBJWRP_LOG("ocm_send (%s) done%s", (const char *)sel, NIL_P(exc) ? "" : " with exception");

  return exc;
}

/*************************************************/

static VALUE
wrapper_ocm_responds_p(VALUE rcv, VALUE sel)
{
  id oc_rcv = rbobj_get_ocid(rcv);
  SEL oc_sel = rbobj_to_nssel(sel);
  return [oc_rcv respondsToSelector: oc_sel] ? Qtrue : Qfalse;
}

static VALUE
wrapper_ocm_send(int argc, VALUE* argv, VALUE rcv)
{
  VALUE result;
  VALUE exc;
  exc = ocm_send(argc, argv, rcv, &result);
  if (exc != Qnil) {
    if (exc == Qfalse)
      exc = ocmsend_err_new (nil, NULL, "cannot forward message.");
    rb_exc_raise (exc);
  }
  return result;
}

static VALUE
wrapper_to_s (VALUE rcv)
{
  VALUE ret;
  id oc_rcv;
  id pool;

  pool = [[NSAutoreleasePool alloc] init];
  oc_rcv = rbobj_get_ocid(rcv);
  if ([oc_rcv isKindOfClass: [NSString class]] == NO)
    oc_rcv = [oc_rcv description];
  ret = ocstr_to_rbstr(oc_rcv);
  [pool release];
  return ret;
}

static void
_ary_push_objc_methods (VALUE ary, Class cls, int recur)
{
  void* iterator = NULL;
  struct objc_method_list* list;

  while (list = class_nextMethodList(cls, &iterator)) {
    int i;
    struct objc_method* methods = list->method_list;
    
    for (i = 0; i < list->method_count; i++) {
      rb_ary_push (ary, rb_str_new2((const char*)(methods[i].method_name)));
    }
  }

  if (recur && cls->super_class && !((cls->info ^ cls->super_class->info) & CLS_META))
    _ary_push_objc_methods (ary, cls->super_class, recur);
  rb_funcall(ary, rb_intern("uniq!"), 0);
}

static VALUE
wrapper_objc_methods (VALUE rcv)
{
  VALUE ary;
  id oc_rcv;

  ary = rb_ary_new();
  oc_rcv = rbobj_get_ocid (rcv);
  _ary_push_objc_methods (ary, oc_rcv->isa, 1);
  return ary;
}

static VALUE
wrapper_objc_instance_methods (int argc, VALUE* argv, VALUE rcv)
{
  VALUE ary;
  id oc_rcv;
  int recur;

  recur = (argc == 0) ? 1 : RTEST(argv[0]);
  ary = rb_ary_new();
  oc_rcv = rbobj_get_ocid (rcv);
  _ary_push_objc_methods (ary, oc_rcv, recur);
  return ary;
}

static VALUE
wrapper_objc_class_methods (int argc, VALUE* argv, VALUE rcv)
{
  VALUE ary;
  id oc_rcv;
  int recur;

  recur = (argc == 0) ? 1 : RTEST(argv[0]);
  ary = rb_ary_new();
  oc_rcv = rbobj_get_ocid (rcv);
  _ary_push_objc_methods (ary, oc_rcv->isa, recur);
  return ary;
}

static const char*
_objc_method_type (Class cls, const char* name)
{
  struct objc_method* method;

  method = class_getInstanceMethod(cls, sel_registerName(name));
  if (!method)
    return NULL;
  return method->method_types;
}

static VALUE
_name_to_selstr (VALUE name)
{
  VALUE re;
  const char* patstr = "([^^])_";
  const char* repstr = "\\1:";

  name = rb_obj_as_string (name);
  re = rb_reg_new (patstr, strlen(patstr), 0);
  rb_funcall (name, rb_intern("gsub!"), 2, re, rb_str_new2(repstr));
  return name;
}

static VALUE
wrapper_objc_method_type (VALUE rcv, VALUE name)
{
  id oc_rcv;
  const char* str;

  oc_rcv = rbobj_get_ocid (rcv);
  name = _name_to_selstr (name);
  str = _objc_method_type (oc_rcv->isa, STR2CSTR(name));
  if (str == NULL) return Qnil;
  return rb_str_new2(str);
}

static VALUE
wrapper_objc_instance_method_type (VALUE rcv, VALUE name)
{
  id oc_rcv;
  const char* str;

  oc_rcv = rbobj_get_ocid (rcv);
  name = _name_to_selstr (name);
  str = _objc_method_type (oc_rcv, STR2CSTR(name));
  if (str == NULL) return Qnil;
  return rb_str_new2(str);
}

static VALUE
wrapper_objc_class_method_type (VALUE rcv, VALUE name)
{
  id oc_rcv;
  const char* str;

  oc_rcv = rbobj_get_ocid (rcv);
  name = _name_to_selstr (name);
  str = _objc_method_type (oc_rcv->isa, STR2CSTR(name));
  if (str == NULL) return Qnil;
  return rb_str_new2(str);
}

/*****************************************/

VALUE
init_mdl_OCObjWrapper(VALUE outer)
{
  _mObjWrapper = rb_define_module_under(outer, "OCObjWrapper");

  rb_define_method(_mObjWrapper, "ocm_responds?", wrapper_ocm_responds_p, 1);
  rb_define_method(_mObjWrapper, "ocm_send", wrapper_ocm_send, -1);
  rb_define_method(_mObjWrapper, "to_s", wrapper_to_s, 0);

  rb_define_method(_mObjWrapper, "objc_methods", wrapper_objc_methods, 0);
  rb_define_method(_mObjWrapper, "objc_method_type", wrapper_objc_method_type, 1);

  _mClsWrapper = rb_define_module_under(outer, "OCClsWrapper");
  rb_define_method(_mClsWrapper, "objc_instance_methods", wrapper_objc_instance_methods, -1);
  rb_define_method(_mClsWrapper, "objc_class_methods", wrapper_objc_class_methods, -1);
  rb_define_method(_mClsWrapper, "objc_instance_method_type", wrapper_objc_instance_method_type, 1);
  rb_define_method(_mClsWrapper, "objc_class_method_type", wrapper_objc_class_method_type, 1);

  return Qnil;
}
