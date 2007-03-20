/** -*-objc-*-
 *
 *   $Id$
 *
 *   Copyright (c) 2001 FUJIMOTO Hisakuni
 *
 **/

#import <Foundation/NSObject.h>
#import <Foundation/NSTimer.h>
#import <sys/time.h>

@interface RBThreadSwitcher : NSObject
{
  id timer;
  struct timeval wait;
}
+ (void) start: (double)interval wait: (double) a_wait;
+ (void) start: (double)interval;
+ (void) start;
+ (void) stop;
@end
