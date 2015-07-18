/* 
 * Copyright (c) 2006-2008, The RubyCocoa Project.
 * Copyright (c) 2001-2006, FUJIMOTO Hisakuni.
 * All Rights Reserved.
 *
 * RubyCocoa is free software, covered under either the Ruby's license or the 
 * LGPL. See the COPYRIGHT file for more information.
 */

#import <ruby.h>
#import <objc/objc.h>

struct _objcid_data {
  id  ocid;
  BOOL retained;
  BOOL can_be_released;
};

/** class methods **/
VALUE objid_s_class ();
VALUE objcid_new_with_ocid(VALUE klass, id ocid);

/** instance methods 
 * id* objcid_idptr (VALUE rcv);
 * id  objcid_id (VALUE rcv);
 **/
#ifdef HAVE_TYPE_RB_DATA_TYPE_T
#define OBJCID_DATA_PTR(rcv) ((struct _objcid_data*)(RTYPEDDATA_DATA(rcv)))
#else
#define OBJCID_DATA_PTR(rcv) ((struct _objcid_data*)(DATA_PTR(rcv)))
#endif
#define OBJCID_ID(rcv)     (OBJCID_DATA_PTR(rcv)->ocid)
#define OBJCID_IDPTR(rcv)  (&OBJCID_ID(rcv))

/** initial loading **/
void init_cls_ObjcID (VALUE mOSX);
