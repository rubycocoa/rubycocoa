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
#import "OverrideMixin.h"
#import <Cocoa/Cocoa.h>
#import <RubyCocoa/RBObject.h>
#import <RubyCocoa/RBRuntime.h>
#import <RubyCocoa/ocdata_conv.h>
#import <stdarg.h>

#define sel_to_s(a) NSStringFromSelector((a))

#if 0
#  define LOG0(f)
#  define LOG1(f,a0)
#  define LOG2(f,a0,a1)
#  define LOG3(f,a0,a1,a2)
#else
#  define LOG0(f)          NSLog((f))
#  define LOG1(f,a0)       NSLog((f),(a0))
#  define LOG2(f,a0,a1)    NSLog((f),(a0),(a1))
#  define LOG3(f,a0,a1,a2) NSLog((f),(a0),(a1),(a2))
#endif

static void* alloc_from_default_zone(unsigned int size)
{
  return NSZoneMalloc(NSDefaultMallocZone(), size);
}

static struct objc_method_list* method_list_alloc(long cnt)
{
  struct objc_method_list* mlp;
  mlp = alloc_from_default_zone(sizeof(struct objc_method_list)
				+ (cnt-1) * sizeof(struct objc_method));
  mlp->obsolete = NULL;
  mlp->method_count = 0;
  return mlp;
}

static IMP super_imp(id rcv, SEL a_sel)
{
  return [[rcv superclass] instanceMethodForSelector: a_sel];
}

static id slave_obj_new(id rcv)
{
  return [[RBObject alloc] initWithClass: [rcv class] masterObject: rcv];
}

/**
 *  accessor for instance variables
 **/

static void set_slave(id rcv, id slave)
{
  object_setInstanceVariable(rcv, "m_slave", slave);
}

static id get_slave(id rcv)
{
  id ret;
  object_getInstanceVariable(rcv, "m_slave", (void*)(&ret));
  return ret;
}

/**
 * ruby method handler
 **/

static id handle_ruby_method(id rcv, SEL a_sel, ...)
{
  id ret = nil;
  Method method;
  unsigned  argc, i;
  NSMethodSignature* msig;
  NSInvocation* inv;
  const char* type;
  int offset;
  va_list args;

  // prepare
  msig = [rcv methodSignatureForSelector: a_sel];
  inv = [NSInvocation invocationWithMethodSignature: msig];
  method = class_getInstanceMethod([rcv class], a_sel);
  argc = method_getNumberOfArguments(method);

  // set argument
  va_start(args, a_sel);
  for (i = 2; i < argc; i++) {
    method_getArgumentInfo(method, i, &type, &offset);
    [inv setArgument: args atIndex: i];
    args += offset;
  }

  // invoke
  [inv setTarget: [rcv __slave__]];
  [inv setSelector: a_sel];
  [inv invoke];

  // result
  if ([msig methodReturnLength] > 0) {
    unsigned len = [msig methodReturnLength];
    if (len < sizeof(ret)) {
      void* data = alloca(len);
      [inv getReturnValue: data];
      ret = (id)data;
    }
  }

  va_end(args);
  return ret;
}

/**
 * instance methods implementation
 **/

static id imp_slave (id rcv, SEL method)
{
  return get_slave(rcv);
}

static id imp_rbobj (id rcv, SEL method)
{
  id slave = get_slave(rcv);
  VALUE rbobj = [slave __rbobj__];
  return (id)rbobj;
}

static id imp_respondsToSelector (id rcv, SEL method, SEL arg0)
{
  id ret;
  IMP simp = super_imp(rcv, method);
  id slave = get_slave(rcv);
  ret = (*simp)(rcv, method, arg0);
  if (ret == NULL)
    ret = (id) [slave respondsToSelector: arg0];
  return ret;
}

static id imp_methodSignatureForSelector (id rcv, SEL method, SEL arg0)
{
  id ret;
  IMP simp = super_imp(rcv, method);
  id slave = get_slave(rcv);
  ret = (*simp)(rcv, method, arg0);
  if (ret == nil)
    ret = [slave methodSignatureForSelector: arg0];
  return ret;
}

static id imp_forwardInvocation (id rcv, SEL method, NSInvocation* arg0)
{
  IMP simp = super_imp(rcv, method);
  id slave = get_slave(rcv);

  if ([slave respondsToSelector: [arg0 selector]])
    [slave forwardInvocation: arg0];
  else
    (*simp)(rcv, method, arg0);
  return nil;
}

static id imp_supersend (id rcv, SEL method, SEL a_sel,...)
{
  id ret = nil;
  va_list args;
  IMP simp;

  simp = super_imp(rcv, a_sel);
  va_start(args, a_sel);
  NSLog(@"imp_supersend not implemented");
  // ret = (*simp)(rcv, a_sel, args);
  va_end(args);
  return ret;
}

