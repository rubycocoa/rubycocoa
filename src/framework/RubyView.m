#import <Cocoa/Cocoa.h>
#import <LibRuby/cocoa_ruby.h>
#import "RubyObject.h"
#import "RubyView.h"

@implementation RubyView

- rubyDelegator { return rbdg; }

- initWithFrame:(NSRect)frame {
  [super initWithFrame:frame];
  rbdg = [RubyObject rubyDelegatorFor: self];
  return self;
}

- (BOOL) respondsToSelector: (SEL)a_sel
{
  return ([super respondsToSelector: a_sel] 
	  || [rbdg respondsToSelector: a_sel]);
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)a_sel
{
  NSMethodSignature* msig;
  msig = [super methodSignatureForSelector: a_sel];
  if (msig == nil)
    msig = [rbdg methodSignatureForSelector: a_sel];
  return msig;
}

- (void)forwardInvocation:(NSInvocation *)an_inv
{
  if ([rbdg hasRubyHandlerForSelector: [an_inv selector]])
    [rbdg forwardInvocation: an_inv];
  else
    [super forwardInvocation: an_inv];
}

@end
