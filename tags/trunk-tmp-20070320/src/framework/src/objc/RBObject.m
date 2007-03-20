/** -*-objc-*-
 *
 *   $Id$
 *
 *   Copyright (c) 2001 FUJIMOTO Hisakuni
 *
 **/
#import <Foundation/Foundation.h>
#import <ctype.h>
#import "RBObject.h"
#import "mdl_osxobjc.h"
#import "ocdata_conv.h"
#import "DummyProtocolHandler.h"
#import "RBRuntime.h" // for DLOG

#define RBOBJ_LOG(fmt, args...) DLOG("RBOBJ", fmt, ##args)

extern ID _relaxed_syntax_ID;

static RB_ID sel_to_mid(SEL a_sel)
{
  int i, length;
  const char *selName;
  char mname[1024];

  selName = sel_getName(a_sel);
  memset(mname, 0, sizeof(mname));
  strncpy(mname, selName, sizeof(mname) - 1);

  // selstr.sub(/:/,'_')
  length = strlen(selName);
  for (i = 0; i < length; i++)
    if (mname[i] == ':') mname[i] = '_';

  if (RTEST(rb_ivar_get(osx_s_module(), _relaxed_syntax_ID))) {    
    // sub(/^(.*)_$/, "\1")
    for (i = length - 1; i >= 0; i--) {
      if (mname[i] != '_') break;
      mname[i] = '\0';
    }
  }

  return rb_intern(mname);
}

static RB_ID sel_to_mid_as_setter(SEL a_sel)
{
  VALUE str = rb_str_new2(sel_getName(a_sel));

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

  return rb_to_id(str);
}

static RB_ID rb_obj_sel_to_mid(VALUE rcv, SEL a_sel)
{
  RB_ID mid = sel_to_mid(a_sel);
  if (rb_respond_to(rcv, mid) == 0)
    mid = sel_to_mid_as_setter(a_sel);
  return mid;
}

static int rb_obj_arity_of_method(VALUE rcv, SEL a_sel)
{
  id pool = [[NSAutoreleasePool alloc] init];
  VALUE mstr;
  RB_ID mid;
  VALUE method;
  VALUE argc;

  mid = rb_obj_sel_to_mid(rcv, a_sel);
  mstr = rb_str_new2(rb_id2name(mid)); // mstr = sel_to_rbobj (a_sel);
  method = rb_funcall(rcv, rb_intern("method"), 1, mstr);
  argc = rb_funcall(method, rb_intern("arity"), 0);
  [pool release];
  return NUM2INT(argc);
}

static SEL ruby_method_sel(int argc)
{
  char selName[1024];
  int selNameLength;
  int i;
  
  selNameLength = snprintf(selName, sizeof selName, "ruby_method_%d", argc);
  for (i = 0; i < argc; i++)
    selName[selNameLength++] = ':';
  selName[selNameLength] = '\0';
  return sel_registerName(selName);
}

@implementation RBObject

// private methods

- (BOOL)rbobjRespondsToSelector: (SEL)a_sel
{
  BOOL ret;
  RB_ID mid;
  RBOBJ_LOG("rbobjRespondsToSelector(%s)", a_sel);
  mid = rb_obj_sel_to_mid(m_rbobj, a_sel);
  ret = (rb_respond_to(m_rbobj, mid) != 0);
  RBOBJ_LOG("   --> %d", ret);
  return ret;
}

- (NSMethodSignature*)rbobjMethodSignatureForSelector: (SEL)a_sel
{
  NSMethodSignature* msig;
  int argc;
  RBOBJ_LOG("rbobjMethodSignatureForSelector(%s)", a_sel);
  argc = rb_obj_arity_of_method(m_rbobj, a_sel);
  if (argc < 0) argc = -1 - argc;
  msig = [DummyProtocolHandler 
	   instanceMethodSignatureForSelector: ruby_method_sel(argc)];
  RBOBJ_LOG("   --> %@", msig);
  return msig;
}

