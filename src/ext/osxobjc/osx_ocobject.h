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

#ifndef _OSX_OCOBJECT_H_
#define _OSX_OCOBJECT_H_

#import <LibRuby/cocoa_ruby.h>
#import <Foundation/NSObjCRuntime.h>

struct _ocobj_data {
  id  obj;
  int ownership;
};

#define OCOBJ_DATA_PTR(o) ((struct _ocobj_data*)(DATA_PTR(o)))
#define OCOBJ_ID_OF(o) (OCOBJ_DATA_PTR(o)->obj)

extern VALUE kOCObject;

VALUE init_class_OCObject(VALUE outer);
VALUE create_rbobj_with_ocid(id ocobj);

#endif /* _OSX_OCOBJECT_H_ */
