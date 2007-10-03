//
//  RubyInject.m
//  RubyInject
//
//  Created by Laurent Sansonetti on 10/2/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "RubyInject.h"
#import "mach_inject_bundle.h"

void 
MachInjectBundleLoaded (void)
{
  NSLog(@"MachInjectBundleLoaded!");
}

@implementation RubyInject

+ (void)injectProcess:(pid_t)pid
{
  NSString *bundlePath;
  mach_error_t err;
  
  bundlePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"RubyInjectBundle" ofType:@"bundle"];
NSLog(@"bundlePath is %@", bundlePath);
  err = mach_inject_bundle_pid([bundlePath fileSystemRepresentation], pid);
  if (err != err_none)
    NSLog(@"Failure code %d", err);
}

@end
