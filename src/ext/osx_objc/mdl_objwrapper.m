/** -*-objc-*-
 *
 *   $Id$
 *
 *   Copyright (c) 2001 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
 *
 *   This program is free software.
 *   You can distribute/modify this program under the terms of
 *   the GNU Lesser General Public License version 2.
 *
 **/

#import <LibRuby/cocoa_ruby.h>
#import <RubyCocoa/ocdata_conv.h> // RubyCocoa.framework
#import <Foundation/Foundation.h>
#import <objc/objc-class.h>
#import <string.h>
#import <stdlib.h>
#import <stdarg.h>

#import "cls_objcid.h"

static VALUE _mObjWrapper = Qnil;

#define DLOG0(f)          if (ruby_debug == Qtrue) _debug_log((f))
#define DLOG1(f,a1)       if (ruby_debug == Qtrue) _debug_log((f),(a1))
#define DLOG2(f,a1,a2)    if (ruby_debug == Qtrue) _debug_log((f),(a1),(a2))
#define DLOG3(f,a1,a2,a3) if (ruby_debug == Qtrue) _debug_log((f),(a1),(a2),(a3))

static void
_debug_log(const char* fmt,...)
{
  if (ruby_debug == Qtrue) {
    id pool = [[NSAutoreleasePool alloc] init];
    NSString* nsfmt = [NSString stringWithFormat: @"OBJWRP:%s", fmt];
    va_list args;
    va_start(args, fmt);
    NSLogv(nsfmt, args);
    va_end(args);
    [pool release];
  }
}

static id
rb_objwrapper_ocid(VALUE rcv)
{
  RB_ID mtd;

  if (rb_obj_is_kind_of(rcv, rb_objcid()) == Qtrue)
    return rb_objcid_ocid(rcv);

  mtd = rb_intern("__ocid__");
  if (rb_respond_to(rcv, mtd)) {
    rcv = rb_funcall(rcv, mtd, 0);
    return (id) NUM2UINT(rcv);
  }

  return nil;
}

static VALUE
rb_ocexception_s_new(NSException* nsexcp)
{
  VALUE val;
  VALUE mosx;
  VALUE klass;
  
  mosx = rb_const_get(rb_cObject, rb_intern("OSX"));;
  klass = rb_const_get(mosx, rb_intern("OCException"));
  val = ocid_to_rbobj(Qnil, nsexcp);
  return rb_funcall(klass, rb_intern("new"), 1, val);
}

static BOOL
ocm_perform(int argc, VALUE* argv, VALUE rcv, VALUE* result)
{
  id oc_rcv = rb_objwrapper_ocid(rcv);
  SEL oc_sel;
  const char* ret_type;
  int num_of_args;
  id args[2];
  id pool;
  id oc_result;
  id oc_msig;
  int i;
  VALUE excp = Qnil;

  if ((argc < 1) || (argc > 3)) return NO;

  oc_sel = rbobj_to_nssel(argv[0]);
  argc--;
  argv++;

  oc_msig = [oc_rcv methodSignatureForSelector: oc_sel];
  if (oc_msig == nil) return NO;

  ret_type = [oc_msig methodReturnType];
  if (*ret_type != _C_ID && *ret_type != _C_CLASS) return NO;

  num_of_args = [oc_msig numberOfArguments] - 2;
  if (num_of_args > 2) return NO;

  pool = [[NSAutoreleasePool alloc] init];
  DLOG2("ocm_perfom (%@): ret_type=%s", NSStringFromSelector(oc_sel), ret_type);

  for (i = 0; i < num_of_args; i++) {
    const char* arg_type = [oc_msig getArgumentTypeAtIndex: (i+2)];
    DLOG2("    arg_type[%d]: %s", i, arg_type);
    if (*arg_type != _C_ID && *arg_type != _C_CLASS) return NO;
    args[i] = nil;
    if (i < argc) {
      if (!rbobj_to_nsobj(argv[i], &(args[i]))) {
	[pool release];
	return NO;
      }
    }
  }

  DLOG0("    NSObject#performSelector ...");

  NS_DURING  
    switch (num_of_args) {
    case 0:
      oc_result = [oc_rcv performSelector: oc_sel];
      break;
    case 1:
      oc_result = [oc_rcv performSelector: oc_sel withObject: args[0]];
      break;
    case 2:
      oc_result = [oc_rcv performSelector: oc_sel withObject: args[0]
			  withObject: args[1]];
      break;
    default:
      oc_result = nil;
    }

  NS_HANDLER
    excp = rb_ocexception_s_new(localException);

  NS_ENDHANDLER
  if (excp != Qnil) {
    rb_funcall(rb_mKernel, rb_intern("raise"), 1, excp);
  }
  
  DLOG0("    NSObject#performSelector: done.");

  if (oc_result == oc_rcv)
    *result = rcv;
  else
    *result = ocid_to_rbobj(rcv, oc_result);

  [pool release];
  return YES;
}

