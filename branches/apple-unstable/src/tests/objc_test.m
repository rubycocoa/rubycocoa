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

@interface RetainCount : NSObject
{
}
@end

@implementation RetainCount

+(int) rbAllocCount
{
  int retainCount;
  id obj;
  obj = [NSClassFromString(@"RBSubclass") alloc];
  retainCount = [obj retainCount];
  [obj release];
  return retainCount;
}

+(int) rbInitCount
{
  int retainCount;
  id obj;
  obj = [[NSClassFromString(@"RBSubclass") alloc] init];
  retainCount = [obj retainCount];
  [obj release];
  return retainCount;
}

+(id) ocObject
{
  return [[NSObject alloc] init];
}

+(id) rbObject
{
  return [[NSClassFromString(@"RBSubclass") alloc] init];
}

@end

// tc_uniqobj.rb
@interface UniqObjC : NSObject
@end

@implementation UniqObjC

- (void)start:(id)o
{
    [o retain];
}

- (id)pass:(id)o
{
    return o;
}

- (void)end:(id)o
{
    [o release];
}

@end

// tc_passbyref.rb
@interface PassByRef : NSObject
@end

@implementation PassByRef

- (BOOL)passByRefObject:(id *)obj
{
    if (obj != NULL) {
        *obj = self;
        return YES;
    }
    return NO;
}

- (BOOL)passByRefInteger:(int *)integer
{
    if (integer != NULL) {
        *integer = 666;
        return YES;
    }
    return NO;
}

- (BOOL)passByRefFloat:(float *)floating
{
    if (floating != NULL) {
        *floating = 666.0;
        return YES;
    }
    return NO;
}

- (void)passByRefVarious:(id *)object integer:(int *)integer floating:(float *)floating
{
    if (object != NULL)
        *object = self;
    if (integer != NULL)
        *integer = 666;
    if (floating != NULL)
        *floating = 666.0;
}

@end

// tc_subclass.rb 
@interface __SkipInternalClass : NSData
@end
@implementation __SkipInternalClass {
}
@end

@interface SkipInternalClass : __SkipInternalClass
@end
@implementation SkipInternalClass {
}
@end

@interface CallerClass : NSObject
@end

@interface NSObject (TcSubclassFoo)

- (int)calledFoo:(id)arg;

@end

@implementation CallerClass

- (id)callFoo:(id)receiver
{
    return [receiver calledFoo:nil];
}

@end

void Init_objc_test(){
  // dummy initializer for ruby's `require'
}
