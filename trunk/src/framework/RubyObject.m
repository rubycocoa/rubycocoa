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
#import "RubyObject.h"

#import <LibRuby/cocoa_ruby.h>
#import <Cocoa/Cocoa.h>
#import <stdarg.h>
#import "ocdata_conv.h"
#import "DummyProtocolHandler.h"

#define OCID2NUM(val) UINT2NUM((VALUE)(val))

#undef DEBUGLOG

#ifdef DEBUGLOG
#  define DLOG(f)            NSLog((f))
#  define DLOG1(f,a0)        NSLog((f),(a0))
#  define DLOG2(f,a0,a1)     NSLog((f),(a0),(a1))
#  define DLOG3(f,a0,a1,a2)  NSLog((f),(a0),(a1),(a2))
#else
#  define DLOG(f)
#  define DLOG1(f,a0)
#  define DLOG2(f,a0,a1)
#  define DLOG3(f,a0,a1,a2)
#endif

static VALUE ocobject_class()
{
  VALUE mOSX = rb_const_get(rb_cObject, rb_intern("OSX"));;
  return rb_const_get(mOSX, rb_intern("OCObject"));
}

static VALUE to_rbobj(id ocobj)
{
  VALUE cOCObject = ocobject_class();
  return rb_funcall(cOCObject, rb_intern("new_with_ocid"), 1, OCID2NUM(ocobj));
}

static id to_nsobj(VALUE rbobj)
{
  id nsobj;
  if (rbobj_to_nsobj(rbobj, &nsobj))
    return nsobj;
  return nil;
}

static RB_ID sel_to_mid(SEL a_sel)
{
  int i;
  id pool;
  NSString* selstr;
  char mname[1024];

  pool = [[NSAutoreleasePool alloc] init];
  selstr = NSStringFromSelector(a_sel);
  [selstr getCString: mname maxLength: sizeof(mname)];

  /** s/:/_/ and s/^(.*)_$/\1/ **/
  for (i = 0; i < [selstr length]; i++)
    if (mname[i] == ':') mname[i] = '_';
  if (mname[[selstr length]-1] == '_')
    mname[[selstr length]-1] = '\0';
  [pool release];

  return rb_intern(mname);
}

static int argc_of(SEL a_sel)
{
  id pool = [[NSAutoreleasePool alloc] init];
  const char* cp = [NSStringFromSelector(a_sel) cString];
  int ch;
  int argc = 0;
  while (ch = *cp++)
    if (ch == ':') argc++;
  [pool release];
  return argc;
}

@implementation RubyObject

/*********************/
/** private methods **/
/*********************/

- (BOOL) hasObjcHandlerOf: (SEL)a_sel
{
  return [super respondsToSelector: a_sel];
}

- (BOOL) hasRubyHandlerOf: (SEL)a_sel
{
  RB_ID mid = sel_to_mid(a_sel);
  return (rb_respond_to(rbobj, mid) != 0);
}

- (NSMethodSignature *)msigForRubyMethod: (SEL)a_sel
{
  if ([self hasRubyHandlerOf: a_sel]) {
    NSMethodSignature* msig;
    msig = [dummy methodSignatureForSelector: a_sel];
    if (msig == nil) {
      // as Observer
      int argc = argc_of(a_sel);
      if (argc == 0)
	msig = [dummy methodSignatureForSelector: @selector(ruby_method_0)];
      else if (argc == 1)
	msig = [dummy methodSignatureForSelector: @selector(ruby_method_1:)];
      else if (argc >= 2)
	msig = [dummy methodSignatureForSelector: @selector(ruby_method_2:)];
    }
    return msig;
  }
  return nil;
}

- (VALUE) fetchForwardArgumentsOf: (NSInvocation*)an_inv
{
  int i;
  NSMethodSignature* msig = [an_inv methodSignature];
  int arg_cnt = ([msig numberOfArguments] - 2);
  VALUE args = rb_ary_new2(arg_cnt);
  for (i = 0; i < arg_cnt; i++) {
    VALUE arg_val;
    const char* octstr = [msig getArgumentTypeAtIndex: (i+2)];
    int octype = to_octype(octstr);
    void* ocdata = ocdata_malloc(octype);
    BOOL f_conv_success;
    [an_inv getArgument: ocdata atIndex: (i+2)];
    if ((octype == _C_ID) || (octype == _C_CLASS)) {
      id ocid = *(id*)ocdata;
      arg_val = (ocid == self) ? rbobj : to_rbobj(ocid);
      f_conv_success = YES;
    }
    else {
      f_conv_success = ocdata_to_rbobj(octype, ocdata, &arg_val);
    }
    free(ocdata);
    if (f_conv_success == NO) {
      arg_val = Qnil;
    }
    rb_ary_store(args, i, arg_val);
  }
  return args;
}

- (void) stuffForwardResult: (VALUE) result to:(NSInvocation*)an_inv
{
  NSMethodSignature* msig = [an_inv methodSignature];
  int octype = to_octype([msig methodReturnType]);
  void* ocdata = ocdata_malloc(octype);
  BOOL f_conv_success = rbobj_to_ocdata (result, octype, ocdata);
  if (f_conv_success)
    [an_inv setReturnValue: ocdata];
  free(ocdata);
}

