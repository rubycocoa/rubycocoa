#import <RubyCocoa/RBProxy.h>
#import <Foundation/Foundation.h>
#import <RubyCocoa/ocdata_conv.h>
#import "DummyProtocolHandler.h"
#import <ctype.h>

#if 1
#  define DLOG0(f)          if (ruby_debug == Qtrue) debug_log((f))
#  define DLOG1(f,a1)       if (ruby_debug == Qtrue) debug_log((f),(a1))
#  define DLOG2(f,a1,a2)    if (ruby_debug == Qtrue) debug_log((f),(a1),(a2))
#  define DLOG3(f,a1,a2,a3) if (ruby_debug == Qtrue) debug_log((f),(a1),(a2),(a3))
#else
#  define DLOG0(f)          debug_log((f))
#  define DLOG1(f,a1)       debug_log((f),(a1))
#  define DLOG2(f,a1,a2)    debug_log((f),(a1),(a2))
#  define DLOG3(f,a1,a2,a3) debug_log((f),(a1),(a2),(a3))
#endif

static void debug_log(const char* fmt,...)
{
  //  if (ruby_debug == Qtrue) {
    id pool = [[NSAutoreleasePool alloc] init];
    NSString* nsfmt = [NSString stringWithFormat: @"RPRXY:%s", fmt];
    va_list args;
    va_start(args, fmt);
    NSLogv(nsfmt, args);
    va_end(args);
    [pool release];
    //  }
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

  // selstr.sub(/:/,'_').sub(/^(.*)_$/, "\1")
  for (i = 0; i < [selstr length]; i++)
    if (mname[i] == ':') mname[i] = '_';
  if (mname[[selstr length]-1] == '_')
    mname[[selstr length]-1] = '\0';
  [pool release];

  return rb_intern(mname);
}

