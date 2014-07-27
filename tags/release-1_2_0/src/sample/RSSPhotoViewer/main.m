//
//  main.m
//  RSSPhotoViewer
//
//  Created by Laurent Sansonetti on 2/6/07.
//  Copyright (c) 2007 Apple Computer. All rights reserved.
//

#import <AppKit/NSApplication.h>
#import <RubyCocoa/RBRuntime.h>

int main(int argc, const char *argv[])
{
    RBApplicationInit("rb_main.rb", argc, (const char **)argv, nil);
    return NSApplicationMain(argc, (const char **)argv);
}
