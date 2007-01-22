#import <RubyCocoa/RBRuntime.h>

#import <Cocoa/Cocoa.h>
@interface MyView : NSView
@end

@implementation MyView

- (BOOL)knowsPageRange:(NSRangePointer)range 
{
  range->location = 1;
  range->length = 1;
  return YES;
}

@end

int main(int argc, const char *argv[])
{
    return RBApplicationMain("rb_main.rb", argc, argv);
}
