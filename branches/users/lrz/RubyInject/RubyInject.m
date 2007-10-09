//
//  RubyInject.m
//  RubyInject
//
//  Created by Laurent Sansonetti on 10/2/07.
//  Copyright 2007 Laurent Sansonetti. Some rights reserved. 
//  <http://creativecommons.org/licenses/by/2.0/>
//

#import "RubyInject.h"
#import "mach_inject_bundle.h"

@implementation RubyInject

+ (void)injectProcess:(pid_t)pid
{
  NSString *bundlePath;
  mach_error_t err;
  
  bundlePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"RubyInjectBundle" ofType:@"bundle"];
  err = mach_inject_bundle_pid([bundlePath fileSystemRepresentation], pid);
  if (err != err_none)
    NSLog(@"Failure code %d", err);
}

@end
