/*
 * Copyright (c) 2006-2007, The RubyCocoa Project.
 * Copyright (c) 2001-2006, FUJIMOTO Hisakuni.
 * All Rights Reserved.
 *
 * RubyCocoa is free software, covered under either the Ruby's license or the
 * LGPL. See the COPYRIGHT file for more information.
 */

#import <Foundation/Foundation.h>
#import "ocdata_conv.h"

@interface RBCacheTestProbeCallback
- (void)callback:(id)obj;
@end

@interface RBCacheTestProbe : NSObject
@end

@implementation RBCacheTestProbe

+ (BOOL)deallocTestFor:(Class)klass with:(RBCacheTestProbeCallback*)target
{
  id obj = [[klass alloc] init];
  [target callback:obj];
  [obj release];
  return ocid_to_rbobj_cache_only(obj) != Qnil;
}

@end
