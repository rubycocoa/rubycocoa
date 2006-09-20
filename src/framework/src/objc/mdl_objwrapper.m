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
ocm_create_send_context(VALUE rcv, SEL selector)
{
  id oc_rcv;
  NSMethodSignature *methodSignature;
  struct _ocm_send_context * ctx;
  unsigned i;

  oc_rcv = rbobj_get_ocid(rcv);
  if (oc_rcv == nil) {
      OBJWRP_LOG("Can't get ocid for %p", rcv);        
      return NULL;
  }

  methodSignature = [oc_rcv methodSignatureForSelector:selector];
  if (methodSignature == nil) {
      OBJWRP_LOG("Can't get method signature for selector %s of receiver %p", selector, oc_rcv);        
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
ocm_retain_result_if_necessary(VALUE result, const char *selector)
{
  // Retain if necessary the returned ObjC value unless it was generated 
  // by "alloc/allocWithZone/new/copy/mutableCopy". 
  if (!NIL_P(result) && rb_obj_is_kind_of(result, objid_s_class()) == Qtrue) {
    if (!OBJCID_DATA_PTR(result)->retained
        && strcmp(selector, "alloc") != 0
        && strcmp(selector, "allocWithZone:") != 0
        && strcmp(selector, "new") != 0
        && strcmp(selector, "copy") != 0
        && strcmp(selector, "mutableCopy") != 0) {
  
      [OBJCID_ID(result) retain];
    }
    OBJCID_DATA_PTR(result)->retained = YES; // We assume that the object is retained at that point.
  }
}

static VALUE
ocm_ffi_dispatch(int argc, VALUE* argv, VALUE rcv, VALUE* result, struct _ocm_send_context *ctx)
{
  Method method;
  ffi_cif cif;
  ffi_type **arg_types;
  void **arg_values;
  ffi_type *ret_type;
  unsigned i;
  unsigned pointers_args_count;
  void *retval;
  VALUE exception;

  // check args count
  pointers_args_count = 0;
  if (ctx->numberOfArguments != argc) {
    BOOL bad = YES;
    if (argc < ctx->numberOfArguments) {
      for (i = argc; i < ctx->numberOfArguments; i++) {
        if (ctx->argumentsTypes[i][0] == '^')
          pointers_args_count++;
      }
      if (pointers_args_count + argc == ctx->numberOfArguments)
        bad = NO;
    }
    if (bad)
      rb_raise(rb_eArgError, "bad number of argument(s) (expected %d, got %d)", ctx->numberOfArguments, argc);
  }

  OBJWRP_LOG("ocm_ffi_dispatch (%s): args_count=%d ret_type=%s", ctx->selector, argc, ctx->methodReturnType);
  
  // prepare arg types / values
  arg_types = (ffi_type **)malloc(sizeof(ffi_type *) * (ctx->numberOfArguments + 3));
  arg_values = (void **)malloc(sizeof(void *) * (ctx->numberOfArguments + 3));
  if (arg_types == NULL || arg_values == NULL)
    rb_fatal("can't allocate memory");

  arg_types[0] = &ffi_type_pointer;
  arg_values[0] = &ctx->rcv;
  arg_types[1] = &ffi_type_pointer;
  arg_values[1] = &ctx->selector;

  if (ctx->numberOfArguments > 0) {
    for (i = 0; i < ctx->numberOfArguments; i++) {
      // omitted pointer
      if (i >= argc) {
        OBJWRP_LOG("\tomitted pointer[%d] (%p)", i, arg_values[i + 2]);
        arg_values[i + 2] = &arg_values[i + 2];
        arg_types[i + 2] = &ffi_type_pointer;
      }
      // regular argument
      else {
        VALUE arg;
        const char *octype_str;
        int octype;
        void *value;

        arg = argv[i];
        octype_str = ctx->argumentsTypes[i];
        octype = to_octype(octype_str);
        OBJWRP_LOG("\targ_type[%d] (%p) : %s", i, arg, octype_str);
        value = OCDATA_ALLOCA(octype, octype_str);
        if (!rbobj_to_ocdata(arg, octype, value)) {
          exception = ocdataconv_err_new(ctx->rcv, ctx->selector, "cannot convert the argument #%d as '%s' to NS argument.", i, octype_str);
          goto bails;
        }
  
        arg_types[i + 2] = ffi_type_for_octype(octype); 
        arg_values[i + 2] = value;
      }
    }
  }
  arg_types[ctx->numberOfArguments + 2] = NULL;
  arg_values[ctx->numberOfArguments + 2] = NULL; 

  // prepare ret type
  ret_type = ffi_type_for_octype(to_octype(ctx->methodReturnType)); 

  // prepare cif
  if (ffi_prep_cif(&cif, FFI_DEFAULT_ABI, ctx->numberOfArguments + 2, ret_type, arg_types) != FFI_OK)
    rb_fatal("Can't prepare the cif");

  // call function
  exception = Qnil;
  @try {
    method = class_getInstanceMethod(((struct objc_class *)ctx->rcv)->isa, ctx->selector);
    OBJWRP_LOG("\tffi_call ...");
    ffi_call(&cif, FFI_FN(method->method_imp), (ffi_arg *)&retval, arg_values);
    OBJWRP_LOG("\tffi_call done");
  }
  @catch (id oc_exception) {
    OBJWRP_LOG("got objc exception '%@' -- forwarding...", oc_exception);
    exception = oc_err_new (ctx->rcv, ctx->selector, oc_exception);
  }

  // return exception if catched
  if (!NIL_P(exception))
    goto bails;

  // get result as argument
  for (i = 0; i < ctx->numberOfArguments; i++) {
    VALUE   arg;

    arg = (i < argc) ? argv[i] : Qnil;
    if (arg == Qnil) 
      continue;
    if (rb_obj_is_kind_of(arg, objid_s_class()) != Qtrue) 
      continue;
    if (to_octype(ctx->argumentsTypes[i]) != _PRIV_C_ID_PTR) 
      continue;
    OBJWRP_LOG("\tgot passed-by-reference argument %d", i);
    ocm_retain_result_if_necessary(arg, (const char *)ctx->selector);
  }

  // get result
  if (ret_type != &ffi_type_void) {
    int octype;

    octype = to_octype(ctx->methodReturnType); 

    // we assume that every method returning 'char' is in fact meant to return a boolean value, unless
    // specified in the metadata files as such.
    if (octype == _C_CHR) {
      BOOL is_class_method;
      id klass;

      is_class_method = TYPE(rcv) == T_CLASS;
      klass = is_class_method ? (struct objc_class *)ctx->rcv : ((struct objc_class *)ctx->rcv)->isa;

      // read the metadata for each class in the hierarchy
      octype = _PRIV_C_BOOL;
      do {
        struct bsMethod * bs_method;

        bs_method = find_bs_method(((struct objc_class *)klass)->name, (const char *)ctx->selector, is_class_method);
        if (bs_method != NULL && bs_method->returns_char) {
          OBJWRP_LOG("\tdetected predicate, forcing boolean conversion of the return value");
          octype = _C_CHR;
          break;
        }
        
        klass = ((struct objc_class *)klass)->super_class;
      }
      while (klass != NULL);
    }

    if (!ocdata_to_rbobj(rcv, octype, &retval, result)) {
      exception = ocdataconv_err_new(ctx->rcv, ctx->selector, "cannot convert the result as '%s' to Ruby Object.", ctx->methodReturnType);
      goto bails;
    }
    OBJWRP_LOG("\tgot return value (%p)", retval);
    ocm_retain_result_if_necessary(*result, (const char *)ctx->selector);
  }
  else {
    *result = Qnil;
  }

  // get omitted pointers result, and pack them with the result in an array
  if (pointers_args_count > 0) {
    VALUE retval_ary;

    retval_ary = rb_ary_new();
    if ([ctx->methodSignature methodReturnLength] > 0) // don't test if *result is nil, as nil may have been returned!
      rb_ary_push(retval_ary, *result);

    for (i = ctx->numberOfArguments - pointers_args_count; i < ctx->numberOfArguments; i++) {
      void *value;

      value = arg_values[i + 2];  
      if (value != NULL) {
        VALUE         rbval;
        const char *  octype_str;

        octype_str = ctx->argumentsTypes[i];
        if (octype_str[0] == '^')
          octype_str++;
        OBJWRP_LOG("\tgot omitted pointer[%d] : %s (%p)", i, octype_str, value);
        if (!ocdata_to_rbobj(Qnil, to_octype(octype_str), &value, &rbval)) {
          exception = ocdataconv_err_new(ctx->rcv, ctx->selector, "cannot convert pass-by-ref argument #%d result as '%s' to Ruby Object.", i, octype_str);
          goto bails;
        }

        ocm_retain_result_if_necessary(rbval, (const char *)ctx->selector);
        rb_ary_push(retval_ary, rbval);
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

  if (argc < 1) return Qnil;

  sel = rbobj_to_nssel(argv[0]);
  ctx = ocm_create_send_context(rcv, sel);
  OBJWRP_LOG("ocm_send (%s) ...", (const char *)sel);
  if (ctx == NULL)
    return ocmsend_err_new (nil, sel, "invalid object/message.");

  argc--;
  argv++;

  pool = [[NSAutoreleasePool alloc] init];

  exc = ocm_ffi_dispatch(argc, argv, rcv, result, ctx);

  [pool release];

  ocm_free_send_context(ctx);

  OBJWRP_LOG("ocm_send (%s) done", (const char *)sel);

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
