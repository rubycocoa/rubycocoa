#import <Cocoa/Cocoa.h>

extern void RubyInjectBundleInit(void) __attribute__ ((constructor));

void 
RubyInjectBundleInit(void) 
{
  NSLog(@"RubyInjectBundleInit!");
}
