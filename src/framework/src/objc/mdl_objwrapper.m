/* 
 * Copyright (c) 2006-2007, The RubyCocoa Project.
 * Copyright (c) 2001-2006, FUJIMOTO Hisakuni.
 * All Rights Reserved.
 *
 * RubyCocoa is free software, covered under either the Ruby's license or the 
 * LGPL. See the COPYRIGHT file for more information.
 */

#import "osx_ruby.h"
#import "ocdata_conv.h"
#import "mdl_osxobjc.h"
#import <Foundation/Foundation.h>
#import <string.h>
#import <stdlib.h>
#import <stdarg.h>
#import <objc/objc-runtime.h>
#import "BridgeSupport.h"
#import "internal_macros.h"
#import "ocexception.h"
#import "objc_compat.h"

static VALUE _mObjWrapper = Qnil;
static VALUE _mClsWrapper = Qnil;

static VALUE wrapper_ocm_send(int argc, VALUE* argv, VALUE rcv);

#define OBJWRP_LOG(fmt, args...) DLOG("OBJWRP", fmt, ##args)

struct _ocm_retain_context {
  VALUE rcv;
  SEL selector;
};

static void
ocm_retain_arg_if_necessary (VALUE result, BOOL is_result, void *context)
{
  VALUE rcv = ((struct _ocm_retain_context *)context)->rcv;
  SEL selector = ((struct _ocm_retain_context *)context)->selector;

  // Retain if necessary the returned ObjC value unless it was generated 
  // by "alloc/allocWithZone/new/copy/mutableCopy". 
  // Some classes may always return a static dummy object (placeholder) for every [-alloc], so we shouldn't release the return value of these messages.
  if (!NIL_P(result) && rb_obj_is_kind_of(result, objid_s_class()) == Qtrue) {
    if (!OBJCID_DATA_PTR(result)->retained
        && selector != @selector(alloc)
        && selector != @selector(allocWithZone:)
        && selector != @selector(new)
        && selector != @selector(copy)
        && selector != @selector(mutableCopy)) {

      if (!is_result
          || NIL_P(rcv)
          || strncmp((const char *)selector, "init", 4) != 0
          || OBJCID_ID(rcv) == OBJCID_ID(result)
          || !OBJCID_DATA_PTR(rcv)->retained) { 

        OBJWRP_LOG("retaining %p", OBJCID_ID(result));  
        [OBJCID_ID(result) retain];
      }
    }
    // We assume that the object is retained at that point.
    OBJCID_DATA_PTR(result)->retained = YES; 
    if (selector != @selector(alloc) && selector != @selector(allocWithZone:))
      OBJCID_DATA_PTR(result)->can_be_released = YES;
  }
}