- (NSMethodSignature*) rbobjMethodSignatureForSheetSelector: (SEL)a_sel
{
  const char* tail = ":returnCode:contextInfo:";
  const SEL dummy_sel = @selector(sheetPanelDidEnd:returnCode:contextInfo:);

  const char* name;
  int name_len, tail_len;
  NSMethodSignature* msig;

  msig = nil;
  name = sel_getName(a_sel);
  name_len = strlen(name);
  tail_len = strlen(tail);
  if (name_len > tail_len) {
    if (strcmp(name + name_len - tail_len, tail) == 0) {
      // it's sheet panel selector
      msig = [DummyProtocolHandler
	       instanceMethodSignatureForSelector: dummy_sel];
    }
  }
  return msig;
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
    void* ocdata = OCDATA_ALLOCA(octype, octstr);
    BOOL f_conv_success;
    [an_inv getArgument: ocdata atIndex: (i+2)];
    f_conv_success = ocdata_to_rbobj(Qnil, octype, ocdata, &arg_val);
    if (f_conv_success == NO) {
      arg_val = Qnil;
    }
    rb_ary_store(args, i, arg_val);
    // Retain if the argument is not initialized for Ruby 
    // see ocm_retain_result_if_necessary() in mdl_objwrapper.m
    if (!NIL_P(arg_val) && octype == _C_ID && !OBJCID_DATA_PTR(arg_val)->retained) {
      [OBJCID_ID(arg_val) retain];
      OBJCID_DATA_PTR(arg_val)->retained = YES;
    }
  }
  return args;
}

- (BOOL)stuffForwardResult: (VALUE)result to: (NSInvocation*)an_inv
{
  NSMethodSignature* msig = [an_inv methodSignature];
  const char* octype_str = [msig methodReturnType];
  int octype = to_octype(octype_str);
  BOOL f_success;

  if (octype == _C_VOID) {
    f_success = true;
  }
  else if ((octype == _C_ID) || (octype == _C_CLASS)) {
    id ocdata = rbobj_get_ocid(result);
    if (ocdata == nil) {
      if (result == m_rbobj)
	ocdata = self;
      else
	rbobj_to_nsobj(result, &ocdata);
    }
    [an_inv setReturnValue: &ocdata];
    f_success = YES;
  }
  else {
    void* ocdata = OCDATA_ALLOCA(octype, octype_str);
    f_success = rbobj_to_ocdata (result, octype, ocdata);
    if (f_success) [an_inv setReturnValue: ocdata];
  }
  return f_success;
}

-(void)rbobjRaiseRubyException
{
  VALUE lasterr = rb_gv_get("$!");
  RB_ID mtd = rb_intern("nsexception");
  if (rb_respond_to(lasterr, mtd)) {
      VALUE nso = rb_funcall(lasterr, mtd, 0);
      NSException *exc = rbobj_get_ocid(nso);
      [exc raise];
      return; // not reached
  }
  
  NSMutableDictionary *info = [NSMutableDictionary dictionary];
  
  id ocdata = rbobj_get_ocid(lasterr);
  if (ocdata == nil) {
      rbobj_to_nsobj(lasterr, &ocdata);
  }
  [info setObject: ocdata forKey: @"$!"];

  VALUE klass = rb_class_path(CLASS_OF(lasterr));
  NSString *rbclass = [NSString stringWithUTF8String:STR2CSTR(klass)];
  
  VALUE rbmessage = rb_obj_as_string(lasterr);
  NSString *message = [NSString stringWithUTF8String:STR2CSTR(rbmessage)];
  
  NSMutableArray *backtraceArray = [NSMutableArray array];
  VALUE ary = rb_funcall(ruby_errinfo, rb_intern("backtrace"), 0);
  int c;
  for (c=0; c<RARRAY(ary)->len; c++) {
      const char *path = STR2CSTR(RARRAY(ary)->ptr[c]);
      NSString *nspath = [NSString stringWithUTF8String:path];
      [backtraceArray addObject: nspath];
  }
  
  [info setObject: backtraceArray forKey: @"backtrace"];
  
  NSException* myException = [NSException
      exceptionWithName:[@"RBException_" stringByAppendingString: rbclass]
			 reason:message
			 userInfo:info];
  [myException raise];
}

static VALUE rbobject_protected_apply(VALUE a)
{
  VALUE *args = (VALUE*) a;
  return rb_apply(args[0],(RB_ID)args[1],(VALUE)args[2]);
}

