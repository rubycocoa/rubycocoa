#import <Foundation/NSProxy.h>
#import <LibRuby/cocoa_ruby.h>

@interface RBProxy : NSProxy
{
  id    m_parent;
  VALUE m_rbobj;
}

- initWithRubyObject: (VALUE) rbobj parent: parent;
- initWithRubyObject: (VALUE) rbobj;
- (void) dealloc;

// - (NSString *)_copyDescription;

- (id)    __parent__;
- (VALUE) __rbobj__;

@end

@interface RBProxy(RBObject)
- init;
- initWithParent: parent;
- initWithClass: (Class)occlass;
- initWithClass: (Class)occlass parent: parent;
- initWithRubyClass: (VALUE)rbclass;
- initWithRubyClass: (VALUE)rbclass parent: parent;
@end

