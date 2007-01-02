/** -*-objc-*-
 *
 *   $Id: /branches/thread-schedule/framework/src/objc/RBObject.h.in 980 2006-05-29T01:18:25.000000Z hisa  $
 *
 *   Copyright (c) 2001 FUJIMOTO Hisakuni
 *
 **/
#import <Foundation/NSProxy.h>
#import <RubyCocoa/osx_ruby.h>

@interface RBObject : NSProxy
{
  VALUE m_rbobj;
  id oc_master;
}

+ RBObjectWithRubyScriptCString: (const char*) cstr;
+ RBObjectWithRubyScriptString: (NSString*) str;

/* Caller is responsible to retain rbobj AND release the RBObject before rbobj dies. */
- initWithRubyObject: (VALUE) rbobj; 

/* If flag is true, the RBObject will be automatically autoreleased before rbobj dies. */
- initWithRubyObject: (VALUE) rbobj autoreleaseWhenRubyObjectDies:(BOOL)flag;

- initWithRubyScriptCString: (const char*) cstr;
- initWithRubyScriptString: (NSString*) str;

- (VALUE) __rbobj__;
- (BOOL) isKindOfClass:(Class)aClass;
- (BOOL) isRBObject;

@end

@interface NSProxy (RubyCocoaEx)

- (BOOL) isRBObject;

@end
