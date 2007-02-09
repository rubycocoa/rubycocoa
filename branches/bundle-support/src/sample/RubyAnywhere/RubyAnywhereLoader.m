// -*- mode:objc; indent-tabs-mode:nil; coding:utf-8 -*-
//
//  RubyAnywhereLoader.m
//  RubyAnywhere
//
//  Created by Fujimoto Hisa on 07/02/01.
//  Copyright 2007 FOBJ SYSTEMS. All rights reserved.

static const char*     init_prog_name   = "ruby_anywhere_init.rb";
static const NSString* additional_param = @"additional param if need";

@interface RubyAnywhereLoader : NSObject
+ (void) install;
@end

@implementation RubyAnywhereLoader
+ (void) install {
  static int installed = 0;
  if (! installed) {
    if (RBBundleInit(init_prog_name, self, additional_param) == YES) {
      installed = 1;
      NSLog(@"RubyAnywhere: installed.");
    }
    else {
      NSLog(@"RubyAnywhere: failed to install.");
    }
  }
}
@end