static RB_ID sel_to_mid_as_setter(SEL a_sel)
{
  id pool = [[NSAutoreleasePool alloc] init];
  VALUE str = rb_str_new2([NSStringFromSelector(a_sel) cString]);

  // if str.sub!(/^set([A-Z][^:]*):$/, '\1=') then
  //   str = str[0].chr.downcase + str[1..-1]
  // end
  const char* re_pattern = "^set([A-Z][^:]*):$";
  VALUE re = rb_reg_new(re_pattern, strlen(re_pattern), 0);
  if (rb_funcall(str, rb_intern("sub!"), 2, re, rb_str_new2("\\1=")) != Qnil) {
    int c = (int)(RSTRING(str)->ptr[0]);
    c = tolower(c);
    RSTRING(str)->ptr[0] = (char) c;
  }

  [pool release];
  return rb_to_id(str);
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

static SEL ruby_method_sel(int argc)
{
  SEL result;
  id pool = [[NSAutoreleasePool alloc] init];
  NSString* s = [@"ruby_method_" stringByAppendingFormat: @"%d", argc];
  int i;
  for (i = 0; i < argc; i++) {
    s = [s stringByAppendingString: @":"];
  }
  result = NSSelectorFromString(s);
  [pool release];
  return result;
}

static VALUE ocobject_class()
{
  VALUE mOSX = rb_const_get(rb_cObject, rb_intern("OSX"));;
  return rb_const_get(mOSX, rb_intern("OCObject"));
}

static VALUE to_rbobj(id ocobj)
{
  return rb_funcall(ocobject_class(), 
		    rb_intern("new_with_ocid"), 1, OCID2NUM(ocobj));
}

static id ocid_of(VALUE obj)
{
  id result = nil;
  if (rb_obj_is_kind_of(obj, ocobject_class()) == Qtrue) {
    VALUE val = rb_funcall(obj, rb_intern("__ocid__"), 0);
    result = (id)NUM2ULONG(val);
  }
  return result;
}

@implementation RBProxy

// private methods

- (BOOL)rbobjRespondsToSelector: (SEL)a_sel
{
  RB_ID mid = sel_to_mid(a_sel);
  BOOL ret = (rb_respond_to(m_rbobj, mid) != 0);
  if (ret == NO) {
    mid = sel_to_mid_as_setter(a_sel);
    ret = (rb_respond_to(m_rbobj, mid) != 0);
  }
  return ret;
}

- (NSMethodSignature*)rbobjMethodSignatureForSelector: (SEL)a_sel
{
  int argc = argc_of(a_sel);
  return [DummyProtocolHandler instanceMethodSignatureForSelector: ruby_method_sel(argc)];
}

- (VALUE)fetchForwardArgumentsOf: (NSInvocation*)an_inv
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
      if ([ocid isKindOfClass: [self class]])
	arg_val = [ocid __rbobj__];
      else if (ocid_of(m_rbobj) == ocid)
	arg_val = m_rbobj;
      else
	arg_val = to_rbobj(ocid);
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

- (BOOL)stuffForwardResult: (VALUE)result to: (NSInvocation*)an_inv
{
  NSMethodSignature* msig = [an_inv methodSignature];
  int octype = to_octype([msig methodReturnType]);
  BOOL f_success;
  
  if (octype == _C_VOID) {
    f_success = true;
  }
  else if ((octype == _C_ID) || (octype == _C_CLASS)) {
    id ocdata = (result == m_rbobj) ? self : ocid_of(result);
    if (ocdata == nil) rbobj_to_nsobj(result, &ocdata);
    [an_inv setReturnValue: &ocdata];
    f_success = YES;
  }
  else {
    void* ocdata = ocdata_malloc(octype);
    f_success = rbobj_to_ocdata (result, octype, ocdata);
    if (f_success) [an_inv setReturnValue: ocdata];
    free(ocdata);
  }
  return f_success;
}

- (void)rbobjForwardInvocation: (NSInvocation *)an_inv
{
  VALUE rb_args;
  VALUE rb_result;
  RB_ID mid;
  mid = sel_to_mid([an_inv selector]);
  if (rb_respond_to(m_rbobj, mid) == 0)
    mid = sel_to_mid_as_setter([an_inv selector]);
  rb_args = [self fetchForwardArgumentsOf: an_inv];
  rb_result = rb_apply(m_rbobj, mid, rb_args);
  [self stuffForwardResult: rb_result to: an_inv];
}

// public methods

- (id)    __parent__ { return m_parent; }
- (VALUE) __rbobj__  { return m_rbobj; }

// - (NSString *)_copyDescription
// {
//   return [[NSString alloc] initWithCString: STR2CSTR(rb_inspect(m_rbobj))];
// }

- initWithRubyObject: (VALUE)rbobj parent: parent
{
  m_rbobj = rbobj;
  m_parent = parent ? [parent retain] : nil;
  return self;
}

- initWithRubyObject: (VALUE)rbobj
{
  [self initWithRubyObject: rbobj parent: nil];
  return self;
}

- (void)dealloc
{
  if (m_parent) [m_parent release];
}

- (BOOL)isKindOfClass: (Class)klass
{
  BOOL ret;
  DLOG1("isKindOfClass(%@)", klass);
  ret = m_parent ? [m_parent isKindOfClass: klass] : NO;
  DLOG1("   --> %d", ret);
  return ret;
}

- (void)forwardInvocation: (NSInvocation *)an_inv
{
  DLOG1("forwardInvocation(%@)", an_inv);
  if ([self rbobjRespondsToSelector: [an_inv selector]]) {
    DLOG0("   -> forward to Ruby Object");
    [self rbobjForwardInvocation: an_inv];
  }
  else if (m_parent) {
    DLOG0("   -> invoke with Parent Objective-C Object");
    [an_inv setTarget: m_parent];
    [an_inv invoke];
  }
  else {
    DLOG0("   -> forward to super Objective-C Object");
    [super forwardInvocation: an_inv];
  }
}

- (NSMethodSignature*)methodSignatureForSelector: (SEL)a_sel
{
  NSMethodSignature* ret = nil;
  DLOG1("methodSignatureForSelector(%@)", NSStringFromSelector(a_sel));
  if (m_parent)
    ret = [m_parent methodSignatureForSelector: a_sel];
  if (ret == nil)
    ret = [DummyProtocolHandler instanceMethodSignatureForSelector: a_sel];
  if (ret == nil)
    ret = [self rbobjMethodSignatureForSelector: a_sel];
  DLOG1("   --> %@", ret);
  return ret;
}

- (BOOL)respondsToSelector: (SEL)a_sel
{
  BOOL ret;
  DLOG1("respondsToSelector(%@)", NSStringFromSelector(a_sel));
  ret = [self rbobjRespondsToSelector: a_sel];
  if (ret == NO) {
    if (m_parent)
      ret = [m_parent respondsToSelector: a_sel];
  }
  DLOG1("   --> %d", ret);
  return ret;
}

@end
