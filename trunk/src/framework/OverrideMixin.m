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

static struct objc_method_list* method_list_alloc(long cnt)
{
  struct objc_method_list* mlp;
  mlp = malloc(sizeof(struct objc_method_list) + (cnt-1) * sizeof(struct objc_method));
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
  id ret;
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
  va_end(args);

  // invoke
  [inv setTarget: [rcv slave]];
  [inv setSelector: a_sel];
  [inv invoke];

  // result
  ret = nil;

  return ret;
}

/**
 * instance methods implementation
 **/

static id imp_slave (id rcv, SEL method)
{
  return get_slave(rcv);
}

static id imp_init (id rcv, SEL method)
{
  IMP simp = super_imp(rcv, method);
  id slave = slave_obj_new(rcv);
  set_slave(rcv, slave);
  return (*simp)(rcv, method);
}

static id imp_initWithFrame (id rcv, SEL method, NSRect arg0)
{
  IMP simp = super_imp(rcv, method);
  id slave = slave_obj_new(rcv);
  set_slave(rcv, slave);
  return (*simp)(rcv, method, arg0);
}

static id imp_respondsToSelector (id rcv, SEL method, SEL arg0)
{
  id ret;
  IMP simp = super_imp(rcv, method);
  id slave = get_slave(rcv);
  ret = (*simp)(rcv, method, arg0);
  if (ret == NULL)
    ret = (id) [slave rbobjRespondsToSelector: arg0];
  return ret;
}

static id imp_methodSignatureForSelector (id rcv, SEL method, SEL arg0)
{
  id ret;
  IMP simp = super_imp(rcv, method);
  id slave = get_slave(rcv);
  ret = (*simp)(rcv, method, arg0);
  if (ret == nil)
    ret = [slave rbobjMethodSignatureForSelector: arg0];
  return ret;
}

static id imp_forwardInvocation (id rcv, SEL method, NSInvocation* arg0)
{
  IMP simp = super_imp(rcv, method);
  id slave = get_slave(rcv);

  if ([slave rbobjRespondsToSelector: [arg0 selector]])
    [slave rbobjForwardInvocation: arg0];
  else
    (*simp)(rcv, method, arg0);
  return nil;
}


/**
 * class methods implementation
 **/
static id imp_c_addRubyMethod(Class klass, SEL method, SEL arg0)
{
  Method me;
  struct objc_method_list* mlp = method_list_alloc(1);

  me = class_getInstanceMethod(klass, arg0);
  mlp->method_list[0] = *me;
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
  "slave",
  "init",
  "initWithFrame:",
  "respondsToSelector:",
  "methodSignatureForSelector:",
  "forwardInvocation:",
};

static struct objc_method imp_methods[] = {
  { NULL,
    "@4@4:8",
    (IMP)imp_slave 
  },
  { NULL,
    "@4@4:8",
    (IMP)imp_init
  },
  { NULL,
    "@20@4:8{_NSRect={_NSPoint=ff}{_NSSize=ff}}12",
    (IMP)imp_initWithFrame
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
  }
};


static const char* imp_c_method_names[] = {
  "addRubyMethod:"
};

static struct objc_method imp_c_methods[] = {
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
    imp_ilp = malloc(override_mixin_ivar_list_size());
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
      imp_c_mlp->method_list[i] = imp_c_methods[i];
      imp_c_mlp->method_list[i].method_name = sel_getUid(imp_c_method_names[i]);
      imp_c_mlp->method_count += 1;
    }
  }
  return imp_c_mlp;
}
