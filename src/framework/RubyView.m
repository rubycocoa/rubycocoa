#import <Cocoa/Cocoa.h>
#import <LibRuby/cocoa_ruby.h>
#import "RubyObject.h"
#import "RubyView.h"
#import "ocdata_conv.h"
#import <objc/objc-class.h>
#import <stdarg.h>

static id override_invoke(id rcv, SEL a_sel, ...)
{
  int i;
  va_list args;
  NSMethodSignature* msig;
  NSInvocation* inv;
  id retval = nil;
  msig = [rcv methodSignatureForSelector: a_sel];
  inv = [NSInvocation invocationWithMethodSignature: msig];
  [inv setSelector: a_sel];
  [inv setTarget: [rcv rbobj]];
  va_start(args, a_sel);
  for (i = 2; i < [msig numberOfArguments]; i++) {
    int octype = to_octype([msig getArgumentTypeAtIndex: i]);
    void* ocdata = ocdata_malloc_va_arg(args, octype); // r = va_arg(args, NSRect);
    if (ocdata) {
      [inv setArgument: ocdata atIndex: i];
      free(ocdata);
    }
    else {
      ; // errror
    }
  }
  va_end(args);
  [inv invoke];
  if ([msig methodReturnLength] > 0) {
    if (octype_object_p(to_octype([msig methodReturnType]))) {
      [inv getReturnValue: &retval];
    }
  }
  return retval;
}

static VALUE ruby_methods(VALUE rbobj)
{
  // rbobj.class.instance_methods - rbobj.class.superclass.instance_methods
  VALUE rbc = rb_funcall(rbobj, rb_intern("class"), 0);
  VALUE rbsc = rb_funcall(rbc, rb_intern("superclass"), 0);
  VALUE rbim = rb_funcall(rbc, rb_intern("instance_methods"), 0);
  if (rbsc != Qnil) {
    VALUE rbsim = rb_funcall(rbsc, rb_intern("instance_methods"), 0);
    rbim = rb_funcall(rbim, rb_intern("-"), 1, rbsim);
  }
  return rbim;
}

static void setup_override(Class nsclass, VALUE rbobj)
{
  static BOOL f_firsttime = YES;
  VALUE methods;
  int i,cnt;

  if (!f_firsttime) return;
  
  methods = ruby_methods(rbobj);
  cnt = RARRAY(methods)->len;
  for (i = 0; i < cnt; i++) {
    VALUE mstr = rb_ary_entry(methods, i);
    SEL sels[2];
    int j;
    sels[0] = rbobj_to_nssel(mstr);
    sels[1] = rbobj_to_nssel(rb_str_cat2(mstr, ":"));
    for (j = 0; j < sizeof(sels) - sizeof(SEL); j++) {
      Method me = class_getInstanceMethod(nsclass, sels[j]);
      if (me != NULL) {
	struct objc_method_list info;
	info.obsolete = NULL;
	info.method_count = 1;
	info.method_list[0] = *me;
	info.method_list[0].method_imp = override_invoke;
	class_addMethods(nsclass, &info);
	break;
      }
    }
  }
  f_firsttime = NO;
}  


@implementation RubyView

- rbobj { return rbobj; }

- initWithFrame:(NSRect)frame {
  [super initWithFrame:frame];
  rbobj = [RubyObject rubyObjectWithOCObject: self];
  setup_override([self class], [rbobj __rbobj__]);
  return self;
}

- (BOOL) respondsToSelector: (SEL)a_sel
{
  return ([super respondsToSelector: a_sel] 
	  || [rbobj respondsToSelector: a_sel]);
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)a_sel
{
  NSMethodSignature* msig;
  msig = [super methodSignatureForSelector: a_sel];
  if (msig == nil)
    msig = [rbobj methodSignatureForSelector: a_sel];
  return msig;
}

- (void)forwardInvocation:(NSInvocation *)an_inv
{
  if ([rbobj hasRubyHandlerForSelector: [an_inv selector]])
    [rbobj forwardInvocation: an_inv];
  else
    [super forwardInvocation: an_inv];
}

@end
