/* 
 * Copyright (c) 2006-2008, The RubyCocoa Project.
 * Copyright (c) 2001-2006, FUJIMOTO Hisakuni.
 * All Rights Reserved.
 *
 * RubyCocoa is free software, covered under either the Ruby's license or the 
 * LGPL. See the COPYRIGHT file for more information.
 */

#import <Foundation/NSBundle.h>
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSDictionary.h>
#import <ruby.h>
#import "mdl_osxobjc.h"
#import "ocdata_conv.h"
#import "internal_macros.h"

/** module OSX::BundleSupport  **/
static VALUE _mBundleSupport = Qnil;
static NSMutableDictionary* gBundleMap = nil;
static const char* BUNDLE_STACK_NAME = "BUNDLE_STACK";
#define BUNDLE_STACK  rb_const_get(_mBundleSupport, rb_intern(BUNDLE_STACK_NAME))


/** bundle_stack - stack for the current bundle and related
 * parameter
 *
 * _push_bundle([ bundle, additional_param ])
 * _pop_bundle     => [ bundle, additional_param ] or nil
 * _current_bundle => [ bundle, additional_param ] or nil
 *
 * *NOTE* ocid_to_rbobj called at doing to pop/fetch a stack item,
 * rather than at the push time, because it's not work at that time
 * around the ns_import method.
 **/

/* this function should be called from inside a NSAutoreleasePool */
static NSBundle* bundle_for(Class klass)
{
  return (klass == nil) ?
    [NSBundle mainBundle] : 
    [NSBundle bundleForClass: klass];
}

static VALUE _make_stack_item(Class objc_class, id additional_param)
{
  VALUE args = Qnil;

  POOL_DO(pool) {
    id bundle;
    VALUE a0, a1;

    bundle = bundle_for(objc_class);
    a0 = OCID2NUM(bundle);
    a1 = OCID2NUM(additional_param);
    args = rb_ary_new3(2, a0, a1);
  } END_POOL(pool);
  return args;
}

static void  _push_bundle(VALUE args) { (void) rb_ary_push(BUNDLE_STACK, args); }
static void  _pop_bundle()            { (void) rb_ary_pop(BUNDLE_STACK); }

static VALUE _current_bundle()
{
  VALUE item;
  id bundle_id, param_id;
  VALUE bundle, param;

  item = rb_funcall(BUNDLE_STACK, rb_intern("last"), 0);
  if (! NIL_P(item)) {
    bundle_id = NUM2OCID(rb_ary_entry(item, 0));
    param_id  = NUM2OCID(rb_ary_entry(item, 1));
    bundle = ocid_to_rbobj(Qnil, bundle_id);
    param  = ocid_to_rbobj(Qnil, param_id);
    return rb_ary_new3(2, bundle, param);
  }
  return Qnil;
}

/*
 * Returns the current bundle in bundle stack.
 * @return [Array<OSX::NSBundle, Object>]
 */
static VALUE rb_current_bundle(VALUE mdl) { return _current_bundle(); }
/*
 * Returns a dictionary contains Objective-C Class -> NSBundle relations.
 * @return [OSX::NSMutableDictionary]
 */
static VALUE rb_bundle_map(VALUE mdl) { return ocid_to_rbobj(Qnil, gBundleMap); }

/** bundle_map - the  mapping table of class to bundle **/

static id _ruby2ocid(VALUE obj)
{
#if 1
  id ocid;
  return (rbobj_to_nsobj(obj, &ocid) == YES) ? ocid : nil;
#else
  return rbobj_get_ocid(obj);
#endif
}

static id
bundle_for_class(Class klass)
{
  return [gBundleMap objectForKey:klass];
}

/*
 * Returns an instalce of OSX::NSBundle that is main bundle of a given Objective-C class.
 * @param [Class] objc_class
 * @return [OSX::NSBundle]
 */
static VALUE
rb_bundle_for_class(VALUE mdl, VALUE objc_class)
{
  return ocid_get_rbobj([gBundleMap objectForKey:_ruby2ocid(objc_class)]);
}

/*
 * Binds a given Objective-C class to current bundle.
 * @param [Class] objc_class
 * @return [Array<OSX::NSBundle, Object>]
 * @return [nil] if the bundle stack is empty.
 */
