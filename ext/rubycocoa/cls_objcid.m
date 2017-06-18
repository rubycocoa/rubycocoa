/* 
 * Copyright (c) 2006-2008, The RubyCocoa Project.
 * Copyright (c) 2001-2006, FUJIMOTO Hisakuni.
 * All Rights Reserved.
 *
 * RubyCocoa is free software, covered under either the Ruby's license or the 
 * LGPL. See the COPYRIGHT file for more information.
 */

#import "cls_objcid.h"

#import <ruby.h>
#import "ocdata_conv.h"
#import <Foundation/Foundation.h>
#import <string.h>
#import <stdlib.h>
#import "RBObject.h"
#import "internal_macros.h"
#import "BridgeSupport.h"
#import "mdl_osxobjc.h"

#define CLSOBJ_LOG(fmt, args...) DLOG("CLSOBJ", fmt, ##args)

static VALUE _kObjcID = Qnil;

static void
_objcid_data_free(struct _objcid_data* dp)
{
  id pool = [[NSAutoreleasePool alloc] init];
  if (dp != NULL) {
    if (dp->ocid != nil) {
      remove_from_oc2rb_cache(dp->ocid);
      if (dp->retained && dp->can_be_released) {
        CLSOBJ_LOG("releasing %p", dp->ocid);
        [dp->ocid release];
      }
    }
    free(dp);
  }
  [pool release];
}

static struct _objcid_data*
_objcid_data_new()
{
  struct _objcid_data* dp;
  dp = malloc(sizeof(struct _objcid_data));
  dp->ocid = nil;
  dp->retained = NO;
  dp->can_be_released = NO;
  return dp;
}

#ifdef HAVE_TYPE_RB_DATA_TYPE_T
static const rb_data_type_t objcid_type = {
    "osx_objcid",
    {0, _objcid_data_free, sizeof(struct _objcid_data),},
    0, 0,
    0,
};
#endif

/*
 * allocate
 */
static VALUE
objcid_s_alloc(VALUE klass)
{
#ifdef HAVE_TYPE_RB_DATA_TYPE_T
  return TypedData_Wrap_Struct(klass, &objcid_type, _objcid_data_new());
#else
  return Data_Wrap_Struct(klass, NULL, _objcid_data_free, _objcid_data_new());
#endif
}

VALUE
objcid_new_with_ocid(VALUE klass, id ocid)
{
  VALUE obj;

#ifdef HAVE_TYPE_RB_DATA_TYPE_T
  obj = TypedData_Wrap_Struct(klass, &objcid_type, _objcid_data_new());
#else
  obj = Data_Wrap_Struct(klass, NULL, _objcid_data_free, _objcid_data_new());
#endif

  // The retention of the ObjC instance is delayed in ocm_send, to not
  // violate the "init-must-follow-alloc" initialization pattern.
  // Retaining here could message in the middle. 
  if (ocid != nil) {
    OBJCID_DATA_PTR(obj)->ocid = ocid;
    OBJCID_DATA_PTR(obj)->retained = NO;
  }

  rb_obj_call_init(obj, 0, NULL);
  return obj;
}

/*
 * @api private
 */
static VALUE
wrapper_objcid_s_new_with_ocid(VALUE klass, VALUE rbocid)
{
  return objcid_new_with_ocid(klass, NUM2OCID(rbocid));
}

/*
 * Sends Objective-C "release" message to reciever.
 */
static VALUE
objcid_release(VALUE rcv)
{
  if (OBJCID_DATA_PTR(rcv)->can_be_released) {
    [OBJCID_ID(rcv) release];
    OBJCID_DATA_PTR(rcv)->can_be_released = NO;
  }
  return rcv;
}

/*
 * @api private
 * Returns shallow copied object by Object#dup.
 */
static VALUE
objcid_init_copy(VALUE self, VALUE orig)
{
  OBJCID_DATA_PTR(self)->ocid = OBJCID_DATA_PTR(orig)->ocid;
  return self;
}

/*
 * Objective-C id value as Number.
 * @return [Number]
 * @example
 *     url = OSX::NSURL.URLWithString('http://www.apple.com')
 *     url.inspect
 *     => "#<OSX::NSURL:0x8775b0c0 class='NSURL' id=0x7fe3b2913690>"
 *     url.__ocid__
 *     => 140615930164880
 */
