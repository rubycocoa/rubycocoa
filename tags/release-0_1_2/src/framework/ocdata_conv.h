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
#import <objc/objc-class.h>
#import <stdarg.h>

enum osxobjc_nsdata_type {
  _PRIV_C_BOOL = 1024,
  _PRIV_C_NSRECT,
  _PRIV_C_NSPOINT,
  _PRIV_C_NSSIZE,
  _PRIV_C_NSRANGE,
};

#define OCID2NUM(val) UINT2NUM((VALUE)(val))

int    to_octype       (const char* oc_type_str);
size_t ocdata_size     (int octype);
void*  ocdata_malloc   (int octype);
void*  ocdata_malloc_va_arg(va_list ap, int octype);
BOOL   octype_object_p (int octype);


id     rbobj_to_nsselstr  (VALUE obj);
SEL    rbobj_to_nssel  (VALUE obj);
BOOL   rbobj_to_nsobj  (VALUE obj, id* nsobj);

BOOL   rbobj_to_bool   (VALUE obj);
VALUE  bool_to_rbobj   (BOOL val);
VALUE  sel_to_rbobj    (SEL val);
VALUE  int_to_rbobj    (int val);
VALUE  uint_to_rbobj   (unsigned int val);
VALUE  double_to_rbobj (double val);

BOOL   ocdata_to_rbobj (int octype, const void* ocdata, VALUE* result);
BOOL   rbobj_to_ocdata (VALUE obj, int octype, void* ocdata);
