//
//  main.m
//  ViewModel Test
//
//  Created by Jim Getzen on 8/1/06.
//  Copyright (c) 2006 __MyCompanyName__. All rights reserved.
//

#import <AppKit/NSApplication.h>
#import <RubyCocoa/RBRuntime.h>

int main(int argc, const char *argv[])
{
    RBApplicationInit("rb_main.rb", argc, (const char **)argv, nil);
    return NSApplicationMain(argc, (const char **)argv);
}
