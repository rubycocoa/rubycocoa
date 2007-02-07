// -*- mode:objc; indent-tabs-mode:nil; coding:utf-8 -*-
//
//  VPRubyPluginEnabler.m
//  RubyPluginEnabler
//
//  Created by Fujimoto Hisa on 07/02/02.
//  Copyright 2007 Fujimoto Hisa. All rights reserved.

#import <Cocoa/Cocoa.h>
#import <VPPlugin/VPPlugin.h>
#import <RubyCocoa/RBRuntime.h>

@interface VPRubyPluginEnabler : VPPlugin
+ (VPRubyPluginEnabler*) realInstance;
- (void) didRegister;
@end

static VPRubyPluginEnabler* real_instance = nil;

@implementation VPRubyPluginEnabler
+ (VPRubyPluginEnabler*) realInstance { return real_instance; }

- (void) didRegister {
  if (! real_instance) {
    RBBundleInit("vpr_init.rb", [self class]);
    real_instance = self;
    NSLog(@"VPRubyPluginEnabler didRegister.");
  }
}
@end