static BOOL
ocm_invoke(int argc, VALUE* argv, VALUE rcv, VALUE* result)
{
  id oc_rcv = rb_objwrapper_ocid(rcv);
  SEL oc_sel;
  const char* ret_type;
  int num_of_args;
  id pool;
  id oc_result;
  id oc_msig;
  id oc_inv;
  int i;
  VALUE excp = Qnil;

  if (argc < 1) return NO;

  oc_sel = rbobj_to_nssel(argv[0]);
  argc--;
  argv++;

  oc_msig = [oc_rcv methodSignatureForSelector: oc_sel];
  if (oc_msig == nil) return NO;

  ret_type = [oc_msig methodReturnType];
  num_of_args = [oc_msig numberOfArguments] - 2;

  pool = [[NSAutoreleasePool alloc] init];
  DLOG2("ocm_invoke (%@): ret_type=%s", NSStringFromSelector(oc_sel), ret_type);

  oc_inv = [NSInvocation invocationWithMethodSignature: oc_msig];
  [oc_inv setTarget: oc_rcv];
  [oc_inv setSelector: oc_sel];

  // set arguments
  for (i = 0; i < num_of_args; i++) {
    VALUE arg = (i < argc) ? argv[i] : Qnil;
    const char* octype_str = [oc_msig getArgumentTypeAtIndex: (i+2)];
    int octype = to_octype(octype_str);
    void* ocdata;
    BOOL f_conv_success;
    DLOG2("    arg_type[%d]: %s", i, octype_str);
    ocdata = ocdata_malloc(octype);
    f_conv_success = rbobj_to_ocdata(arg, octype, ocdata);
    if (f_conv_success) {
      [oc_inv setArgument: ocdata atIndex: (i+2)];
      free(ocdata);
    }
    else {
      free(ocdata);
      [pool release];
      rb_raise(rb_eRuntimeError,
	       "cannot convert the argument #%d as '%s' to NS argument.",
	       i, octype_str);
      return NO;
    }
  }

  DLOG0("    NSInvocation#invoke ...");
  NS_DURING
    [oc_inv invoke];

  NS_HANDLER
    excp = rb_ocexception_s_new(localException);

  NS_ENDHANDLER
  if (excp != Qnil) {
    rb_funcall(rb_mKernel, rb_intern("raise"), 1, excp);
  }

  DLOG0("    NSInvocation#invoke: done.");

  // get result
  if ([oc_msig methodReturnLength] > 0) {
    int octype = to_octype([oc_msig methodReturnType]);
    BOOL f_conv_success;
    void* result_data = ocdata_malloc(octype);
    [oc_inv getReturnValue: result_data];
    f_conv_success = ocdata_to_rbobj(rcv, octype, result_data, result);
    free(result_data);
    if (!f_conv_success) {
      [pool release];
      rb_raise(rb_eRuntimeError,
	       "cannot convert the result as '%s' to Ruby Object.", ret_type);
      return NO;
    }
  }
  else {
    *result = nil;
  }

  [pool release];
  return YES;
}


static Ivar
ivar_for(id ocrcv, SEL a_sel)
{
  id pool = [[NSAutoreleasePool alloc] init];
  id nsname = NSStringFromSelector(a_sel);
  Ivar iv = class_getInstanceVariable([ocrcv class], [nsname cString]);
  [pool release];
  return iv;
}

static BOOL
ocm_ivar(VALUE rcv, VALUE name, VALUE* result)
{
  BOOL f_ok = NO;
  id ocrcv = rb_objwrapper_ocid(rcv);
  id pool = [[NSAutoreleasePool alloc] init];
  id nsname = rbobj_to_nsselstr(name);
  Ivar iv = class_getInstanceVariable([ocrcv class], [nsname cString]);
  DLOG1("ocm_ivar (%@)", nsname);
  if (iv) {
    int octype = to_octype(iv->ivar_type);
    void* val;
    DLOG2("    ocm_ivar (%@) ret_type: %s", nsname, iv->ivar_type);
    iv = object_getInstanceVariable(ocrcv, [nsname cString], &val);
    f_ok = ocdata_to_rbobj(rcv, octype, val, result);
  }
  [pool release];
  return f_ok;
}

static BOOL
ocm_send(int argc, VALUE* argv, VALUE rcv, VALUE* result)
{
  BOOL ret = NO;
  if (argc < 1) return NO;

  DLOG0("ocm_send ...");

  if (ocm_perform(argc, argv, rcv, result)) ret = YES;
  else if (ocm_invoke(argc, argv, rcv, result)) ret = YES;
  else if (ocm_ivar(rcv, argv[0], result)) ret = YES;
  DLOG0("ocm_send done");

  return ret;
}

