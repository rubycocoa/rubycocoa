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
#import <Foundation/Foundation.h>
#import <stdarg.h>
#import "OverrideMixin.h"
#import "RBSlaveObject.h"
#import "RBRuntime.h"
#import "RBClassUtils.h"
#import "ocdata_conv.h"

#define sel_to_s(a) NSStringFromSelector((a))

#ifdef GNUSTEP
static Ivar_t
object_setInstanceVariable(id anObj, const char *aName, id aValue)
{
    Class aClass = anObj->class_pointer;
    IvarList_t ivars = aClass->ivars;
    int i;

    for( i = 0; i < ivars->ivar_count; i++ ) {
	Ivar_t ivar = &ivars->ivar_list[i];
	if( !strcmp(aName, ivar->ivar_name) ) {
	    *(id *)((char *)anObj + ivar->ivar_offset) = aValue;
	    return ivar;
	}
    }
    return NULL;
}

static Ivar_t
object_getInstanceVariable(id anObj, const char *aName, id *aValue)
{
    Class aClass = anObj->class_pointer;
    IvarList_t ivars = aClass->ivars;
    int i;

    for( i = 0; i < ivars->ivar_count; i++ ) {
	Ivar_t ivar = &ivars->ivar_list[i];
	if( !strcmp(aName, ivar->ivar_name) ) {
	    *aValue = *(id *)((char *)anObj + ivar->ivar_offset);
	    return ivar;
	}
    }
    return NULL;
}

const char *
NSGetSizeAndAlignment(const char *typePtr, unsigned int *sizep, unsigned int *alignp)
{
    *sizep  = objc_sizeof_type(typePtr);
    *alignp = objc_alignof_type(typePtr);
    return objc_skip_typespec(typePtr);
}
#endif

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
  return NSZoneCalloc(NSDefaultMallocZone(), 1, size);
}

static struct objc_method_list* method_list_alloc(long cnt)
{
  struct objc_method_list* mlp;
  mlp = alloc_from_default_zone(sizeof(struct objc_method_list)
				+ (cnt-1) * sizeof(struct objc_method));
  return mlp;
}

static SEL super_selector(SEL a_sel)
{
  id pool;
  NSString* str;

  pool = [[NSAutoreleasePool alloc] init];
  str = [@"super:" stringByAppendingString: NSStringFromSelector(a_sel)];
  // GNUstep initially sets all selectors to cStrings and resolves them later
#ifdef GNUSTEP
  a_sel = (SEL)[str cString];
#else
  a_sel = NSSelectorFromString(str);
#endif
  [pool release];
  return a_sel;
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
  NSMethodSignature* msig;
  NSInvocation* inv;
  va_list args;
  int i;
  unsigned retlen;
  const char* type;

  // prepare
  msig = [rcv methodSignatureForSelector: a_sel];
  inv = [NSInvocation invocationWithMethodSignature: msig];
  method = class_getInstanceMethod([rcv class], a_sel);

  // set argument
  va_start(args, a_sel);
  type = method->method_types;

  // method_types include return result, receiver, and selector.

  for (i = 0; *type; i++) {
    unsigned int size;
    unsigned int align;
    type = NSGetSizeAndAlignment(type, &size, &align);
    while( *type && isdigit(*type) ) ++type;
    if( i < 3 )
	continue;
    [inv setArgument: args atIndex: i - 1];
    args += (size + align - 1) & ~(align - 1);
  }

  // invoke
  [inv setTarget: [rcv __slave__]];
  [inv setSelector: a_sel];
  [inv invoke];

  // result
  retlen = [msig methodReturnLength];
  if ( retlen > 0) {
    if (retlen < sizeof(ret)) {
      void* data = alloca(retlen);
      [inv getReturnValue: data];
      if (retlen == sizeof(char))
	ret = (id)(unsigned long)(*(unsigned char*)data);
      else if (retlen == sizeof(short))
	ret = (id)(unsigned long)(*(unsigned short*)data);
      else
	rb_raise( rb_eRuntimeError,
		  "handle_ruby_method('%s'): can't handle the return value!",
		  (char*)a_sel);
    }
    else if (retlen == sizeof(ret)) {
      [inv getReturnValue: &ret];
    }
    else {
      // should we raise an error here, because we can't handle the
      // return value properly?
      rb_raise( rb_eRuntimeError,
		"handle_ruby_method('%s'): can't handle the return value!",
		(char*)a_sel);
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
    ret = (id)([slave respondsToSelector: arg0] ? YES : NO);
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

static id imp_valueForUndefinedKey (id rcv, SEL method, NSString* key)
{
  id ret = nil;
  id slave = get_slave(rcv);

  if ([slave respondsToSelector: @selector(rbValueForKey:)])
    ret = (id)[slave rbValueForKey: key];
  else
    ret = [rcv performSelector: super_selector(method) withObject: key];
  return ret;
}

static void imp_setValue_forUndefinedKey (id rcv, SEL method, id value, NSString* key)
{
  id slave = get_slave(rcv);

  if ([slave respondsToSelector: @selector(rbSetValue:forKey:)])
    [slave rbSetValue: value forKey: key];
  else
    [rcv performSelector: super_selector(method) withObject: value withObject: key];
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
  struct objc_method_list* mlp = method_list_alloc(2);

  me = class_getInstanceMethod(klass, arg0);

  // warn if trying to override a method that isn't a member of the specified class
  if(me == NULL) {
    rb_raise( rb_eRuntimeError, 
	      "could not add '%s' to class '%s': "
	      "Objective-C cannot find it in the superclass",
	      (char *) arg0, klass->name );
  }
  else {
    // override method
    mlp->method_list[0].method_name = me->method_name;
    mlp->method_list[0].method_types = strdup(me->method_types);
    mlp->method_list[0].method_imp = handle_ruby_method;
    mlp->method_count += 1;

    // super method
    mlp->method_list[1].method_name = super_selector(me->method_name);
    mlp->method_list[1].method_types = strdup(me->method_types);
    mlp->method_list[1].method_imp = me->method_imp;
    mlp->method_count += 1;
  }

  class_addMethods(klass, mlp);
  return nil;
}

static id imp_c_addRubyMethod_withType(Class klass, SEL method, SEL arg0, const char *type)
{
  struct objc_method_list* mlp = method_list_alloc(1);

  // add method
  mlp->method_list[0].method_name = sel_registerName(arg0);
  mlp->method_list[0].method_types = strdup(type);
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

/**
 *  instance methods
 **/
static const char* imp_method_names[] = {
  "__slave__",
  "__rbobj__",
  "respondsToSelector:",
  "methodSignatureForSelector:",
  "forwardInvocation:",
  "valueForUndefinedKey:",
  "setValue:forUndefinedKey:",
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
  { NULL,
    "@12@0:4@8",
    (IMP)imp_valueForUndefinedKey
  },
  { NULL,
    "v16@0:4@8@12",
    (IMP)imp_setValue_forUndefinedKey
  },
};


/**
 *  class methods
 **/
static const char* imp_c_method_names[] = {
  "alloc",
  "allocWithZone:",
  "addRubyMethod:",
  "addRubyMethod:withType:",
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
  },
  { NULL,
    "@4@4:8:12*16",
    (IMP)imp_c_addRubyMethod_withType
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
