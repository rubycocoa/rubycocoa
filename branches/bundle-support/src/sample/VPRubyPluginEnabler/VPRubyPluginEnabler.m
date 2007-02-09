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

static const char* init_prog_name   = "vpr_init.rb";

@interface VPRubyPluginEnabler : VPPlugin
- (void) didRegister;
@end

@implementation VPRubyPluginEnabler
- (void) didRegister {
  static int installed = 0;
  if (! installed) {
    if (RBBundleInit(init_prog_name, [self class], self) == YES) {
      installed = 1;
      NSLog(@"VPRubyPluginEnabler#didRegister => OK");
    }
    else {
      NSLog(@"VPRubyPluginEnabler#didRegister => NG");
    }
  }
}
@end
