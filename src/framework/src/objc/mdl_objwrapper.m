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

static ID _passbyref_imethods_hash_ID;
static ID _passbyref_cmethods_hash_ID;

static VALUE
get_passbyref_hash (VALUE rcv, ID hash_ID)
{
  VALUE hash;
  
  hash = rb_ivar_get(rcv, hash_ID);
  if (NIL_P(hash)) {
    hash = rb_hash_new();
    rb_ivar_set(rcv, hash_ID, hash);
  }

  return hash;
}

#define get_passbyref_imethods_hash(rcv) (get_passbyref_hash(rcv, _passbyref_imethods_hash_ID))
#define get_passbyref_cmethods_hash(rcv) (get_passbyref_hash(rcv, _passbyref_cmethods_hash_ID))

static VALUE
find_passbyref_nargs (VALUE rcv, VALUE selector)
{
  VALUE args;
  ID    hash_ID;
  
  if (TYPE(rcv) == T_CLASS) {
    hash_ID = _passbyref_cmethods_hash_ID;
  }
  else {
    hash_ID = _passbyref_imethods_hash_ID;
    rcv = CLASS_OF(rcv);
  }

  while (!NIL_P(rcv) && rb_obj_is_kind_of(rcv, _mObjWrapper) == Qtrue) {
    VALUE   hash;

    hash = get_passbyref_hash(rcv, hash_ID);
    args = rb_hash_aref(hash, selector);
    if (!NIL_P(args))
      return args;
    
    rcv = RCLASS(rcv)->super;
  }

  return Qnil;
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
ocm_perform(int argc, VALUE* argv, VALUE rcv, VALUE* result, struct _ocm_send_context *ctx)
{
  const char* ret_type;
  id oc_result = nil;
  int i;
  VALUE excp = Qnil;
  marg_list *margs;
  Method method;

  ret_type = (ctx->methodReturnType);
  if (*ret_type != _C_ID && *ret_type != _C_CLASS)
    return Qfalse;

  OBJWRP_LOG("ocm_perform (%s): ret_type=%s", ctx->selector, ret_type);

  margs = NULL;

  if (argc != ctx->numberOfArguments) {
    return Qfalse;
  }

  if (ctx->numberOfArguments > 0) {
    for (i = 0; i < ctx->numberOfArguments; i++) {
      const char* arg_type;
      
      arg_type = ctx->argumentsTypes[i];
      OBJWRP_LOG("\targ_type[%d]: %s", i, arg_type);
      if (*arg_type != _C_ID && *arg_type != _C_CLASS)
        return Qfalse;
    }

#if MAC_OS_X_VERSION_MAX_ALLOWED > MAC_OS_X_VERSION_10_4
# warning Port me to 10.5
#endif

    method = class_getInstanceMethod(((struct objc_class *)ctx->rcv)->isa, ctx->selector);
    if (method == NULL)
      return Qfalse;

    marg_malloc(margs, method);

    for (i = 0; i < ctx->numberOfArguments; i++) {
      id value;
      const char *arg_type;
      int offset;

      arg_type = ctx->argumentsTypes[i];
     
      if (!rbobj_to_nsobj(argv[i], &value))
        return ocdataconv_err_new(
          ctx->rcv, ctx->selector, 
          "cannot convert the argument[%d] as '%s' to NSObject.", 
          i, arg_type);

      offset = 0;
      method_getArgumentInfo(method, i + 2, &arg_type, &offset);
      marg_setValue(margs, offset, id, value);      
    }
  }

  OBJWRP_LOG("\tobjc_msgSend[v] (%s) num_of_args=%d...", ctx->selector, ctx->numberOfArguments);

  @try {  
    if (ctx->numberOfArguments == 0) {
      oc_result = objc_msgSend(ctx->rcv, ctx->selector);
    }
    else {
      oc_result = objc_msgSendv(ctx->rcv, ctx->selector, [ctx->methodSignature frameLength], margs);
      marg_free(margs);
    }
  }
  @catch (id exception) { 
    OBJWRP_LOG("\tobjc_msgSend[v] (%s): raise %@",
	  ctx->selector, exception);
    excp = oc_err_new (ctx->rcv, ctx->selector, exception);
  }
  if (excp != Qnil)
    return excp;

  OBJWRP_LOG("\tobjc_msgSend[v] (%s): done (retval -> %p).", ctx->selector, oc_result);

  if (oc_result == ctx->rcv) {
    *result = rcv;
  }
  else {
    *result = ocid_to_rbobj(rcv, oc_result);
    ocm_retain_result_if_necessary(*result, (const char *)ctx->selector);
  }

  return Qnil;
}

static VALUE
ocm_invoke(int argc, VALUE* argv, VALUE rcv, VALUE* result, struct _ocm_send_context *ctx)
{
  id        oc_inv;
  int       i;
  unsigned  ret_len;
  VALUE     excp = Qnil;
  VALUE     passbyref_nargs;
  void **   passbyref_args;
  void **   passbyref_arg;

  OBJWRP_LOG("ocm_invoke (%s): args_count=%d ret_type=%s", ctx->selector, argc, ctx->methodReturnType);

  oc_inv = [NSInvocation invocationWithMethodSignature: ctx->methodSignature];
  [oc_inv setTarget: ctx->rcv];
  [oc_inv setSelector: ctx->selector];

  passbyref_nargs = Qnil;//argc == ctx->numberOfArguments ? Qnil : find_passbyref_nargs(rcv, rb_str_new2((const char *)ctx->selector));
  
  if (NIL_P(passbyref_nargs)) {
    passbyref_arg = passbyref_args = NULL;
  }
  else {
    OBJWRP_LOG("\tFound pass-by-ref signature for %s", ctx->selector);
    passbyref_arg = passbyref_args = ALLOC_N(void *, RARRAY(passbyref_nargs)->len);
    for (i = 0; i < RARRAY(passbyref_nargs)->len; i++)
      passbyref_args[i] = NULL;
  }

  // verify numbers of arguments
  int num_of_args = passbyref_args ? argc + RARRAY(passbyref_nargs)->len : argc;
  if (ctx->numberOfArguments > num_of_args) {
    char buf[BUFSIZ];
    snprintf(buf, BUFSIZ, "too few arguments: %d for %d (real: %d)", num_of_args, ctx->numberOfArguments, argc);
    return rb_exc_new2 (rb_eArgError, buf);
  }

  // set arguments
  for (i = 0; i < ctx->numberOfArguments; i++) {
    VALUE   arg_idx_value;
    
    arg_idx_value = INT2FIX(i);

    // fill local pass-by-ref argument
    if (i >= argc && passbyref_args != NULL && rb_ary_includes(passbyref_nargs, arg_idx_value)) {
      id *  ocid;
      
      ocid = (id *)passbyref_arg++;
      OBJWRP_LOG("\tpass_by_reference[%d]", i);
      [oc_inv setArgument: &ocid atIndex: (i+2)];
    }
    // fill regular argument
    else {
      VALUE         arg;
      const char *  octype_str;
      int           octype;
      void *        ocdata;
      
      arg =  argv[i];
      octype_str = ctx->argumentsTypes[i];
      octype = to_octype(octype_str);
      OBJWRP_LOG("\targ_type[%d] (%p) : %s", i, arg, octype_str);
      ocdata = OCDATA_ALLOCA(octype, octype_str);
      if (rbobj_to_ocdata(arg, octype, ocdata)) {
        [oc_inv setArgument: ocdata atIndex: (i+2)];
      }
      else {
        return ocdataconv_err_new(ctx->rcv, ctx->selector, "cannot convert the argument #%d as '%s' to NS argument.", i, octype_str);
      }
    }
  }

  OBJWRP_LOG("\tNSInvocation#invoke (%s) ...", ctx->selector);
  @try {
    [oc_inv invoke];
  }
  @catch (id localException) {
    OBJWRP_LOG("\tNSInvocation#invoke (%s): raise %@", ctx->selector, localException);
    excp = oc_err_new (ctx->rcv, ctx->selector, localException);
  }
  if (excp != Qnil) 
    return excp;

  OBJWRP_LOG("\tNSInvocation#invoke (%s): done.", ctx->selector);

  // get result as argument
  for (i = 0; i < ctx->numberOfArguments; i++) {
    VALUE   arg;
    
    arg = (i < argc) ? argv[i] : Qnil;
    if (arg == Qnil) continue;
    if (rb_obj_is_kind_of(arg, objid_s_class()) != Qtrue) continue;
    if (to_octype(ctx->argumentsTypes[i]) != _PRIV_C_ID_PTR) continue;
    if (OBJCID_ID(arg))
      [OBJCID_ID(arg) retain];
  }

  // get result
  ret_len = [ctx->methodSignature methodReturnLength];
  if (ret_len > 0) {
    void *  result_data;
  
    result_data = alloca(ret_len);
    [oc_inv getReturnValue: result_data];
    OBJWRP_LOG("\tretval : %s", ctx->methodReturnType);
    if (!ocdata_to_rbobj(rcv, to_octype(ctx->methodReturnType), result_data, result))
      return ocdataconv_err_new(ctx->rcv, ctx->selector, "cannot convert the result as '%s' to Ruby Object.", ctx->methodReturnType);
  
    ocm_retain_result_if_necessary(*result, (const char *)ctx->selector);
  }
  else {
    *result = Qnil;
  }
  
  // pack if necessary pass-by-ref arguments to the result
  if (passbyref_args != NULL) {
    VALUE retval_ary;

    retval_ary = rb_ary_new ();
    if (ret_len > 0)  // don't test if *result is nil, as it may have been returned!
      rb_ary_push(retval_ary, *result);

    for (i = 0; i < RARRAY(passbyref_nargs)->len; i++) {
      void *  ocdata;
      
      ocdata = passbyref_args[i];
      if (ocdata != NULL) {
        int           narg;
        VALUE         rbval;
        const char *  octype_str;

        narg = FIX2INT(RARRAY(passbyref_nargs)->ptr[i]);
        octype_str = ctx->argumentsTypes[narg];
        if (octype_str[0] == '^')
          octype_str++;
        OBJWRP_LOG("\tpass-by-ref[%d] : %s (%p)", narg, octype_str, ocdata);
        if (!ocdata_to_rbobj(Qnil, to_octype(octype_str), &ocdata, &rbval))
          return ocdataconv_err_new(ctx->rcv, ctx->selector, "cannot convert pass-by-ref argument #%d result as '%s' to Ruby Object.", narg, octype_str);

        ocm_retain_result_if_necessary(rbval, (const char *)ctx->selector);
        rb_ary_push(retval_ary, rbval);
      }
    }
    
    *result = RARRAY(retval_ary)->len == 1 ? RARRAY(retval_ary)->ptr[0] : RARRAY(retval_ary)->len == 0 ? Qnil : retval_ary;
  }

  return Qnil;
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

  exc = ocm_perform(argc, argv, rcv, result, ctx);
  if (exc != Qnil) {
    exc = ocm_invoke(argc, argv, rcv, result, ctx);
    if (exc != Qnil) {
      [pool release];
      return exc;
    }
  }

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

static void
register_passbyref_method (VALUE hash, int argc, VALUE *argv, const char *log_prefix)
{
  VALUE selector;
  VALUE passbyref_args;
  
  rb_scan_args(argc, argv, "1*", &selector, &passbyref_args);
  if (RARRAY(passbyref_args)->len == 0)
    rb_raise(rb_eArgError, "require at least one pass-by-ref argument number");
  
  Check_Type(selector, T_STRING);

  OBJWRP_LOG("registered %s '%s' with %d pass-by-reference arguments", log_prefix, STR2CSTR(selector), RARRAY(passbyref_args)->len);

  rb_hash_aset(hash, selector, passbyref_args);  
}

static VALUE
wrapper_register_passbyref_imethod (int argc, VALUE *argv, VALUE rcv)
{
  register_passbyref_method(get_passbyref_imethods_hash(rcv), argc, argv, "instance method");
  return rcv;
}

static VALUE
wrapper_register_passbyref_cmethod (int argc, VALUE *argv, VALUE rcv)
{
  register_passbyref_method(get_passbyref_cmethods_hash(rcv), argc, argv, "class method");
  return rcv;
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
  rb_define_method(_mClsWrapper, "register_objc_passbyref_instance_method", wrapper_register_passbyref_imethod, -1);
  rb_define_method(_mClsWrapper, "register_objc_passbyref_class_method", wrapper_register_passbyref_cmethod, -1);

  _passbyref_imethods_hash_ID = rb_intern("@__passbyref_imethods_hash__"); 
  _passbyref_cmethods_hash_ID = rb_intern("@__passbyref_cmethods_hash__"); 

  return Qnil;
}