- (void) forwardToRuby: (NSInvocation*)an_inv
{
  VALUE rb_args;
  VALUE rb_result;
  RB_ID mid = sel_to_mid([an_inv selector]);
  if (!rb_respond_to(rbobj, mid)) return;
  rb_args = [self fetchForwardArgumentsOf: an_inv];
  rb_result = rb_apply(rbobj, mid, rb_args);
  [self stuffForwardResult: rb_result to: an_inv];
}

/********************/
/** public methods **/
/********************/

+ rubyObjectWithOCObject: (id)a_ocobj
{
  id pool = [[NSAutoreleasePool alloc] init];
  id result = [[self alloc]
		initWithRubyClassName: [[a_ocobj class] description]
		ocObject: a_ocobj];
  [pool release];
  return result;
}


- initWithRubyObject: (unsigned long) a_rbobj
{
  rbobj = a_rbobj;
  dummy = [DummyProtocolHandler instance];
  return self;
}

- init
{
  id pool = [[NSAutoreleasePool alloc] init];
  [self initWithRubyClassName: [[self class] description]];
  [pool release];
  return self;
}

- initWithRubyClassName: (NSString*)a_rbclass_name
{
  return [self initWithRubyClassName: a_rbclass_name ocObject: self];
}

- initWithOCObject: (id)a_ocobj
{
  id pool = [[NSAutoreleasePool alloc] init];
  [self initWithRubyClassName: [[self class] description]
	ocObject: a_ocobj];
  [pool release];
  return self;
}

- initWithRubyClassName: (NSString*)a_rbclass_name ocObject: (id)a_ocobj
{
  RB_ID rb_class_id;
  VALUE rb_class;
  RB_ID rb_mid;

  dummy = [DummyProtocolHandler instance];

  rb_class_id = rb_intern([a_rbclass_name cString]);
  rb_class = rb_const_get(rb_cObject, rb_class_id);

  if (rb_class == Qnil) rb_class = ocobject_class();

  /**
   * if rb_class.respond_to?(:new_with_ocid) then
   *    rbobj = rb_class.new_with_ocid(a_ocobj.__ocid__)
   *  else
   *    rbobj = rb_class.new
   *    if rbobj.respond_to?(:set_ocobj) then
   *       rbobj.set_ocobj(a_ocobj)
   *    end
   *  end
   **/
  rb_mid = rb_intern("new_with_ocid");
  if (rb_respond_to(rb_class, rb_mid)) {
    rbobj = rb_funcall(rb_class, rb_mid, 1, OCID2NUM(a_ocobj));
  }
  else {
    rbobj = rb_funcall(rb_class, rb_intern("new"), 0);
    rb_mid = rb_intern("set_ocobj");
    if (rb_respond_to(rb_class, rb_mid)) {
      rb_funcall(rbobj, rb_mid, 1, to_rbobj(a_ocobj));
    }
  }
  return self;
}


- (BOOL) respondsToSelector: (SEL)a_sel
{
  DLOG1(@"== respondsToSelector(%@)", NSStringFromSelector(a_sel));
  if ([self hasObjcHandlerOf: a_sel]) return YES;
  return [self hasRubyHandlerOf: a_sel];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
  NSMethodSignature* msig;
  msig = [super methodSignatureForSelector: aSelector];
  if (msig == nil) msig = [self msigForRubyMethod: aSelector];
  return msig;
}

- performSelector: (SEL)a_sel
{
  DLOG1(@"== performSelector:%@", NSStringFromSelector(a_sel));
  if ([self hasObjcHandlerOf: a_sel]) {
    return [super performSelector: a_sel];
  }
  else {
    RB_ID mid = sel_to_mid(a_sel);
    if (rb_respond_to(rbobj, mid)) {
      VALUE rb_result = rb_funcall(rbobj, mid, 0);
      return to_nsobj(rb_result);
    }
  }
  return nil;
}

- performSelector: (SEL)a_sel withObject: arg0
{
  DLOG1(@"== performSelector:%@:", NSStringFromSelector(a_sel));
  if ([self hasObjcHandlerOf: a_sel]) {
    return [super performSelector: a_sel];
  }
  else {
    RB_ID mid = sel_to_mid(a_sel);
    if (rb_respond_to(rbobj, mid)) {
      VALUE rb_result = rb_funcall(rbobj, mid, 1, to_rbobj(arg0));
      return to_nsobj(rb_result);
    }
  }
  return nil;
}

- performSelector: (SEL)a_sel withObject: arg0 withObject: arg1
{
  DLOG1(@"== performSelector:%@::", NSStringFromSelector(a_sel));
  if ([self hasObjcHandlerOf: a_sel]) {
    return [super performSelector: a_sel];
  }
  else {
    RB_ID mid = sel_to_mid(a_sel);
    if (rb_respond_to(rbobj, mid)) {
      VALUE rb_result = rb_funcall(rbobj, mid, 2, to_rbobj(arg0), to_rbobj(arg1));
      return to_nsobj(rb_result);
    }
  }
  return nil;
}

- (void) forwardInvocation: (NSInvocation *)an_inv
{
  SEL a_sel = [an_inv selector];
  DLOG1(@"== forwardInvocation(%@)", an_inv);
  if ([self hasObjcHandlerOf: a_sel]) {
    [super forwardInvocation: an_inv];
  }
  else {
    [self forwardToRuby: an_inv];
  }
}

@end
