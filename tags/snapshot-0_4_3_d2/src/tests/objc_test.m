// $Id$
//
//   some tests require objc codes
#import <Foundation/Foundation.h>

@interface RBExceptionTestBase : NSObject
{
}
@end

@implementation RBExceptionTestBase
-(NSException *)testExceptionRoundTrip
{   
  NSException *result = nil;
  NS_DURING
      // defined in test/tc_exception.rb
      [self performSelector:@selector(testExceptionRaise)]; 
  NS_HANDLER
      result = localException;
  NS_ENDHANDLER
  return result;
}
@end

@interface Override : NSObject
{
}
@end

@implementation Override
-(int) foo
{   
  return 321;
}
@end

void Init_objc_test(){
  // dummy initializer for ruby's `require'
}
