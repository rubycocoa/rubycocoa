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
#import <string.h>
#import <stdlib.h>
#import <stdarg.h>

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

static VALUE
rb_ocdataconv_exception_class()
{
  VALUE val;
  VALUE mosx;
  VALUE klass;
  
  mosx = rb_const_get(rb_cObject, rb_intern("OSX"));;
  klass = rb_const_get(mosx, rb_intern("OCDataConvException"));
  return klass;
}

static BOOL
ocm_perform(int argc, VALUE* argv, VALUE rcv, VALUE* result)
{
  id oc_rcv = rbobj_get_ocid(rcv);
  SEL oc_sel;
  id oc_sel_str;
  const char* ret_type;
  int num_of_args;
  id args[2];
  id pool;
  id oc_result;
  id oc_msig;
  int i;
  VALUE excp = Qnil;

  if (oc_rcv == nil) return NO;

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
  oc_sel_str = NSStringFromSelector(oc_sel);
  DLOG2("ocm_perfom (%@): ret_type=%s", oc_sel_str, ret_type);

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

  DLOG1("    NSObject#performSelector (%@) ...", oc_sel_str);

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
    DLOG2("    NSObject#performSelector (%@): raise %@",
	  oc_sel_str, localException);
    excp = rb_ocexception_s_new(localException);

  NS_ENDHANDLER
  if (excp != Qnil) {
    rb_funcall(rb_mKernel, rb_intern("raise"), 1, excp);
  }
  
  DLOG1("    NSObject#performSelector (%@): done.", oc_sel_str);

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
  id oc_rcv = rbobj_get_ocid(rcv);
  SEL oc_sel;
  id oc_sel_str;
  const char* ret_type;
  int num_of_args;
  id pool;
  id oc_result;
  id oc_msig;
  id oc_inv;
  int i;
  unsigned ret_len;
  VALUE excp = Qnil;

  if (oc_rcv == nil) return NO;

  if (argc < 1) return NO;

  oc_sel = rbobj_to_nssel(argv[0]);
  argc--;
  argv++;

  oc_msig = [oc_rcv methodSignatureForSelector: oc_sel];
  if (oc_msig == nil) return NO;

  ret_type = [oc_msig methodReturnType];
  num_of_args = [oc_msig numberOfArguments] - 2;

  pool = [[NSAutoreleasePool alloc] init];
  oc_sel_str = NSStringFromSelector(oc_sel);
  DLOG2("ocm_invoke (%@): ret_type=%s", oc_sel_str, ret_type);

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
    ocdata = OCDATA_ALLOCA(octype, octype_str);
    if (octype == _PRIV_C_ID_PTR) {
      if (arg == Qnil) {
	*(id**)ocdata = NULL;
	f_conv_success = YES;
      }
      else if (rb_obj_is_kind_of(arg, rb_cls_objcid()) == Qtrue) {
	id old_id = OCID_OF(arg);
	if (old_id) [old_id release];
	*(id**)ocdata = &OCID_OF(arg);
	f_conv_success = YES;
      }
      else {
	f_conv_success = NO;
      }
    }
    else {
      f_conv_success = rbobj_to_ocdata(arg, octype, ocdata);
    }
    if (f_conv_success) {
      [oc_inv setArgument: ocdata atIndex: (i+2)];
    }
    else {
      [pool release];
      rb_raise(rb_ocdataconv_exception_class(),
	       "cannot convert the argument #%d as '%s' to NS argument.",
	       i, octype_str);
      return NO;
    }
  }

  DLOG1("    NSInvocation#invoke (%@) ...", oc_sel_str);
  NS_DURING
    [oc_inv invoke];

  NS_HANDLER
    DLOG2("    NSInvocation#invoke (%@): raise %@", oc_sel_str, localException);
    excp = rb_ocexception_s_new(localException);

  NS_ENDHANDLER
  if (excp != Qnil) {
    rb_funcall(rb_mKernel, rb_intern("raise"), 1, excp);
  }

  DLOG1("    NSInvocation#invoke (%@): done.", oc_sel_str);

  // get result as argument
  for (i = 0; i < num_of_args; i++) {
    VALUE arg = argv[i];
    if (arg == Qnil) continue;
    if (rb_obj_is_kind_of(arg, rb_cls_objcid()) != Qtrue) continue;
    if (to_octype([oc_msig getArgumentTypeAtIndex: (i+2)]) != _PRIV_C_ID_PTR) continue;
    if (OCID_OF(arg))
      [OCID_OF(arg) retain];
  }

  // get result
  ret_len = [oc_msig methodReturnLength];
  if (ret_len > 0) {
    int octype = to_octype([oc_msig methodReturnType]);
    BOOL f_conv_success;
    void* result_data = alloca(ret_len);
    [oc_inv getReturnValue: result_data];
    f_conv_success = ocdata_to_rbobj(rcv, octype, result_data, result);
    if (!f_conv_success) {
      [pool release];
      rb_raise(rb_ocdataconv_exception_class(),
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

static BOOL
ocm_send(int argc, VALUE* argv, VALUE rcv, VALUE* result)
{
  BOOL ret = NO;
  if (argc < 1) return NO;

  DLOG0("ocm_send ...");

  if (ocm_perform(argc, argv, rcv, result)) ret = YES;
  else if (ocm_invoke(argc, argv, rcv, result)) ret = YES;
  DLOG0("ocm_send done");

  return ret;
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
wrapper_to_s (VALUE rcv)
{
  VALUE ret = Qnil;
  id oc_rcv = rbobj_get_ocid(rcv);
  if ([oc_rcv isKindOfClass: [NSString class]]) {
    ret = rb_str_new ([oc_rcv cString], [oc_rcv cStringLength]);
  }
  else {
    id pool = [[NSAutoreleasePool alloc] init];
    oc_rcv = [oc_rcv description];
    ret = rb_str_new ([oc_rcv cString], [oc_rcv cStringLength]);
    [pool release];
  }
  return ret;
}

/*****************************************/

VALUE
init_mdl_OCObjWrapper(VALUE outer)
{
  _mObjWrapper = rb_define_module_under(outer, "OCObjWrapper");

  rb_define_method(_mObjWrapper, "ocm_responds?", wrapper_ocm_responds_p, 1);
  rb_define_method(_mObjWrapper, "ocm_perform", wrapper_ocm_perform, -1);
  rb_define_method(_mObjWrapper, "ocm_invoke", wrapper_ocm_invoke, -1);
  rb_define_method(_mObjWrapper, "ocm_send", wrapper_ocm_send, -1);
  rb_define_method(_mObjWrapper, "to_s", wrapper_to_s, 0);

  return _mObjWrapper;
}
