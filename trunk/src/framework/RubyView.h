#import <AppKit/NSView.h>

@interface RubyView : NSView
{
  id rbdg;
}

- initWithFrame:(NSRect)frame;
- rubyDelegator;

@end
