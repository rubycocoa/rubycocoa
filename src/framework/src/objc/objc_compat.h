//
//  objc_compat.h
//  RubyCocoa
//
//  Created by Laurent Sansonetti on 2/14/07.
//  Copyright 2007 Apple Computer. All rights reserved.
//

#import <objc/objc-class.h>

#if !__OBJC2__

#define objc_registerClassPair(klass) (objc_addClass(klass))

#define class_createInstance(klass, extra_bytes) (class_createInstanceFromZone(klass, extra_bytes, NSDefaultMallocZone()))
#define class_getName(klass) (((struct objc_class *)(klass))->name)
#define class_getSuperclass(klass) (((struct objc_class *)(klass))->super_class)
#define class_isMetaClass(klass) (((struct objc_class *)(klass))->info & CLS_META)
#define class_addMethod(klass, name, imp, types) \
  do { \
    struct objc_method_list* mlp; \
    mlp = NSZoneMalloc(NSDefaultMallocZone(), sizeof(struct objc_method_list)); \
    mlp->obsolete = NULL; \
    mlp->method_list[0].method_name = (SEL)(name);	\
    mlp->method_list[0].method_types = types; \
    mlp->method_list[0].method_imp = imp;   \
    mlp->method_count = 1; \
    class_addMethods(klass, mlp);		\
  } \
  while (0)

#define method_getName(method) (((Method)(method))->method_name)
#define method_getImplementation(method) (((Method)(method))->method_imp)
#define method_setImplementation(method, imp) (((Method)(method))->method_imp = imp)
#define method_getTypeEncoding(method) (((Method)(method))->method_types)

#define object_getClass(obj) (((struct objc_class *)(obj))->isa)

#endif