#import <Foundation/NSProxy.h>
#import <Foundation/NSMethodSignature.h>
#import <Foundation/NSInvocation.h>
#import <LibRuby/cocoa_ruby.h>

@interface RBObject : NSProxy
{
  VALUE m_rbobj;
}

- initWithRubyObject: (VALUE) rbobj;
- (VALUE) __rbobj__;

- (BOOL) rbobjRespondsToSelector: (SEL)a_sel;
- (NSMethodSignature*) rbobjMethodSignatureForSelector: (SEL)a_sel;
- (void) rbobjForwardInvocation: (NSInvocation *)an_inv;

@end

@interface RBObject(RBSlaveObject)
- init;
- initWithMasterObject: master;
- initWithClass: (Class)occlass;
- initWithClass: (Class)occlass masterObject: master;
- initWithRubyClass: (VALUE)rbclass;
- initWithRubyClass: (VALUE)rbclass masterObject: master;
@end

