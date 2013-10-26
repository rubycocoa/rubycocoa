//
//  main.m
//  ÇPROJECTNAMEÈ
//
//  Created by ÇFULLUSERNAMEÈ on ÇDATEÈ.
//  Copyright (c) ÇYEARÈ ÇORGANIZATIONNAMEÈ. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <RubyCocoa/RBRuntime.h>

int main(int argc, const char *argv[])
{
    RBApplicationInit("rb_main.rb", argc, argv, nil);
    return NSApplicationMain(argc, argv);
}
