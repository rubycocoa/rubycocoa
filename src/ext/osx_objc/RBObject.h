/** -*-objc-*-
 *
 *   $Id$
 *
 *   Copyright (c) 2001 FUJIMOTO Hisakuni <hisa@imasy.or.jp>
 *
 *   This program is free software.
 *   You can distribute/modify this program under the terms of
 *   the GNU Lesser General Public License version 2.
 *
 **/
#import <Foundation/NSProxy.h>
#import <Foundation/NSMethodSignature.h>
#import <Foundation/NSInvocation.h>
#import "osx_ruby.h"

@interface RBObject : NSProxy
{
  VALUE m_rbobj;
}

- initWithRubyObject: (VALUE) rbobj;
- initWithRubyScriptCString: (const char*) cstr;
- initWithRubyScriptString: (NSString*) str;

- (VALUE) __rbobj__;
- (BOOL) isKindOfClass:(Class)aClass;

@end

@interface RBObject(RBSlaveObject)
- init;
- initWithMasterObject: master;
- initWithClass: (Class)occlass;
- initWithClass: (Class)occlass masterObject: master;
- initWithRubyClass: (VALUE)rbclass;
- initWithRubyClass: (VALUE)rbclass masterObject: master;
@end