static VALUE
objcid_ocid(VALUE rcv)
{
  return OCID2NUM(OBJCID_ID(rcv));
}

/*
 * Object#inspect.
 * @return [String]
 * @note overrides Object#inspect.
 */
static VALUE
objcid_inspect(VALUE rcv)
{
  char              s[512];
  id                ocid;
  struct bsConst *  bs_const;
  const char *      class_desc;
  id                pool;

  ocid = OBJCID_ID(rcv);
  bs_const = find_magic_cookie_const_by_value(ocid);
  if (bs_const != NULL) {
    pool = nil;
    class_desc = bs_const->class_name;
  }
  else {
    pool = [[NSAutoreleasePool alloc] init];
    class_desc = [[[ocid class] description] UTF8String];
  }

  snprintf(s, sizeof(s), "#<%s:0x%lx class='%s' id=%p>",
    rb_class2name(CLASS_OF(rcv)),
    NUM2ULONG(rb_obj_id(rcv)), 
    class_desc, ocid);

  if (pool != nil)
    [pool release];

  return rb_str_new2(s);
}

/*
 * Returns an hash value form internal Objective-C "id".
 * @return [FIXNUM]
 * @example
 *     num1 = OSX::NSNumberWithInt(1)
 *     num2 = OSX::NSNumberWithInt(1)
 *     num1.__id__ == num2.__id__
 *     # => false
 *     num1.hash == num2.hash
 *     # => true
 * @note overrides Object#hash.
 */
static VALUE
objcid_hash(VALUE rcv)
{
  id ocid;

  ocid = OBJCID_ID(rcv);
  return LONG2FIX(ocid);
}

/*
 * Returns `true` when `other` contains same Objective-C "id".
 * @example
 *     num1 = OSX::NSNumberWithInt(1)
 *     num2 = OSX::NSNumberWithInt(1)
 *     num1.eql?(num2)
 *     # => true
 *     num1 == num2
 *     # => true
 *     num1.__id__ == num2.__id__
 *     # => false
 *     num1.__ocid__ == num2.__ocid__
 *     # => true
 * @note overrides Object#eql? and Object#==.
 */
static VALUE
objcid_eql(VALUE rcv, VALUE other)
{
  if (rb_obj_is_kind_of(other, _kObjcID) && OBJCID_ID(rcv) == OBJCID_ID(other)) {
    return Qtrue;
  }
  return Qfalse;
}

/** class methods **/

VALUE
objid_s_class ()
{
  return _kObjcID;
}

/*******/

/*
 * Document-class: OSX::ObjcID < Object
 * Root class of Objective-C classes in Ruby world.
 *
 * @example
 *     OSX::NSObject.superclass
 *     => OSX::ObjcID
 *     OSX::NSProxy.superclass
 *     => OSX::ObjcID
 *     OSX::NSString.superclass
 *     => OSX::NSObject
 */
void
init_cls_ObjcID(VALUE mOSX)
{
  _kObjcID = rb_define_class_under(mOSX, "ObjcID", rb_cObject);

#ifdef HAVE_TYPE_RB_DATA_TYPE_T
  rb_undef_alloc_func(_kObjcID);
#endif
  rb_define_alloc_func(_kObjcID, objcid_s_alloc);
  rb_define_singleton_method(_kObjcID, "new_with_ocid", wrapper_objcid_s_new_with_ocid, 1);

  rb_define_method(_kObjcID, "initialize_copy", objcid_init_copy, 1);
  rb_define_method(_kObjcID, "__ocid__", objcid_ocid, 0);
  rb_define_method(_kObjcID, "__inspect__", objcid_inspect, 0);
  rb_define_method(_kObjcID, "release", objcid_release, 0);
  rb_define_method(_kObjcID, "inspect", objcid_inspect, 0);
  rb_define_method(_kObjcID, "hash", objcid_hash, 0);
  rb_define_method(_kObjcID, "eql?", objcid_eql, 1);
  rb_define_alias(_kObjcID, "==", "eql?");

  // disable deep copy.
  rb_undef_method(_kObjcID, "clone");
}
