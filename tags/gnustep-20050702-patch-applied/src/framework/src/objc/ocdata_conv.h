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
#ifdef GNUSTEP
#	import <objc/objc-api.h>
#	define isa 			class_pointer
#	define Method			Method_t
#	define class_getInstanceMethod	class_get_instance_method
#	define class_createInstanceFromZone(class, extra, zone) \
	class_create_instance(class)
	extern void class_add_method_list (Class class, MethodList_t list);
#	undef sel_getUid
#	define sel_getUid(name)		(SEL)name
#	define CLS_CLASS 	(_CLS_CLASS|_CLS_RESOLV)
#	define CLS_META		(_CLS_META|_CLS_RESOLV)
#	define CLS_METHOD_ARRAY	0
#	define CLS_INITIALIZED	_CLS_INITIALIZED
#	define CLS_GETINFO(c,m)	((c)->info&(m))
#	define methodLists	methods
#	define objc_addClass	__objc_add_class_to_hash
	extern void class_add_method_list (Class class, MethodList_t list);
	extern void __objc_add_class_to_hash(Class);
	extern void __objc_install_premature_dtable(Class);
#else
#	import <objc/objc-class.h>
#	import <objc/objc-runtime.h>
#	define CLS_ISMETA(c)	((c)->info&CLS_META)
#endif
#import <stdarg.h>
#import "osx_ruby.h"

enum osxobjc_nsdata_type {
  _PRIV_C_BOOL = 1024,
  _PRIV_C_NSRECT,
  _PRIV_C_NSPOINT,
  _PRIV_C_NSSIZE,
  _PRIV_C_NSRANGE,
  _PRIV_C_PTR,
  _PRIV_C_ID_PTR,
};

int     to_octype       (const char* oc_type_str);
size_t  ocdata_size     (int octype, const char* octype_str);
void*   ocdata_malloc   (int octype, const char* octype_str);
#define OCDATA_ALLOCA(octype,s)  alloca(ocdata_size((octype),(s)))

id    rbobj_to_nsselstr (VALUE obj);
SEL   rbobj_to_nssel    (VALUE obj);
BOOL  rbobj_to_nsobj    (VALUE obj, id* nsobj);
BOOL  rbobj_to_bool     (VALUE obj);
id    rbstr_to_ocstr    (VALUE obj);

VALUE    sel_to_rbobj (SEL val);
VALUE    int_to_rbobj (int val);
VALUE   uint_to_rbobj (unsigned int val);
VALUE double_to_rbobj (double val);
VALUE   bool_to_rbobj (BOOL val);
VALUE   ocid_to_rbobj (VALUE context_obj, id ocid);
VALUE  ocstr_to_rbstr (id ocstr);
VALUE      objcid_new (VALUE klass, id ocid, BOOL retain);

BOOL  ocdata_to_rbobj (VALUE context_obj,
		       int octype, const void* ocdata, VALUE* result);
BOOL  rbobj_to_ocdata (VALUE obj, int octype, void* ocdata);