/*************************************************/

static VALUE
wrapper_ocid(VALUE rcv)
{
  return UINT2NUM((unsigned long) rb_objwrapper_ocid(rcv));
}

static VALUE
wrapper_inspect(VALUE rcv)
{
  VALUE result;
  char s[256];
  id oc_rcv = rb_objwrapper_ocid(rcv);
  id pool = [[NSAutoreleasePool alloc] init];
  const char* class_desc = [[[oc_rcv class] description] cString];
  const char* desc = [[oc_rcv description] cString];
  snprintf(s, sizeof(s), "#<OCObject:0x%x class='%s' id=%X>",
	   NUM2ULONG(rb_obj_id(rcv)), class_desc, oc_rcv);
  result = rb_str_new2(s);
  [pool release];
  return result;
}

static VALUE
wrapper_ocm_responds_p(VALUE rcv, VALUE sel)
{
  VALUE result = Qfalse;
  id oc_rcv = rb_objwrapper_ocid(rcv);
  SEL oc_sel = rbobj_to_nssel(sel);
  if ([oc_rcv respondsToSelector: oc_sel] == NO) {
    if (ivar_for(oc_rcv, oc_sel) != nil)
      result = YES;
  }
  return result;
}

static VALUE
wrapper_ocm_perform(int argc, VALUE* argv, VALUE rcv)
{
  VALUE result;
  id pool = [[NSAutoreleasePool alloc] init];
  if (!ocm_perform(argc, argv, rcv, &result)) {
    [pool release];
    if (argc > 0) {
      VALUE asstr = rb_obj_as_string(argv[0]);
      rb_raise(rb_eRuntimeError, "ocm_perform failed: %s", STR2CSTR(asstr));
    }
    else {
      rb_raise(rb_eRuntimeError, "ocm_perform failed");
    }
  }
  [pool release];
  return result;
}

static VALUE
wrapper_ocm_invoke(int argc, VALUE* argv, VALUE rcv)
{
  VALUE result;
  id pool = [[NSAutoreleasePool alloc] init];
  if (!ocm_invoke(argc, argv, rcv, &result)) {
    [pool release];
    if (argc > 0) {
      VALUE asstr = rb_obj_as_string(argv[0]);
      rb_raise(rb_eRuntimeError, "ocm_invoke failed: %s", STR2CSTR(asstr));
    }
    else {
      rb_raise(rb_eRuntimeError, "ocm_invoke failed");
    }
  }
  [pool release];
  return result;
}

static VALUE
wrapper_ocm_ivar(VALUE rcv, VALUE name)
{
  VALUE result;
  id pool = [[NSAutoreleasePool alloc] init];
  if (!ocm_ivar(rcv, name, &result)) {
    [pool release];
    rb_raise(rb_eRuntimeError, "ocm_ivar failed");
  }
  [pool release];
  return result;
}

static VALUE
wrapper_ocm_send(int argc, VALUE* argv, VALUE rcv)
{
  VALUE result;
  id pool = [[NSAutoreleasePool alloc] init];
  if (!ocm_send(argc, argv, rcv, &result)) {
    [pool release];
    if (argc > 0) {
      VALUE asstr = rb_obj_as_string(argv[0]);
      rb_raise(rb_eRuntimeError, "ocm_send failed: %s", STR2CSTR(asstr));
    }
    else {
      rb_raise(rb_eRuntimeError, "ocm_send failed");
    }
  }
  [pool release];
  return result;
}

static VALUE
wrapper_m_rbobj_to_ocid(VALUE mdl, VALUE arg)
{
  id ocid = rb_objwrapper_ocid(arg);
  return UINT2NUM((unsigned int) ocid);
}

/*****************************************/

VALUE
init_mdl_OCObjWrapper(VALUE outer)
{
  _mObjWrapper = rb_define_module_under(outer, "OCObjWrapper");

  rb_define_module_function(_mObjWrapper, "rbobj_to_ocid",
			    wrapper_m_rbobj_to_ocid, 1);

  rb_define_method(_mObjWrapper, "__ocid__", wrapper_ocid, 0);
  rb_define_method(_mObjWrapper, "__inspect__", wrapper_inspect, 0);

  rb_define_method(_mObjWrapper, "ocm_responds?", wrapper_ocm_responds_p, 1);
  rb_define_method(_mObjWrapper, "ocm_perform", wrapper_ocm_perform, -1);
  rb_define_method(_mObjWrapper, "ocm_invoke", wrapper_ocm_invoke, -1);
  rb_define_method(_mObjWrapper, "ocm_ivar", wrapper_ocm_ivar, 1);
  rb_define_method(_mObjWrapper, "ocm_send", wrapper_ocm_send, -1);

  return _mObjWrapper;
}
