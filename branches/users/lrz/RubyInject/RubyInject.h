//
//  RubyInject.h
//  RubyInject
//
//  Created by Laurent Sansonetti on 10/2/07.
//  Copyright 2007 Laurent Sansonetti. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RubyInject : NSObject
{
}

+ (void)injectProcess:(pid_t)pid;

@end
