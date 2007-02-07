// -*- mode:objc; indent-tabs-mode:nil; coding:utf-8 -*-
//
//  RubyAnywhereLoader.m
//  RubyAnywhere
//
//  Created by Fujimoto Hisa on 07/02/01.
//  Copyright 2007 FOBJ SYSTEMS. All rights reserved.

@interface RubyAnywhereLoader : NSObject
+ (void) install;
@end

@implementation RubyAnywhereLoader
+ (void) install {
  static int installed = 0;
  if (! installed) {
    RBBundleInit("ruby_anywhere_init.rb", self);
    installed = 1;
    NSLog(@"RubyAnywhere: installed.");
  }
}
@end