static VALUE
ocm_send(int argc, VALUE* argv, VALUE rcv, VALUE* result)
{
  SEL                   selector;
  NSAutoreleasePool *   pool;
  id                    oc_rcv;
  Class                 klass;
  Method                method;
  IMP                   imp;
  NSMethodSignature *   methodSignature;
  unsigned              numberOfArguments;
  unsigned              expected_argc;
  char *                methodReturnType;
  char **               argumentsTypes;
  BOOL                  is_class_method;
  struct bsMethod *     bs_method;
  ffi_type **           arg_types;
  void **               arg_values;
  VALUE                 exception;

  if (argc < 1) 
    return Qfalse;

  pool = [[NSAutoreleasePool alloc] init];

  selector = rbobj_to_nssel(argv[0]);
  exception = Qnil;

  methodReturnType = NULL;
  argumentsTypes = NULL;

  oc_rcv = rbobj_get_ocid(rcv);
  if (oc_rcv == nil) {
    exception = rb_err_new(ocmsgsend_err_class(), "Can't get Objective-C object in %s", RSTRING(rb_inspect(rcv))->ptr);
    goto bails;
  }

  klass = object_getClass(oc_rcv);
  method = class_getInstanceMethod(klass, selector); 
  if (method == NULL) {
    // If we can't get the method signature via the ObjC runtime, let's try the NSObject API,
    // as the target class may override the invocation dispatching methods (as NSUndoManager).
    methodSignature = [oc_rcv methodSignatureForSelector:selector];
    if (methodSignature == nil) {
      exception = rb_err_new(ocmsgsend_err_class(), "Can't get Objective-C method signature for selector '%s' of receiver %s", (char *) selector, RSTRING(rb_inspect(rcv))->ptr);
      goto bails;
    }
    // Let's use the regular message dispatcher.
    imp = objc_msgSend;
  }
  else {
    methodSignature = nil;
    imp = method_getImplementation(method);
  }

  decode_method_encoding(method != NULL ? method_getTypeEncoding(method) : NULL, methodSignature, &numberOfArguments, &methodReturnType, &argumentsTypes, YES);

  argc--;
  argv++;

  struct _ocm_retain_context context = { rcv, selector };

  is_class_method = TYPE(rcv) == T_CLASS;
  klass = is_class_method ? (Class) oc_rcv : object_getClass(oc_rcv);
  
  OBJWRP_LOG("ocm_send (%s%c%s): args_count=%d ret_type=%s", class_getName(klass), is_class_method ? '.' : '#', selector, argc, methodReturnType);

  // Easy case: a method returning ID (or nothing) _and_ without argument.
  // We don't need libffi here, we can just call it (faster).
  if (numberOfArguments == 0 
      && (*methodReturnType == _C_VOID || *methodReturnType == _C_ID || *methodReturnType == _C_CLASS)) {

    id  val;

    exception = Qnil;
    @try {
      OBJWRP_LOG("direct call easy method %s imp %p", (const char *)selector, imp);
      val = (*imp)(oc_rcv, selector);
    }
    @catch (id oc_exception) {
      OBJWRP_LOG("got objc exception '%@' -- forwarding...", oc_exception);
      exception = oc_err_new(oc_exception);
    }

    if (NIL_P(exception)) {
      if (*methodReturnType != _C_VOID) {
        OBJWRP_LOG("got return value %p", val);
        if (!ocdata_to_rbobj(rcv, methodReturnType, (const void *)&val, result, NO)) {
          exception = rb_err_new(ocdataconv_err_class(), "Cannot convert the result as '%s' to Ruby", methodReturnType);
        }
        else {
          ocm_retain_arg_if_necessary(*result, YES, &context);
        }
      }
      else {
        *result = Qnil;
      }
    }
    else {
      *result = Qnil;
    }
    goto success;
  }

  expected_argc = numberOfArguments;

  bs_method = find_bs_method(klass, (const char *) selector, is_class_method); 
  if (bs_method != NULL) {
    OBJWRP_LOG("found metadata description\n");
    if (bs_method->ignore) {
      exception = rb_err_new(rb_eRuntimeError, "Method '%s' is not supported (suggested alternative: '%s')", selector, bs_method->suggestion != NULL ? bs_method->suggestion : "n/a");
      goto bails;
    }
    if (bs_method->is_variadic && argc > numberOfArguments) {
      unsigned i;
      VALUE format_str;      

      expected_argc = argc;
      format_str = Qnil;
      argumentsTypes = (char **)realloc(argumentsTypes, sizeof(char *) * argc);
      ASSERT_ALLOC(argumentsTypes);

      for (i = 0; i < bs_method->argc; i++) {
        struct bsArg *bs_arg = &bs_method->argv[i];
        if (bs_arg->printf_format) {
          assert(bs_arg->index < argc);
          format_str = argv[bs_arg->index];
        }
      }

      if (NIL_P(format_str)) {
        for (i = numberOfArguments; i < argc; i++)
          argumentsTypes[i] = "@"; // _C_ID
      }
      else {
        set_octypes_for_format_str(&argumentsTypes[numberOfArguments],
          argc - numberOfArguments, STR2CSTR(format_str));
      }
    }
  }

  arg_types = (ffi_type **) alloca((expected_argc + 3) * sizeof(ffi_type *));
  ASSERT_ALLOC(arg_types);
  arg_values = (void **) alloca((expected_argc + 3) * sizeof(void *));
  ASSERT_ALLOC(arg_values);

  arg_types[0] = &ffi_type_pointer;
  arg_types[1] = &ffi_type_pointer;
  arg_values[0] = &oc_rcv;
  arg_values[1] = &selector;

  memset(arg_types + 2, 0, (expected_argc + 1) * sizeof(ffi_type *));
  memset(arg_values + 2, 0, (expected_argc + 1) * sizeof(void *));

  exception = rb_ffi_dispatch(
    (struct bsCallEntry *)bs_method, 
    argumentsTypes, 
    expected_argc, 
    argc, 
    2, 
    argv, 
    arg_types, 
    arg_values, 
    methodReturnType, 
    imp, 
    ocm_retain_arg_if_necessary, 
    &context, 
    result);

success:
  OBJWRP_LOG("ocm_send (%s) done%s", (const char *)selector, NIL_P(exception) ? "" : " with exception");

bails:
  if (methodReturnType != NULL)
    free(methodReturnType);
  if (argumentsTypes != NULL) {
    unsigned i;
    for (i = 0; i < numberOfArguments; i++)
      free(argumentsTypes[i]);
    free(argumentsTypes);
  }

  [pool release];

  return exception;
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
  if (!NIL_P(exc)) {
    if (exc == Qfalse)
      exc = rb_err_new(ocmsgsend_err_class(), "cannot forward message.");
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

  oc_rcv = rbobj_get_ocid(rcv);
  pool = [[NSAutoreleasePool alloc] init];
  if ([oc_rcv isKindOfClass: [NSString class]] == NO)
    oc_rcv = [oc_rcv description];
  ret = ocstr_to_rbstr(oc_rcv);
  [pool release];
  return ret;
}

static void
_ary_push_objc_methods (VALUE ary, Class cls, int recur)
{
  Class superclass = class_getSuperclass(cls);
#if MAC_OS_X_VERSION_MAX_ALLOWED > MAC_OS_X_VERSION_10_4
  Method *methods;
  unsigned int i, count;
  methods = class_copyMethodList(cls, &count);
  for (i = 0; i < count; i++)
    rb_ary_push(ary, rb_str_new2((const char *)method_getName(methods[i])));
  free(methods);
#else
  void* iterator = NULL;
  struct objc_method_list* list;

  while (list = class_nextMethodList(cls, &iterator)) {
    int i;
    struct objc_method* methods = list->method_list;
    
    for (i = 0; i < list->method_count; i++) {
      rb_ary_push (ary, rb_str_new2((const char*)(methods[i].method_name)));
    }
  }
#endif

  if (recur && superclass != NULL && !class_isMetaClass(cls))
    _ary_push_objc_methods (ary, superclass, recur);
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
  Method method;

  method = class_getInstanceMethod(cls, sel_registerName(name));
  if (!method)
    return NULL;
  return method_getTypeEncoding(method);
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


static id 
_objc_alias_method (Class klass, VALUE new, VALUE old)
{
  Method me;
  SEL new_name;
  SEL old_name;

  old_name = rbobj_to_nssel(old);
  new_name = rbobj_to_nssel(new);
  me = class_getInstanceMethod(klass, old_name);

  // warn if trying to alias a method that isn't a member of the specified class
  if (me == NULL)
    rb_raise(rb_eRuntimeError, "could not alias '%s' for '%s' to class '%s': Objective-C cannot find it in the class", (char *)new_name, (char *)old_name, class_getName(klass));
  
  class_addMethod(klass, new_name, method_getImplementation(me), method_getTypeEncoding(me));
  
  return nil;
}

static VALUE
wrapper_objc_alias_method (VALUE rcv, VALUE new, VALUE old)
{
  Class klass = rbobj_get_ocid (rcv);
  _objc_alias_method(klass, new, old);
  return rcv;
}

static VALUE
wrapper_objc_alias_class_method (VALUE rcv, VALUE new, VALUE old)
{
  Class klass = (rbobj_get_ocid (rcv))->isa;
  _objc_alias_method(klass, new, old);
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

  rb_define_method(_mClsWrapper, "_objc_alias_method", wrapper_objc_alias_method, 2);
  rb_define_method(_mClsWrapper, "_objc_alias_class_method", wrapper_objc_alias_class_method, 2);

  return Qnil;
}
