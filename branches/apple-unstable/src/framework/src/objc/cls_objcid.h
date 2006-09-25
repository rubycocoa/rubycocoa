/** -*-objc-*-
 *
 *   $Id$
 *
 *   Copyright (c) 2001 FUJIMOTO Hisakuni
 *
 **/
#import "osx_ruby.h"
#import <objc/objc.h>

struct _objcid_data {
  id  ocid;
  BOOL retained;
  BOOL can_be_released;
};

/** class methods **/
VALUE objid_s_class ();

/** instance methods 
 * id* objcid_idptr (VALUE rcv);
 * id  objcid_id (VALUE rcv);
 **/
#define OBJCID_DATA_PTR(rcv) ((struct _objcid_data*)(DATA_PTR(rcv)))
#define OBJCID_ID(rcv)     (OBJCID_DATA_PTR(rcv)->ocid)
#define OBJCID_IDPTR(rcv)  (&OBJCID_ID(rcv))

/** initial loading **/
VALUE init_cls_ObjcID (VALUE outer);
