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
#import <Foundation/NSMethodSignature.h>
#import <Foundation/NSInvocation.h>
#import <LibRuby/cocoa_ruby.h>
#import "ocdata_conv.h"
#import "delegate_utils.h"
#import "RubyObject.h"
#import <objc/objc-class.h>
#import <stdarg.h>

static id overrided_invoke(id rcv, SEL a_sel, ...)
{
  int i;
  va_list args;
  NSMethodSignature* msig;
  NSInvocation* inv;
  id retval = nil;
  msig = [rcv methodSignatureForSelector: a_sel];
  inv = [NSInvocation invocationWithMethodSignature: msig];
  [inv setSelector: a_sel];
  [inv setTarget: [rcv rubyDelegator]];
  va_start(args, a_sel);
  for (i = 2; i < [msig numberOfArguments]; i++) {
    int octype = to_octype([msig getArgumentTypeAtIndex: i]);
    void* ocdata = ocdata_malloc_va_arg(args, octype); // r = va_arg(args, NSRect);
    if (ocdata) {
      [inv setArgument: ocdata atIndex: i];
      free(ocdata);
    }
    else {
      ; // errror
    }
  }
  va_end(args);
  [inv invoke];
  if ([msig methodReturnLength] > 0) {
    if (octype_object_p(to_octype([msig methodReturnType]))) {
      [inv getReturnValue: &retval];
    }
  }
  return retval;
}

static VALUE ruby_methods_of(VALUE klass)
{
  // klass.instance_methods - klass.superclass.instance_methods
  VALUE super_klass = rb_funcall(klass, rb_intern("superclass"), 0);
  VALUE methods = rb_funcall(klass, rb_intern("instance_methods"), 0);
  if (super_klass != Qnil) {
    VALUE super_methods = 
      rb_funcall(super_klass, rb_intern("instance_methods"), 0);
    methods = rb_funcall(methods, rb_intern("-"), 1, super_methods);
  }
  return methods;
}

void install_delegator_methods(Class nsclass, VALUE klass)
{
  VALUE methods;
  int i,cnt;

  methods = ruby_methods_of(klass);
  cnt = RARRAY(methods)->len;
  for (i = 0; i < cnt; i++) {
    VALUE mstr = rb_ary_entry(methods, i);
    SEL sels[2];
    int j;
    sels[0] = rbobj_to_nssel(mstr);
    sels[1] = rbobj_to_nssel(rb_str_cat2(mstr, ":"));
    for (j = 0; j < sizeof(sels) - sizeof(SEL); j++) {
      Method me = class_getInstanceMethod(nsclass, sels[j]);
      if (me != NULL) {
	struct objc_method_list info;
	info.obsolete = NULL;
	info.method_count = 1;
	info.method_list[0] = *me;
	info.method_list[0].method_imp = overrided_invoke;
	class_addMethods(nsclass, &info);
	break;
      }
    }
  }
}  
