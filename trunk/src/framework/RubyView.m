#import <Cocoa/Cocoa.h>
#import "RubyObject.h"
#import "RubyView.h"

@implementation RubyView

- (id)initWithFrame:(NSRect)frame {
  [super initWithFrame:frame];
  rbobj = [RubyObject rubyObjectWithOCObject: self];
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

- (BOOL)isOpaque
{
  BOOL result;
  if ([rbobj hasRubyHandlerForSelector: @selector(isOpaque:)])
    return [rbobj isOpaque];
  else
    return [super isOpaque];
}

- (void)mouseUp: (NSEvent*)evt
{
  if ([rbobj hasRubyHandlerForSelector: @selector(mouseUp:)])
    [rbobj mouseUp: evt];
  else
    [super mouseUp: evt];
}

- (void)drawRect: (NSRect)rect
{
  if ([rbobj hasRubyHandlerForSelector: @selector(drawRect:)])
    [rbobj drawRect: rect];
  else
    [super drawRect: rect];
}

@end