- (void)rbobjForwardInvocation: (NSInvocation *)an_inv
{
  VALUE rb_args;
  VALUE rb_result;
  RB_ID mid;
  VALUE args[3];
  int err;

  RBOBJ_LOG("rbobjForwardInvocation(%@)", an_inv);
  mid = rb_obj_sel_to_mid(m_rbobj, [an_inv selector]);
  rb_args = [self fetchForwardArgumentsOf: an_inv];
  args[0] = m_rbobj;
  args[1] = mid;
  args[2] = rb_args;
  
  rb_result = rb_protect(rbobject_protected_apply,(VALUE)args,&err);
  if (err) {
      [self rbobjRaiseRubyException];
  }

  [self stuffForwardResult: rb_result to: an_inv];
  RBOBJ_LOG("   --> rb_result=%s", STR2CSTR(rb_inspect(rb_result)));
}

// public class methods
+ RBObjectWithRubyScriptCString: (const char*) cstr
{
  return [[[self alloc] initWithRubyScriptCString: cstr] autorelease];
}

+ RBObjectWithRubyScriptString: (NSString*) str
{
  return [[[self alloc] initWithRubyScriptString: str] autorelease];
}

// public methods

- (VALUE) __rbobj__  { return m_rbobj; }

- (void) dealloc
{
  remove_from_rb2oc_cache(m_rbobj);
  rb_gc_unregister_address (&m_rbobj);
  [super dealloc];
}

- initWithRubyObject: (VALUE)rbobj
{
  m_rbobj = rbobj;
  oc_master = nil;
  rb_gc_register_address (&m_rbobj);
  return self;
}

- initWithRubyScriptCString: (const char*) cstr
{
  return [self initWithRubyObject: rb_eval_string(cstr)];
}

- initWithRubyScriptString: (NSString*) str
{
  return [self initWithRubyScriptCString: [str UTF8String]];
}

- (NSString*) _copyDescription
{
  return [[[NSString alloc] initWithUTF8String: STR2CSTR(rb_inspect(m_rbobj))] autorelease];
}

- (BOOL)isKindOfClass: (Class)klass
{
  BOOL ret;
  RBOBJ_LOG("isKindOfClass(%@)", NSStringFromClass(klass));
  ret = NO;
  RBOBJ_LOG("   --> %d", ret);
  return ret;
}

- (BOOL)isRBObject
{
  return YES;
}

- (void)forwardInvocation: (NSInvocation *)an_inv
{
  RBOBJ_LOG("forwardInvocation(%@)", an_inv);
  if ([self rbobjRespondsToSelector: [an_inv selector]]) {
    RBOBJ_LOG("   -> forward to Ruby Object");
    [self rbobjForwardInvocation: an_inv];
  }
  else {
    RBOBJ_LOG("   -> forward to super Objective-C Object");
    [super forwardInvocation: an_inv];
  }
}

- (NSMethodSignature*)methodSignatureForSelector: (SEL)a_sel
{
  NSMethodSignature* ret = nil;
  RBOBJ_LOG("methodSignatureForSelector(%s)", a_sel);
  if (a_sel == NULL) return nil;
  if (oc_master != nil) 
    ret = [oc_master instanceMethodSignatureForSelector:a_sel];
  if (ret == nil)
    ret = [DummyProtocolHandler instanceMethodSignatureForSelector: a_sel];
  if (ret == nil)
    ret = [self rbobjMethodSignatureForSheetSelector: a_sel];
  if (ret == nil)
    ret = [self rbobjMethodSignatureForSelector: a_sel];
  RBOBJ_LOG("   --> %@", ret);
  return ret;
}

- (BOOL)respondsToSelector: (SEL)a_sel
{
  BOOL ret;
  RBOBJ_LOG("respondsToSelector(%s)", a_sel);
  ret = [self rbobjRespondsToSelector: a_sel];
  RBOBJ_LOG("   --> %d", ret);
  return ret;
}

@end

@implementation NSProxy (RubyCocoaEx)

- (BOOL)isRBObject
{
  return NO;
}

@end
