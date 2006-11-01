/** -*-objc-*-
 *
 *   $Id$
 *
 *   Copyright (c) 2001 FUJIMOTO Hisakuni
 *
 **/
#import <Cocoa/Cocoa.h>
#import <stdarg.h>
#import <pthread.h>
#import "OverrideMixin.h"
#import "RBObject.h"
#import "RBSlaveObject.h"
#import "RBRuntime.h"
#import "RBClassUtils.h"
#import "ocdata_conv.h"
#import "BridgeSupport.h"
#import "st.h"

#define OVMIX_LOG(fmt, args...) DLOG("OVMIX", fmt, ##args)

/* On MacOS X, +signatureWithObjCTypes: is a method of NSMethodSignature,
 * but that method is not present in the header files. We add the definition
 * here to avoid warnings.
 *
 * XXX: We use an undocumented API, but we also don't have much choice: we
 * must create the things and this is the only way to do it...
 */
@interface NSMethodSignature (WarningKiller)
+ (id) signatureWithObjCTypes:(const char*)types;
@end

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

static SEL super_selector(SEL a_sel)
{
  char selName[1024];

  snprintf (selName, sizeof selName, "super:%s", sel_getName(a_sel));
  return sel_registerName(selName);
}

static IMP super_imp(id rcv, SEL a_sel, IMP origin_imp)
{
  IMP ret = NULL;
  Class klass = [rcv class];

  while (klass = [klass superclass]) {
    ret = [klass instanceMethodForSelector: a_sel];
    if (ret && ret != origin_imp)
      return ret;
  }
  return NULL;
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

/* Implemented in RBObject.m for now, still private. */
VALUE rbobj_call_ruby(id rbobj, SEL selector, VALUE args);

static void
ovmix_ffi_closure(ffi_cif* cif, void* resp, void** args, void* userdata)
{
  int retval_octype;
  int *args_octypes;
  VALUE rb_args;
  unsigned i;
  VALUE retval;

  OVMIX_LOG("ffi_closure cif %p nargs %d", cif, cif->nargs); 

  retval_octype = *(int *)userdata;
  args_octypes = &((int *)userdata)[1];
  rb_args = rb_ary_new2(cif->nargs - 2);

  for (i = 2; i < cif->nargs; i++) {
    VALUE arg;

    if (!ocdata_to_rbobj(Qnil, args_octypes[i - 2], args[i], &arg, NO))
      rb_raise(rb_eRuntimeError, "Can't convert Objective-C argument #%d of octype %d to Ruby value", i - 2, args_octypes[i - 2]);

    OVMIX_LOG("\tconverted arg #%d to Ruby value %p", i, arg);

    rb_ary_store(rb_args, i - 2, arg);
  }

  OVMIX_LOG("\tcalling Ruby method...");
  retval = rbobj_call_ruby(*(id *)args[0], *(SEL *)args[1], rb_args);
  OVMIX_LOG("\tcalling Ruby method done, retval %p", retval);

  if (retval_octype != _C_VOID) {
    if (!rbobj_to_ocdata(retval, retval_octype, resp, YES))
      rb_raise(rb_eRuntimeError, "Can't convert return Ruby value to Objective-C value of octype %d", retval_octype);
  }
}

static struct st_table *ffi_imp_closures;
static pthread_mutex_t ffi_imp_closures_lock;

static IMP 
ovmix_imp_for_type(const char* type)
{
  BOOL ok;
  IMP imp;
  const char *error;
  NSMethodSignature *methodSignature;
  unsigned i, argc;
  ffi_type *rettype;
  ffi_type **argtypes;
  ffi_cif *cif;
  ffi_closure *closure;
  int *octypes;

  pthread_mutex_lock(&ffi_imp_closures_lock);
  imp = NULL;
  ok = st_lookup(ffi_imp_closures, (st_data_t)type, (st_data_t *)&imp);
  pthread_mutex_unlock(&ffi_imp_closures_lock); 
  if (ok)
    return imp;

  error = NULL;
  cif = NULL;
  closure = NULL;
  methodSignature = [NSMethodSignature signatureWithObjCTypes:type];
  argc = [methodSignature numberOfArguments];

  argtypes = (ffi_type **)malloc(sizeof(ffi_type *) * argc);
  octypes = (int *)malloc(sizeof(int) * (argc - 1)); /* first int is retval octype, then arg octypes */
  if (argtypes == NULL || octypes == NULL) {
    error = "Can't allocate memory";
    goto bails;
  }

  for (i = 0; i < argc; i++) {
    const char *atype;
    int octype;

    atype = [methodSignature getArgumentTypeAtIndex:i];
    octype = to_octype(atype);
    if (i >= 2)
      octypes[i - 1] = octype;
    argtypes[i] = ffi_type_for_octype(octype);
  }
  octypes[0] = to_octype([methodSignature methodReturnType]);
  rettype = ffi_type_for_octype(octypes[0]);

  cif = (ffi_cif *)malloc(sizeof(ffi_cif));
  if (cif == NULL) {
    error = "Can't allocate memory";
    goto bails;
  }

  if (ffi_prep_cif(cif, FFI_DEFAULT_ABI, argc, rettype, argtypes) != FFI_OK) {
    error = "Can't prepare cif";
    goto bails;
  }

  closure = (ffi_closure *)malloc(sizeof(ffi_closure));
  if (closure == NULL) {
    error = "Can't allocate memory";
    goto bails;
  }

  if (ffi_prep_closure(closure, cif, ovmix_ffi_closure, octypes) != FFI_OK) {
    error = "Can't prepare closure";
    goto bails;
  }

  pthread_mutex_lock(&ffi_imp_closures_lock);
  imp = NULL;
  ok = st_lookup(ffi_imp_closures, (st_data_t)type, (st_data_t *)&imp);
  if (!ok)
    st_insert(ffi_imp_closures, (st_data_t)type, (st_data_t)closure);
  pthread_mutex_unlock(&ffi_imp_closures_lock);
  if (ok) {
    error = NULL;   
    goto bails;
  }

  return (IMP)closure; 

bails:
  if (argtypes != NULL)
    free(argtypes);
  if (cif != NULL)
    free(cif);
  if (closure != NULL)
    free(closure);
  if (error != NULL)
    rb_raise(rb_eRuntimeError, error);

  return imp; 
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
  IMP simp = super_imp(rcv, method, (IMP)imp_respondsToSelector);
  id slave = get_slave(rcv);
  ret = (*simp)(rcv, method, arg0);
  if (ret == NULL)
    ret = (id)([slave respondsToSelector: arg0] != nil ? YES : NO);
  return ret;
}

static id imp_methodSignatureForSelector (id rcv, SEL method, SEL arg0)
{
  id ret;
  IMP simp = super_imp(rcv, method, (IMP)imp_methodSignatureForSelector);
  id slave = get_slave(rcv);
  ret = (*simp)(rcv, method, arg0);
  if (ret == nil)
    ret = [slave methodSignatureForSelector: arg0];
  return ret;
}

static id imp_forwardInvocation (id rcv, SEL method, NSInvocation* arg0)
{
  IMP simp = super_imp(rcv, method, (IMP)imp_forwardInvocation);
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
    ret = (id)[rcv performSelector: @selector(rbValueForKey:) withObject: key];
  else
    ret = [rcv performSelector: super_selector(method) withObject: key];
  return ret;
}

static void imp_setValue_forUndefinedKey (id rcv, SEL method, id value, NSString* key)
{
  id slave = get_slave(rcv);

  if ([slave respondsToSelector: @selector(rbSetValue:forKey:)])
    [slave performSelector: @selector(rbSetValue:forKey:) withObject: value withObject: key];
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
  new_obj = class_createInstanceFromZone(klass, 0, zone ? zone : NSDefaultMallocZone());
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
    IMP imp = ovmix_imp_for_type(me->method_types);
    if (me->method_imp == imp) {
      OVMIX_LOG("Already registered Ruby method by selector '%s' types '%s', skipping...", (char *)arg0, me->method_types);
      return nil;
    }
    mlp->method_list[0].method_name = me->method_name;
    mlp->method_list[0].method_types = strdup(me->method_types);
    mlp->method_list[0].method_imp = imp;
    mlp->method_count += 1;

    // super method
    mlp->method_list[1].method_name = super_selector(me->method_name);
    mlp->method_list[1].method_types = strdup(me->method_types);
    mlp->method_list[1].method_imp = me->method_imp;
    mlp->method_count += 1;
  }

  class_addMethods(klass, mlp);
  OVMIX_LOG("Registered Ruby method by selector '%s' types '%s'", (char *)arg0, me->method_types);
  return nil;
}

static id imp_c_addRubyMethod_withType(Class klass, SEL method, SEL arg0, const char *type)
{
  struct objc_method_list* mlp = method_list_alloc(1);

  // add method
  mlp->method_list[0].method_name = sel_registerName((const char*)arg0);
  mlp->method_list[0].method_types = strdup(type);
  mlp->method_list[0].method_imp = ovmix_imp_for_type(type);
  mlp->method_count += 1;

  class_addMethods(klass, mlp);
  OVMIX_LOG("Registered Ruby method by selector '%s' types '%s'", (char *)arg0, type);
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

void init_ovmix(void)
{   
    ffi_imp_closures = st_init_strtable();
    pthread_mutex_init(&ffi_imp_closures_lock, NULL);
}
