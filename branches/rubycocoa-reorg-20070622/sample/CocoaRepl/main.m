//
//  main.m
//  CocoaRepl
//
//  Created by Fujimoto Hisa on 07/02/26.
//  Copyright Fujimoto Hisa 2007. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <RubyCocoa/RubyCocoa.h>

int main(int argc, char *argv[])
{
  RBApplicationInit("ReplController.rb", argc, (const char**) argv, nil);
  return NSApplicationMain(argc,  (const char**) argv);
}