static VALUE
rb_bind_class_with_current_bundle(VALUE mdl, VALUE objc_class)
{
  VALUE stack_item;
  stack_item = _current_bundle();
  if (! NIL_P(stack_item)) {
    VALUE bundle = rb_ary_entry(stack_item, 0); // [bundle, additional_param] => bundle
    if (!gBundleMap) gBundleMap = [NSMutableDictionary new];
    [gBundleMap setObject:_ruby2ocid(bundle) forKey:_ruby2ocid(objc_class)];
    return bundle;
  }
  return Qnil;
}

static VALUE my_load_clause(VALUE prog_name)
{
  rb_require(StringValuePtr(prog_name));
  return Qnil;
}

static VALUE my_eval_clause(VALUE prog_source)
{
  rb_eval_string(StringValuePtr(prog_source));
  return Qnil;
}

static VALUE my_rescue_clause(VALUE prog_name)
{
  return ruby_errinfo;
}

/** 
  def load_ruby_program_for_class(path, objc_klass, additional_param)
    _push_bundle(bundle for objc_class, additional_param)
    require(prog_name)
    nil
  rescue Exception => err
    err
  ensure
    _pop_bundle
  end
**/

VALUE
load_ruby_program_for_class(const char* path, Class objc_class, id additional_param)
{
  VALUE prog_name, stack_item, result;

  prog_name  = rb_str_new2(path);
  stack_item = _make_stack_item(objc_class, additional_param);
  _push_bundle(stack_item);
  result = rb_rescue2( my_load_clause,   prog_name,
                       my_rescue_clause, prog_name, rb_eException, (VALUE)0);
  _pop_bundle();
  return result;
}

VALUE
eval_ruby_program_for_class(const char* program, Class objc_class, id additional_param)
{
  VALUE prog_source, stack_item, result;

  prog_source = rb_str_new2(program);
  stack_item  = _make_stack_item(objc_class, additional_param);
  _push_bundle(stack_item);
  result = rb_rescue2( my_eval_clause,   prog_source,
                       my_rescue_clause, Qnil, rb_eException, (VALUE)0);
  _pop_bundle();
  return result;
}


/* replace NSBundle.bundleForClass */
static IMP original_bundleForClass = NULL;

static id rubycocoa_bundleForClass(id rcv, SEL op, id klass)
{
  id bundle = bundle_for_class(klass);
  if (! bundle)
    bundle = original_bundleForClass(rcv, op, klass);
  return bundle;
}

static void setup_bundleForClass()
{
  if (original_bundleForClass == NULL) {
    Method method;
    method = class_getClassMethod([NSBundle class], @selector(bundleForClass:));
    if (method) {
      original_bundleForClass = method_getImplementation(method);
      method_setImplementation(method, (IMP)rubycocoa_bundleForClass);
    }
  }
}

/** initialize primitive functions for module OSX::BundleSupport **/
/*
 * Document-module: OSX::BundleSupport
 * Utilities for handling NSBundle stack in applications.
 *
 * bundle_stack - stack for the current bundle and related
 * parameter. the related parameter (additional_param) can be
 * passed from  RBApplicationInit() or RBBundleInit().
 *
 * @example
 *     _push_bundle([bundle, additional_param])
 *     _pop_bundle     => [bundle, additional_param] or nil
 *     _current_bundle => [bundle, additional_param] or nil
 */
void
initialize_mdl_bundle_support()
{
  if (NIL_P(_mBundleSupport)) {
    VALUE _mOSX = osx_s_module();
    _mBundleSupport = rb_define_module_under(_mOSX, "BundleSupport");

    rb_define_const(_mBundleSupport, BUNDLE_STACK_NAME, rb_ary_new());

    rb_define_module_function(_mBundleSupport, 
                              "bundle_for_class",
			      rb_bundle_for_class, 1);

    rb_define_module_function(_mBundleSupport, 
                              "bind_class_with_current_bundle",
			      rb_bind_class_with_current_bundle, 1);

    rb_define_module_function(_mBundleSupport,
                              "_current_bundle",
                              rb_current_bundle, 0);

    rb_define_module_function(_mBundleSupport, 
                              "_bundle_map",
			      rb_bundle_map, 0);

    setup_bundleForClass();
  }
}
