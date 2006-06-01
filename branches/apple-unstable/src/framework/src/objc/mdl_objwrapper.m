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
  if (oc_rcv == nil)
      return NULL;

  methodSignature = [oc_rcv methodSignatureForSelector:selector];
  if (methodSignature == nil)
      return NULL;

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

static VALUE
ocm_perform(int argc, VALUE* argv, VALUE rcv, VALUE* result, struct _ocm_send_context *ctx)
{
  const char* ret_type;
  id oc_result = nil;
  int i;
  VALUE excp = Qnil;
  marg_list *margs;

  ret_type = (ctx->methodReturnType);
  if (*ret_type != _C_ID && *ret_type != _C_CLASS)
    return Qfalse;

  OBJWRP_LOG("ocm_perform (%s): ret_type=%s", ctx->selector, ret_type);

  margs = NULL;

  if (ctx->numberOfArguments > 0) {
    for (i = 0; i < ctx->numberOfArguments; i++) {
      const char* arg_type;
      
      arg_type = ctx->argumentsTypes[i];
      OBJWRP_LOG("    arg_type[%d]: %s", i, arg_type);
      if (*arg_type != _C_ID && *arg_type != _C_CLASS)
        return Qfalse;
    }

#if MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_4
    Method method;

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
#else
# error port me to 10.5
#endif
  }

  OBJWRP_LOG("    %@#objc_msgSend[v] (%s) num_of_args=%d...", ctx->rcv, ctx->selector, ctx->numberOfArguments);

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
    OBJWRP_LOG("    NSObject#objc_msgSend[v] (%s): raise %@",
	  ctx->selector, exception);
    excp = oc_err_new (ctx->rcv, ctx->selector, exception);
  }
  if (excp != Qnil)
    return excp;

  OBJWRP_LOG("    NSObject#objc_msgSend[v] (%s): done.", ctx->selector);

  if (oc_result == ctx->rcv)
    *result = rcv;
  else
    *result = ocid_to_rbobj(rcv, oc_result);


  return Qnil;
}

static VALUE
ocm_invoke(int argc, VALUE* argv, VALUE rcv, VALUE* result, struct _ocm_send_context *ctx)
{
  id oc_inv;
  int i;
  unsigned ret_len;
  VALUE excp = Qnil;

  OBJWRP_LOG("ocm_invoke (%s): ret_type=%s", ctx->selector, ctx->methodReturnType);

  oc_inv = [NSInvocation invocationWithMethodSignature: ctx->methodSignature];
  [oc_inv setTarget: ctx->rcv];
  [oc_inv setSelector: ctx->selector];

  // set arguments
  for (i = 0; i < ctx->numberOfArguments; i++) {
    VALUE arg = (i < argc) ? argv[i] : Qnil;
    const char* octype_str = ctx->argumentsTypes[i];
    int octype = to_octype(octype_str);
    void* ocdata;
    OBJWRP_LOG("    arg_type[%d]: %s", i, octype_str);
    ocdata = OCDATA_ALLOCA(octype, octype_str);
    if (rbobj_to_ocdata(arg, octype, ocdata)) {
      [oc_inv setArgument: ocdata atIndex: (i+2)];
    }
    else {
      return ocdataconv_err_new 
	(ctx->rcv, ctx->selector, "cannot convert the argument #%d as '%s' to NS argument.", i, octype_str);
    }
  }

  OBJWRP_LOG("    NSInvocation#invoke (%s) ...", ctx->selector);
  NS_DURING
    [oc_inv invoke];

  NS_HANDLER
    OBJWRP_LOG("    NSInvocation#invoke (%s): raise %@", ctx->selector, localException);
    excp = oc_err_new (ctx->rcv, ctx->selector, localException);

  NS_ENDHANDLER
  if (excp != Qnil) return excp;

  OBJWRP_LOG("    NSInvocation#invoke (%s): done.", ctx->selector);

  // get result as argument
  for (i = 0; i < ctx->numberOfArguments; i++) {
    VALUE arg = argv[i];
    if (arg == Qnil) continue;
    if (rb_obj_is_kind_of(arg, objid_s_class()) != Qtrue) continue;
    if (to_octype(ctx->argumentsTypes[i]) != _PRIV_C_ID_PTR) continue;
    if (OBJCID_ID(arg))
      [OBJCID_ID(arg) retain];
  }

  // get result
  ret_len = [ctx->methodSignature methodReturnLength];
  if (ret_len > 0) {
    int octype = to_octype(ctx->methodReturnType);
    BOOL f_conv_success;
    void* result_data = alloca(ret_len);
    [oc_inv getReturnValue: result_data];
    f_conv_success = ocdata_to_rbobj(rcv, octype, result_data, result);
    if (!f_conv_success)
      return ocdataconv_err_new 
	(ctx->rcv, ctx->selector, "cannot convert the result as '%s' to Ruby Object.", ctx->methodReturnType);
  }
  else {
    *result = Qnil;
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

  OBJWRP_LOG("ocm_send ...");

  sel = rbobj_to_nssel(argv[0]);
  ctx = ocm_create_send_context(rcv, sel);
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

  // Retain if necessary the returned ObjC value unless it was generated by "alloc/allocWithZone/new/copy/mutableCopy". 
  if (result != NULL && *result != Qnil && rb_obj_is_kind_of(*result, objid_s_class()) == Qtrue) {
    if (strcmp((const char *)ctx->selector, "alloc") != 0
        && strcmp((const char *)ctx->selector, "allocWithZone") != 0
        && strcmp((const char *)ctx->selector, "new") != 0
        && strcmp((const char *)ctx->selector, "copy") != 0
        && strcmp((const char *)ctx->selector, "mutableCopy") != 0
        && !OBJCID_DATA_PTR(*result)->retained) {
  
      [OBJCID_ID(*result) retain];
    }
    OBJCID_DATA_PTR(*result)->retained = YES; // We assume that the object is retained at that point.
  }

  [pool release];

  ocm_free_send_context(ctx);

  OBJWRP_LOG("ocm_send done");

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
