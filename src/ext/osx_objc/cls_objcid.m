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
#import <Foundation/Foundation.h>
#import <string.h>
#import <stdlib.h>

static VALUE _kObjcID = Qnil;

struct _objcid_data {
  id  ocid;
};

#define OBJCID_DATA_PTR(o) ((struct _objcid_data*)(DATA_PTR(o)))
#define OCID_OF(o) (OBJCID_DATA_PTR(o)->ocid)


static void
_objcid_data_free(struct _objcid_data* dp)
{
  id pool = [[NSAutoreleasePool alloc] init];
  if (dp != NULL) {
    if (dp->ocid != nil)
      [dp->ocid release];
    free(dp);
  }
  [pool release];
}

static struct _objcid_data*
_objcid_data_new()
{
  struct _objcid_data* dp = NULL;
  dp = malloc(sizeof(struct _objcid_data));
  dp->ocid = nil;
  return dp;
}

static VALUE
_rb_cls_name(VALUE obj)
{
  obj = rb_obj_as_string(CLASS_OF(obj));
  obj = rb_str_split(obj, "::");
  return rb_ary_entry(obj, -1);
}

static VALUE
_objcid_real_initialize(int argc, VALUE* argv, VALUE rcv)
{
  VALUE arg_ocid;
  id ocid;

  rb_scan_args(argc, argv, "01", &arg_ocid);
  if (arg_ocid != Qnil) {
    ocid = (id) NUM2UINT(arg_ocid);
    [ocid retain];
  }
  else {
    id pool = [[NSAutoreleasePool alloc] init];
    id oc_str, oc_cls;

    oc_str = [NSString stringWithCString: STR2CSTR(_rb_cls_name(rcv))];
    oc_cls = NSClassFromString(oc_str);
    if (oc_cls)
      ocid = [[oc_cls alloc] init];
    else
      ocid = [[NSObject alloc] init];
    [pool release];
  }
  OBJCID_DATA_PTR(rcv)->ocid = ocid;
  return rcv;
}

static VALUE
objcid_s_new(int argc, VALUE* argv, VALUE klass)
{
  VALUE obj;
  obj = Data_Wrap_Struct(klass, 0, _objcid_data_free, _objcid_data_new());
  obj = _objcid_real_initialize(argc, argv, obj);
  if (argc > 0) {
    argc--;
    argv++;
  }
  rb_obj_call_init(obj, argc, argv);
  return obj;
}

static VALUE
objcid_initialize(int argc, VALUE* argv, VALUE rcv)
{
  return rcv;
}

static VALUE
objcid_ocid(VALUE rcv)
{
  return UINT2NUM((unsigned int) OCID_OF(rcv));
}

static VALUE
objcid_inspect(VALUE rcv)
{
  VALUE result;
  char s[256];
  id ocid = OCID_OF(rcv);
  id pool = [[NSAutoreleasePool alloc] init];
  const char* class_desc = [[[ocid class] description] cString];
  const char* desc = [[ocid description] cString];
  VALUE rbclass_name = rb_mod_name(CLASS_OF(rcv));
  snprintf(s, sizeof(s), "#<%s:0x%x class='%s' id=%X>",
	   STR2CSTR(rbclass_name),
	   NUM2ULONG(rb_obj_id(rcv)), 
	   class_desc, ocid);
  result = rb_str_new2(s);
  [pool release];
  return result;
}

/*******/

VALUE
init_cls_ObjcID(VALUE outer)
{
  _kObjcID = rb_define_class_under(outer, "ObjcID", rb_cObject);

  rb_define_singleton_method(_kObjcID, "new", objcid_s_new, -1);

  rb_define_method(_kObjcID, "initialize", objcid_initialize, -1);
  rb_define_method(_kObjcID, "__ocid__", objcid_ocid, 0);
  rb_define_method(_kObjcID, "__inspect__", objcid_inspect, 0);
  rb_define_method(_kObjcID, "inspect", objcid_inspect, 0);

  return _kObjcID;
}
