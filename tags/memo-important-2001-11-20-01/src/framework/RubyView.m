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
#import <Cocoa/Cocoa.h>
#import <LibRuby/cocoa_ruby.h>
#import "RubyDelegator.h"
#import "RubyView.h"

// debug message
#define DLOG0(f)          if (ruby_debug == Qtrue) debug_log((f))
#define DLOG1(f,a1)       if (ruby_debug == Qtrue) debug_log((f),(a1))
#define DLOG2(f,a1,a2)    if (ruby_debug == Qtrue) debug_log((f),(a1),(a2))
#define DLOG3(f,a1,a2,a3) if (ruby_debug == Qtrue) debug_log((f),(a1),(a2),(a3))

static void debug_log(const char* fmt,...)
{
  if (ruby_debug == Qtrue) {
    id pool = [[NSAutoreleasePool alloc] init];
    NSString* nsfmt = [NSString stringWithFormat: @"RVIEW:%s", fmt];
    va_list args;
    va_start(args, fmt);
    NSLogv(nsfmt, args);
    va_end(args);
    [pool release];
  }
}

@implementation RubyView

- rubyDelegator { return rbdg; }

- initWithFrame:(NSRect)frame {
  [super initWithFrame:frame];
  rbdg = [RubyDelegator rubyDelegatorFor: self];
  return self;
}

- (BOOL) respondsToSelector: (SEL)a_sel
{
  DLOG1("respondsToSelector(%@)", NSStringFromSelector(a_sel));
  return ([super respondsToSelector: a_sel] 
	  || [rbdg respondsToSelector: a_sel]);
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)a_sel
{
  NSMethodSignature* msig;
  DLOG1("methodSignatureForSelector(%@)", NSStringFromSelector(a_sel));
  msig = [super methodSignatureForSelector: a_sel];
  if (msig == nil)
    msig = [rbdg methodSignatureForSelector: a_sel];
  return msig;
}

- (void)forwardInvocation:(NSInvocation *)an_inv
{
  DLOG1("forwardInvocation(%@)", an_inv);
  if ([rbdg hasRubyHandlerForSelector: [an_inv selector]])
    [rbdg forwardInvocation: an_inv];
  else
    [super forwardInvocation: an_inv];
}

@end
