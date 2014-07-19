//
//  main.m
//  Spotlight
//
//  Created by Norberto Ortigoza on 9/11/05.
//  Copyright (c) 2005 __MyCompanyName__. All rights reserved.
//

#import <AppKit/NSApplication.h>
#import <RubyCocoa/RBRuntime.h>

int main(int argc, const char *argv[])
{
    RBApplicationInit("rb_main.rb", argc, (const char **)argv, nil);
    return NSApplicationMain(argc, (const char **)argv);
}
