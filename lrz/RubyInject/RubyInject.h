//
//  RubyInject.h
//  RubyInject
//
//  Created by Laurent Sansonetti on 10/2/07.
//  Copyright 2007 Laurent Sansonetti. Some rights reserved. 
//  <http://creativecommons.org/licenses/by/2.0/>
//

#import <Cocoa/Cocoa.h>

@interface RubyInject : NSObject
{
}

+ (void)injectProcess:(pid_t)pid;

@end