/**
 * class methods implementation
 **/
static id imp_c_alloc(Class klass, SEL method)
{
  id new_obj;
  id slave;
  new_obj = class_createInstance(klass, 0);
  slave = slave_obj_new(new_obj);
  set_slave(new_obj, slave);
  return new_obj;
}

static id imp_c_allocWithZone(Class klass, SEL method, NSZone* zone)
{
  id new_obj;
  id slave;
  new_obj = class_createInstanceFromZone(klass, 0, zone);
  slave = slave_obj_new(new_obj);
  set_slave(new_obj, slave);
  return new_obj;
}

static id imp_c_addRubyMethod(Class klass, SEL method, SEL arg0)
{
  Method me;
  struct objc_method_list* mlp = method_list_alloc(1);

  me = class_getInstanceMethod(klass, arg0);
  mlp->method_list[0].method_name = me->method_name;
  mlp->method_list[0].method_types = strdup(me->method_types);
  mlp->method_list[0].method_imp = handle_ruby_method;
  mlp->method_count += 1;

  class_addMethods(klass, mlp);
  return nil;
}



static struct objc_ivar imp_ivars[] = {
  {				// struct objc_ivar {
    "m_slave",			//   char *ivar_name;
    "@",			//   char *ivar_type;
    0,				//    int ivar_offset;
#ifdef __alpha__
    0				//    int space;
#endif
  }                             // } ivar_list[1];
};

static const char* imp_method_names[] = {
  "__slave__",
  "__rbobj__",
  "respondsToSelector:",
  "methodSignatureForSelector:",
  "forwardInvocation:",
#if 0
  "supersend:"
#endif
};

static struct objc_method imp_methods[] = {
  { NULL,
    "@4@4:8",
    (IMP)imp_slave 
  },
  { NULL,
    "L4@4:8",
    (IMP)imp_rbobj 
  },
  { NULL,
    "c8@4:8:12",
    (IMP)imp_respondsToSelector
  },
  { NULL,
    "@8@4:8:12",
    (IMP)imp_methodSignatureForSelector
  },
  { NULL,
    "v8@4:8@12",
    (IMP)imp_forwardInvocation
  },
#if 0
  { NULL,
    "@12@4:8:16",
    (IMP)imp_supersend
  }
#endif

};


static const char* imp_c_method_names[] = {
  "alloc",
  "allocWithZone:",
  "addRubyMethod:"
};

static struct objc_method imp_c_methods[] = {
  { NULL,
    "@4@4:8",
    (IMP)imp_c_alloc
  },
  { NULL,
    "@8@4:8^{_NSZone=}12",
    (IMP)imp_c_allocWithZone
  },
  { NULL,
    "@4@4:8:12",
    (IMP)imp_c_addRubyMethod
  }
};

long override_mixin_ivar_list_size()
{
  long cnt = sizeof(imp_ivars) / sizeof(struct objc_ivar);
  return (sizeof(struct objc_ivar_list)
	  - sizeof(struct objc_ivar)
	  + (cnt * sizeof(struct objc_ivar)));
}

struct objc_ivar_list* override_mixin_ivar_list()
{
  static struct objc_ivar_list* imp_ilp = NULL;
  if (imp_ilp == NULL) {
    int i;
    imp_ilp = alloc_from_default_zone(override_mixin_ivar_list_size());
    imp_ilp->ivar_count = sizeof(imp_ivars) / sizeof(struct objc_ivar);
    for (i = 0; i < imp_ilp->ivar_count; i++) {
      imp_ilp->ivar_list[i] = imp_ivars[i];
    }
  }
  return imp_ilp;
}

struct objc_method_list* override_mixin_method_list()
{
  static struct objc_method_list* imp_mlp = NULL;
  if (imp_mlp == NULL) {
    int i;
    long cnt = sizeof(imp_methods) / sizeof(struct objc_method);
    imp_mlp = method_list_alloc(cnt);
    for (i = 0; i < cnt; i++) {
      imp_mlp->method_list[i] = imp_methods[i];
      imp_mlp->method_list[i].method_name = sel_getUid(imp_method_names[i]);
      imp_mlp->method_count += 1;
    }
  }
  return imp_mlp;
}

struct objc_method_list* override_mixin_class_method_list()
{
  static struct objc_method_list* imp_c_mlp = NULL;
  if (imp_c_mlp == NULL) {
    int i;
    long cnt = sizeof(imp_c_methods) / sizeof(struct objc_method);
    imp_c_mlp = method_list_alloc(cnt);
    for (i = 0; i < cnt; i++) {
      imp_c_mlp->method_list[i]  = imp_c_methods[i];
      imp_c_mlp->method_list[i].method_name = sel_getUid(imp_c_method_names[i]);
      imp_c_mlp->method_count += 1;
    }
  }
  return imp_c_mlp;
}
