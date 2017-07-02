/* 
 * Copyright (c) 2006-2008, The RubyCocoa Project.
 * Copyright (c) 2001-2006, FUJIMOTO Hisakuni.
 * All Rights Reserved.
 *
 * RubyCocoa is free software, covered under either the Ruby's license or the 
 * LGPL. See the COPYRIGHT file for more information.
 */

#import <Foundation/NSProxy.h>
#import <ruby.h>

/*!
 * @header RubyCocoa/RBObject.h
 * @abstract Defines @link RBObject @/link that is a proxy class of Ruby objects.
 * @unsorted
 */

/*!
 * @class RBObject
 * @abstract Representation of Ruby objects in Objective-C world.
 */
@interface RBObject : NSProxy
{
  VALUE m_rbobj;
  BOOL m_rbobj_retained;
  BOOL m_rbobj_retain_release_track;
  id oc_master;
}

/*!
 * @methodgroup Creating and Initializing RBObject objects
 */

/*!
 * @abstract Returns an object as result of evaluating the given ruby script.
 */
+ RBObjectWithRubyScriptCString: (const char*) cstr;

/*!
 * @abstract Returns an object as result of evaluating the given ruby script.
 */
+ RBObjectWithRubyScriptString: (NSString*) str;

/*!
 * @abstract Returns a RBObject object from given ruby VALUE.
 */
- initWithRubyObject: (VALUE) rbobj;
/*!
 * @abstract Returns a RBObject object as result of evaluating the given ruby script.
 */
- initWithRubyScriptCString: (const char*) cstr;
/*!
 * @abstract Returns a RBObject object as result of evaluating the given ruby script.
 */
- initWithRubyScriptString: (NSString*) str;

- (VALUE) __rbobj__;
- (BOOL) isKindOfClass:(Class)aClass;

/*!
 * @methodgroup Identifying Ruby Objects
 */

/*!
 * @abstract Ruturns a Boolean value that whether the reciever is a ruby object or not.
 * @result YES if the reciever is a Ruby object, otherwise NO.
 * @discussion RBObject is a subclass of NSProxy. Note that isKindOfClass:
 *             or isMemberOfClass: will not tests the proxy itself.
 */
- (BOOL) isRBObject;

@end

@interface NSProxy (RubyCocoaEx)

- (BOOL) isRBObject;

@end
